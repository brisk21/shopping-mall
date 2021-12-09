<?php
//微信支付回调

namespace app\payment\controller;


use app\common\controller\AppCommon;
use app\service\ConfigService;
use app\service\Credits;
use app\service\DiyLog;
use app\service\Order as ServerOrder;
use think\Controller;
use think\Db;

class Wxnotify implements \Payment\Contracts\IPayNotify
{
    /**
     * @param string $channel 通知的渠道，如：支付宝、微信、招商
     * @param string $notifyType 通知的类型，如：支付、退款
     * @param string $notifyWay 通知的方式，如：异步 async，同步 sync
     * @param array $notifyData 通知的数据
     * @return bool
     */
    public function handle(
        string $channel,
        string $notifyType,
        string $notifyWay,
        array $notifyData
    )
    {
        //"appid": "wxabf25bbf4a9669ec",
        //"attach": "1",
        //"bank_type": "OTHERS",
        //"cash_fee": "1",
        //"fee_type": "CNY",
        //"is_subscribe": "Y",
        //"mch_id": "1541322751",
        //"nonce_str": "mhhqa0jqfq03l2k3npwabwf05x01ufre",
        //"openid": "oQ9zN5suzbERCewHG685pRc5F7-4",
        //"out_trade_no": "16377636731797",
        //"result_code": "SUCCESS",
        //"return_code": "SUCCESS",
        //"sign": "238CE8AD005AD8BE2C8805E7C89741A3",
        //"time_end": "20211124222118",
        //"total_fee": "1",
        //"trade_type": "JSAPI",
        //"transaction_id": "4200001297202111247661741775"
        if (empty($notifyData['out_trade_no']) || $notifyData['result_code'] <> 'SUCCESS' || $notifyData['return_code'] <> 'SUCCESS') {
            return false;
        }

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
            return $ret;
        }
        //日志
        DiyLog::file([$channel, $notifyType, $notifyWay, $notifyData], 'wxnotify');
        return true;
    }

    public function index()
    {
        $config = config('wechat');
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