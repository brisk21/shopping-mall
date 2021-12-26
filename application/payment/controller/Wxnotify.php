<?php
//微信支付回调

namespace app\payment\controller;


use AlibabaCloud\SDK\Dysmsapi\V20170525\Models\AddShortUrlResponseBody\data;
use app\common\controller\AppCommon;
use app\service\ConfigService;
use app\service\Credits;
use app\service\DiyLog;
use app\service\Order as ServerOrder;
use app\service\Pay;
use think\Controller;
use think\Db;

class Wxnotify implements \Payment\Contracts\IPayNotify
{
    /**
     * @param string $channel 通知的渠道，如：支付宝、微信(Wechat)、招商
     * @param string $notifyType 通知的类型，如：支付(pay)、退款
     * @param string $notifyWay 通知的方式，如：异步 async，同步 sync
     * @param array $notifyData 通知的数据
     * @return bool
     */
    public function handle(string $channel, string $notifyType, string $notifyWay, array $notifyData)
    {
        if (empty($notifyData['out_trade_no']) || $notifyData['result_code'] <> 'SUCCESS' || $notifyData['return_code'] <> 'SUCCESS') {
            return false;
        }
        $channel = strtolower($channel);
        if ($channel <> 'wechat') {
            //todo 扩展其他方式支付回调
            return false;
        }

        //wx-商品支付，recharge-余额充值
        $type = $notifyData['attach'];
        if ($type == 'wx') {
            $order = ServerOrder::get($notifyData['out_trade_no']);
            if ($order['status'] == 0) {
                //事务提交
                $ret = null;
                Db::transaction(function () use ($order, $notifyData, &$ret) {
                    //更新订单
                    $data = [
                        'pay_price' => $notifyData['total_fee'] / 100,
                        'pay_time' => strtotime($notifyData['time_end']),
                        'up_time' => time(),
                        'status' => 1,
                        'pay_type' => 'wechat',
                        'trans_id' => $notifyData['transaction_id'],
                        'pay_openid' => $notifyData['openid'],
                    ];
                    if (in_array($order['order_type'], [2, 4])) {
                        $data['code_tihuo'] = get_random(6, true);
                        while (true) {
                            $hasCode = AppCommon::data_count('order', ['code_tihuo' => $data['code_tihuo']]);
                            if (empty($hasCode)) {
                                break;
                            }
                            $data['code_tihuo'] = get_random(6, true);
                        }
                    }
                    $up = ServerOrder::update($order['order_sn'], $data);

                    if (!$up) {
                        $ret = false;
                        return;
                    }

                    //更新库存
                    $orderGoods = AppCommon::data_list('order_goods', ['order_sn' => $order['order_sn']], '1,50', 'goods_id,count');
                    if (!empty($orderGoods)) {
                        foreach ($orderGoods as $v) {
                            //直接减少锁库的量即可
                            AppCommon::db('goods')->where(['id' => $v['goods_id']])->setDec('stock_locked', $v['count']);
                            //增加销量
                            AppCommon::db('goods')->where(['id' => $v['goods_id']])->setInc('sale', $v['count']);
                        }
                    }

                    $ret = true;
                    //赠送积分
                    $conf = ConfigService::get('mobile_shop');
                    if (!empty($conf['gift_order_point'])) {
                        //积分奖励
                        $num = $order['price'] >= 1 ? intval($order['price'] * $conf['gift_order_point']) : $conf['gift_order_point'];
                        $res = Credits::update($order['uid'], 'point', $num, [
                            'remark' => '下单赠送',
                        ]);
                    }

                });
                if ($ret) {
                    $this->success();
                }
                return $ret;
            }
        } elseif ($type == 'recharge') {
            $order = AppCommon::data_get('order_recharge', ['order_sn' => $notifyData['out_trade_no']]);
            if ($order['status'] == 0) {
                //事务提交
                $ret = null;
                Db::transaction(function () use ($order, $notifyData, &$ret) {
                    //更新订单
                    $data = [
                        'pay_price' => $notifyData['total_fee'] / 100,
                        'pay_time' => strtotime($notifyData['time_end']),
                        'up_time' => time(),
                        'status' => 1,
                        'pay_type' => 'wechat',
                        'trans_id' => $notifyData['transaction_id'],
                        'pay_openid' => $notifyData['openid'],
                    ];
                    $up = AppCommon::data_update('order_recharge', ['id' => $order['id']], $data);
                    if (!$up) {
                        $ret = false;
                        return;
                    }

                    //更新余额
                    $r = Credits::set($order['uid'], 'credit', $data['pay_price'], ['remark' => '通过微信充值', 'type' => 2]);
                    if (!$r) {
                        $ret = false;
                        return;
                    }


                    $ret = true;
                    //赠送积分
                    $conf = ConfigService::get('mobile_shop');
                    if (!empty($conf['gift_order_point'])) {
                        //积分奖励
                        $num = $order['price'] >= 1 ? intval($order['price'] * $conf['gift_order_point']) : $conf['gift_order_point'];
                        $res = Credits::update($order['uid'], 'point', $num, [
                            'remark' => '余额充值赠送',
                        ]);
                    }

                });
                if ($ret) {
                    $this->success();
                }
                return $ret;
            }
            if (!empty($order) || $order['status'] >= 1) {
                $this->success();
            }
        }


        //日志
        DiyLog::file([$channel, $notifyType, $notifyWay, $notifyData], 'wxnotify.log');
        return true;
    }

    public function success()
    {
        ob_clean();
        echo '<xml><return_code><![CDATA[SUCCESS]]></return_code><return_msg><![CDATA[OK]]></return_msg></xml>';
        exit();
    }

    public function index()
    {
        $config = Pay::get_wx_config();
        $proxy = \Payment\Client::WECHAT;
        try {
            $client = new \Payment\Client($proxy, $config);
            $xml = $client->notify(new self());
        } catch (\InvalidArgumentException $e) {
            echo $e->getMessage();
            exit;
        } catch (\Payment\Exceptions\GatewayException $e) {
            echo $e->getMessage();
            exit;
        } catch (\Payment\Exceptions\ClassNotFoundException $e) {
            echo $e->getMessage();
            exit;
        } catch (\Exception $e) {
            echo $e->getMessage();
            exit;
        }


    }


}