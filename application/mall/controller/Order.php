<?php


namespace app\mall\controller;


use app\common\controller\AppCommon;
use app\mall\controller\com\Mall;
use app\service\AdminMsg;
use app\service\ConfigService;
use app\service\Credits;
use app\service\DiyLog;
use app\service\ErrorService;
use app\service\Msg;
use app\service\Pay;
use app\service\SafeService;
use base\Express;
use think\Db;
use app\service\Order as ServerOrder;
use think\Request;

class Order extends Mall
{
    public $whiteList = [
        'mall/order/express',
    ];
    /**
     * 店铺的配置
     * @var array|mixed
     */
    private $config_shop;

    public function __construct(Request $request = null)
    {
        parent::__construct($request);
        $this->config_shop = ConfigService::get('mobile_shop');
    }

    //立即购买单品
    public function info()
    {
        return $this->fetch();
    }

    //批量下单-购物车
    public function info2()
    {
        return $this->fetch();
    }

    //订单详情
    public function detail()
    {
        $this->order_info();
        return $this->fetch();
    }

    private function order_info()
    {
        if (IS_AJAX) {
            if (empty($this->param['order_sn'])) {
                data_return('订单号缺失', -1);
            }

            $order = ServerOrder::get(trim($this->param['order_sn']));
            if (empty($order) || $order['is_del']) {
                data_return('订单找不到了', -1);
            }
            $order['address'] = json_decode($order['address'], true);
            $address = $order['address'];

            $goods = AppCommon::data_list('order_goods', ['order_sn' => $order['order_sn']], '1,50');

            $order['refund'] = AppCommon::data_get('order_refund_apply_log', ['order_sn' => $order['order_sn'], 'status' => 0]);

            foreach ($goods as &$v) {
                $v['commented'] = AppCommon::data_get('goods_comment', ['order_goods_id' => intval($v['id'])], 'id');
            }
            unset($v);

            data_return('ok', 0, [
                'order' => $order,
                'address' => $address,
                'goods_list' => $goods
            ]);
        }
    }

    //评价页面
    public function detail2()
    {
        $this->order_info();
        return $this->fetch();
    }

    //我的订单
    public function all_orders()
    {
        return $this->fetch();
    }

    //我的订单
    public function my_orders()
    {
        $where = ['uid' => $this->uid];
        $page = !empty($this->param['page']) ? intval($this->param['page']) : 1;
        $status = isset($this->param['status']) && is_numeric($this->param['status']) ? intval($this->param['status']) : '';
        if (is_numeric($status)) {
            //-1-已取消，0-待支付，1-已支付，2-待收货，3-已完，-2-已退款
            $where['status'] = $status;
        }
        $where['is_del'] = 0;
        $orders = AppCommon::data_list('order', $where, $page, 'order_sn,price,status,pay_time,pay_price,add_time,order_type,code_tihuo,tihuo_address,express_no', 'id desc');

        if (!empty($orders)) {
            foreach ($orders as &$order) {
                $order['goods_list'] = AppCommon::data_list('order_goods', ['order_sn' => $order['order_sn']], 1, '*');
            }
            unset($order);
        }

        data_return('ok', 0, [
            'orders' => $orders
        ]);
    }

    //预生成订单
    public function ready($id = 0)
    {
        //来自商品直接购买
        if (!empty($id)) {
            $goods = AppCommon::data_get('goods', ['id' => intval($id)], 'thumb,title,price,status,stock,stock_locked,store_num');
            if (empty($goods) || $goods['status'] <> 1 || ($goods['stock'] - $goods['stock_locked']) <= 0) {
                data_return('商品已售罄', -1);
            }
            $whereAddr = ['uid' => $this->uid,];
            if (!empty($this->param['addr_id'])) {
                $whereAddr['id'] = intval($this->param['addr_id']);
            } else {
                $whereAddr['is_default'] = 1;
            }
            $address = AppCommon::data_get('common_user_address', $whereAddr);

            $goods['count'] = !empty($this->param['count']) ? intval($this->param['count']) : 1;
            if (($goods['stock'] - $goods['stock_locked']) < $goods['count']) {
                data_return('库存不足', -1);
            }
            $order = [
                'totalMoney' => sprintf("%0.2f", $goods['count'] * $goods['price'])
            ];

            data_return('ok', 0, [
                'order' => $order,
                'address' => $address,
                'goods_list' => [$goods]
            ]);

        } else {
            //从购物车下单
            $goods = $this->check_status();
            $whereAddr = ['uid' => $this->uid,];
            if (!empty($this->param['addr_id'])) {
                $whereAddr['id'] = intval($this->param['addr_id']);
            } else {
                $whereAddr['is_default'] = 1;
            }
            $address = AppCommon::data_get('common_user_address', $whereAddr);

            $totalMoney = 0;
            foreach ($goods as &$val) {
                $val['totalPrice'] = sprintf('%.02f', $val['price'] * $val['count']);
                $totalMoney += $val['totalPrice'];
            }
            unset($val);
            $order = [
                'totalMoney' => sprintf("%0.2f", $totalMoney)
            ];
            data_return('ok', 0, [
                'order' => $order,
                'address' => $address,
                'goods_list' => $goods
            ]);
        }

    }

    //检查选择的购物车商品
    private function check_status()
    {
        $goods = AppCommon::db('cart a')
            ->join('goods b', 'b.id = a.goods_id')
            ->join('stores c', 'b.store_num = c.store_num')
            ->where(['a.uid' => $this->uid, 'a.status' => 1])
            ->field('b.title,b.price,b.thumb,a.id,a.count,b.status,a.goods_id,b.id as bid,b.stock,b.stock_locked,c.store_name,c.store_num')
            ->select();

        if (empty($goods)) {
            data_return('商品未选择', -1);
        }
        foreach ($goods as $item) {
            if (empty($item['bid']) || ($item['stock'] <= 0) || $item['status'] <> 1) {
                data_return('存在已下架或已售罄商品', -1);
            }
            if ($item['stock'] < $item['count']) {
                data_return($item['title'] . '库存不足', -1);
            }
        }

        return $goods;
    }

    //创建订单
    public function create()
    {
        $ckey = 'order_create' . md5($this->uid . __FILE__ . __FUNCTION__ . 'ABC');
        if (cache($ckey)) {
            data_return('操作过于频繁，请稍后...', -1);
        }
        cache($ckey, 1, 10);

        $shop_type = empty($this->config_shop['shop_type']) ? 0 : intval($this->config_shop['shop_type']);
        if (!empty($this->param['id'])) {
            //立即购买
            $goods = AppCommon::data_get('goods', ['id' => intval($this->param['id'])], 'id,thumb,title,price,status,stock,stock_locked,store_num');
            if (empty($goods) || $goods['status'] <> 1 || ($goods['stock']) <= 0) {
                cache($ckey, null);
                data_return('商品已售罄', -1);
            }

            //默认销售，0-销售，1-展示，2-自提，3-虚拟销售
            if ($shop_type == 0) {
                if (empty($this->param['addr_id'])) {
                    cache($ckey, null);
                    data_return('请选则地址', -1);
                }
                $whereAddr = ['uid' => $this->uid,];
                $whereAddr['id'] = intval($this->param['addr_id']);
                $address = AppCommon::data_get('common_user_address', $whereAddr);
                if (empty($address)) {
                    cache($ckey, null);
                    data_return('地址不存在', -1);
                }
            }


            $goods['count'] = !empty($this->param['count']) ? intval($this->param['count']) : 1;
            if ($goods['stock'] < $goods['count']) {
                cache($ckey, null);
                data_return('库存不足', -1);
            }

            $totalPrice = floatval($goods['count'] * $goods['price']);

            $arg = [
                'address' => !empty($address) ? $address : null,
                'price' => $totalPrice,
                'uid' => $this->uid,
                'store_num' => $goods['store_num'],
                'order_type' => $shop_type,
                'tihuo_address' => !empty($this->config_shop['shop_address_tihuo']) ? $this->config_shop['shop_address_tihuo'] : ''
            ];

            $res = ServerOrder::add($arg);

            if ($res['code'] <> 0) {
                cache($ckey, null);
                data_return('服务正忙，请稍后', -1);
            }

            //添加商品
            $resGoods = ServerOrder::add_order_goods([
                'order_sn' => $res['data']['order_sn'],
                'goods_id' => $goods['id'],
                'count' => $goods['count'],
                'thumb' => $goods['thumb'],
                'price' => $goods['price'],
                'title' => $goods['title'],
            ]);
            if (!$resGoods) {
                //删除无效订单
                AppCommon::data_del('order', ['order_sn' => $res['data']['order_sn']]);
                cache($ckey, null);
                data_return('服务正忙，请稍后', -1);
            }

            //锁库
            AppCommon::data_update('goods', ['id' => $goods['id']], ['stock_locked' => $goods['count'] + $goods['stock_locked'], 'stock' => $goods['stock'] - $goods['count']]);

            data_return('ok', 0, $res['data']);
        } else {
            $address = '';
            $goods = $this->check_status();

            //默认销售，0-销售，1-展示，2-自提，3-虚拟销售
            if ($shop_type == 0) {
                if (empty($this->param['addr_id'])) {
                    cache($ckey, null);
                    data_return('请选择地址', -1);
                }
                $whereAddr = ['uid' => $this->uid,];
                $whereAddr['id'] = intval($this->param['addr_id']);
                $address = AppCommon::data_get('common_user_address', $whereAddr);
                if (empty($address)) {
                    cache($ckey, null);
                    data_return('地址不存在', -1);
                }

            }


            $totalMoney = 0;
            foreach ($goods as $val) {
                $val['totalPrice'] = round($val['price'] * $val['count'], 2);
                $totalMoney += $val['totalPrice'];
            }
            //目前这个版本是一个店铺,todo 扩展多店铺版本
            $ret = [];
            Db::transaction(function () use ($address, $totalMoney, $goods, $shop_type, &$ret) {
                $arg = [
                    'address' => $address,
                    'price' => $totalMoney,
                    'uid' => $this->uid,
                    'store_num' => $goods[0]['store_num'],
                    'order_type' => $shop_type,
                    'tihuo_address' => !empty($this->config_shop['shop_address_tihuo']) ? $this->config_shop['shop_address_tihuo'] : ''
                ];

                $res = ServerOrder::add($arg);
                if ($res['code'] <> 0) {
                    $ret = false;
                    return;
                }

                $order_sn = $res['data']['order_sn'];
                foreach ($goods as $value) {
                    $trest = ServerOrder::add_order_goods([
                        'order_sn' => $order_sn,
                        'goods_id' => $value['id'],
                        'count' => $value['count'],
                        'thumb' => $value['thumb'],
                        'price' => $value['price'],
                        'title' => $value['title'],
                    ]);
                    if (!$trest) {
                        $ret = false;
                        return;
                    }
                    //锁库
                    AppCommon::db('goods')->where(['id' => $value['goods_id']])->setDec('stock', $value['count']);
                    AppCommon::db('goods')->where(['id' => $value['goods_id']])->setInc('stock_locked', $value['count']);
                }
                //清理对应的购物车
                AppCommon::data_del('cart', ['uid' => $this->uid, 'status' => 1]);

                return $ret = $res;
            });
            if ($ret) {
                data_return('ok', 0, $ret['data']);
            }
            cache($ckey, null);
            data_return('创建超时，请稍后重试', -1);

        }
    }

    //余额支付
    public function pay()
    {
        if (empty($this->param['order_sn'])) {
            data_return('单号未设置', -1);
        } elseif (empty($this->param['payType']) || !in_array(trim($this->param['payType']), ['credit'])) {
            data_return('不支持的支付方式', -1);
        }
        $ckey = 'order_pay' . md5($this->uid . __FUNCTION__ . __FILE__);
        if (cache($ckey)) {
            data_return('付款中，请稍后...', -1);
        }
        cache($ckey, 1, 2);
        $order = ServerOrder::get($this->param['order_sn']);

        if (empty($order)) {
            data_return('订单不存在', -1);
        }/*elseif ($order['uid']<>$this->uid){
            data_return('仅限操作自己的订单',-1);
        }*/
        //-1-已取消，0-待支付，1-已支付，2-待收货，3-已完，-2-已退款
        if ($order['status'] >= 1) {
            data_return('订单已付款，请勿重复支付', -1);
        }
        if ($order['cancel_pay_time'] < time()) {
            data_return('订单已超过可支付时间', -1);
        }

        $creditInfo = Credits::get($this->uid, 'credit');

        if (empty($creditInfo['credit']) || $creditInfo['credit'] < $order['price']) {
            data_return('您的余额不足，请先充值后使用', -1);
        }

        //事务提交
        $ret = null;
        Db::transaction(function () use ($order, $creditInfo, &$ret) {

            //扣除余额
            $res1 = Credits::update($this->uid, 'credit', -$order['price'], [
                'remark' => '商品支付',
                'type' => 1,
            ]);
            if (!$res1) {
                $ret = false;
                return;
            }


            //更新订单
            $data = [
                'pay_price' => $order['price'],
                'pay_time' => time(),
                'up_time' => time(),
                'status' => 1,
                'pay_type' => $this->param['payType'],
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
        });

        if ($ret) {
            //赠送积分
            $conf = ConfigService::get('mobile_shop');
            if (!empty($conf['gift_order_point'])) {
                //积分奖励
                $num = $order['price'] >= 1 ? intval($order['price'] * $conf['gift_order_point']) : $conf['gift_order_point'];
                $res = Credits::update($order['uid'], 'point', $num, [
                    'remark' => '下单赠送',
                ]);
            }
            //后台静态消息
            AdminMsg::add([
                'title' => '新订单付款通知',
                'content' => '客户付款了，订单编号：' . $order['order_sn'] . '，尽快安排发货可以有效提高成交率哦。',
                'msg_type' => 'order'
            ]);

            data_return('支付成功', 0, ['order_sn' => $order['order_sn']]);
        }
        data_return('系统忙碌，稍后再试', -1);

    }

    //删除订单
    public function del()
    {
        if (empty($this->param['order_sn'])) {
            data_return('订单号未找到', -1);
        }
        $order = ServerOrder::get($this->param['order_sn']);

        if (empty($order)) {
            data_return('订单不存在', -1);
        } elseif ($order['uid'] <> $this->uid) {
            data_return('仅限操作自己的订单', -1);
        }
        $res = ServerOrder::del($this->param['order_sn']);

        data_return($res ? '删除成功' : '系统正忙，请稍后重试', $res ? 0 : -1);
    }

    //微信支付参数
    public function wx_param()
    {
        if (empty($this->param['order_sn'])) {
            data_return('订单号未找到', -1);
        }
        $order = ServerOrder::get($this->param['order_sn']);
        if (empty($order)) {
            data_return('订单未找到', -1);
        }
        //非微信环境H5支付
        if (isMobile() && fromClient() <> 'weixin') {
            $param['order'] = $order;
            $param['url'] = URL_WEB . trim(url('my_orders'), '/');
            $param['redirect_url'] = URL_WEB . trim(url('all_orders'), '/');
            $res = Pay::wx_h5($param);
            if ($res['code'] <> 0) {
                data_return($res['msg'], -1);
            }
            data_return('ok', 0, ['payParam' => $res['data']]);
        } else {
            parent::wx_env();
            $openid = cookie('my_gzh_openid');
            if (empty($openid)) {
                data_return('请在微信环境进行微信支付', -1);
            }
            $res = Pay::wx_pub($order);
            if ($res['code'] <> 0) {
                data_return($res['msg'], -1);
            }
            data_return('ok', 0, ['payParam' => $res['data']]);
        }
    }

    //退款页面
    public function refund()
    {
        return $this->fetch();
    }

    //申请退款
    public function refund_apply()
    {
        if (empty($this->param['order_sn'])) {
            data_return('订单号未找到', -1);
        }
        if (empty($this->param['money'])) {
            data_return('申请金额未设置', -1);
        }
        if (empty($this->param['reason'])) {
            data_return('退款原因未设置', -1);
        }
        $order = ServerOrder::get($this->param['order_sn']);
        if (empty($order)) {
            data_return('订单未找到', -1);
        } elseif (!in_array($order['status'], [1, 3])) {
            data_return('订单状态不支持退款', -1);
        } elseif ($order['refund_total'] >= $order['pay_price']) {
            data_return('该订单累计退款金额已达上限', -1);
        } elseif ($order['uid'] <> $this->uid) {
            data_return('仅限操作自己的订单', -1);
        }
        $money = trim($this->param['money']);
        if (($order['pay_price'] - $order['refund_total']) < $money) {
            data_return('申请金额大于可退款金额' . $order['pay_price'], -1);
        }
        $has = AppCommon::data_get('order_refund_apply_log', ['order_sn' => $order['order_sn'], 'status' => 0]);
        if (!empty($has)) {
            data_return('您有待处理的申请，请勿重复提交', -1);
        }
        $res = AppCommon::data_add('order_refund_apply_log', [
            'uid' => $this->uid,
            'order_sn' => $order['order_sn'],
            'add_time' => time(),
            'up_time' => time(),
            'apply_reason' => strip_tags($this->param['reason']),
            'apply_type' => intval($this->param['type']),
            'apply_money' => $money,
            'status' => 0,
        ]);
        data_return('提交申请成功', 0);
    }

    //取消售后申请
    public function refund_cancel()
    {
        if (empty($this->param['order_sn'])) {
            data_return('订单号未找到', -1);
        }
        $order = ServerOrder::get($this->param['order_sn']);
        if (empty($order)) {
            data_return('订单未找到', -1);
        } elseif ($order['uid'] <> $this->uid) {
            data_return('仅限操作自己的订单', -1);
        }

        $has = AppCommon::data_get('order_refund_apply_log', ['order_sn' => $order['order_sn'], 'status' => 0]);
        if (empty($has)) {
            data_return('未找到待处理的申请', -1);
        }
        AppCommon::data_del('order_refund_apply_log', ['id' => $has['id']]);
        data_return('取消成功', 0);
    }

    //充值
    public function recharge()
    {
        if (empty($this->param['money']) || $this->param['money'] <= 0 || $this->param['money'] >= 500) {
            data_return('充值金额不合法', -1);
        }

        $res = ServerOrder::recharge_create([
            'price' => $this->param['money'],
            'pay_type' => 'wechat',
            'uid' => $this->uid
        ]);
        if ($res['code'] <> 0) {
            data_return($res['msg'], -1);
        }
        $order = AppCommon::data_get('order_recharge', ['order_sn' => $res['data']['order_sn']]);

        $ret = Pay::wx_recharge($order);
        if ($ret['code'] <> 0) {
            data_return($ret['msg'], -1);
        }
        data_return('ok', 0, ['payParam' => $ret['data'], 'order_sn' => $res['data']['order_sn']]);
    }

    //确认收货
    public function receive()
    {
        if (empty($this->param['order_sn'])) {
            data_return('订单号未找到', -1);
        }
        $order = ServerOrder::get($this->param['order_sn']);

        if (empty($order)) {
            data_return('订单不存在', -1);
        } elseif ($order['uid'] <> $this->uid) {
            data_return('仅限操作自己的订单', -1);
        }
        $newData = [
            'status' => 3,
            'up_time' => time(),
            'receive_time' => time(),
        ];
        //提货
        if ($order['order_type'] == 2) {
            $newData['send_time'] = time();
        }
        $res = ServerOrder::update($order['order_sn'], $newData);
        if ($res) {
            Msg::add($order['uid'], [
                'title' => '确认收货成功',
                'content' => '您购买的商品已被确认收货，若不是您自己操作，请联系商家',
                'type' => 1
            ]);
        }
        data_return('收货成功');
    }

    //评论发布
    public function comment_action()
    {
        $rule = [
            ['type' => 'length', 'key' => 'star', 'rule' => '1,5', 'msg' => '星星在1~5个哦',],
            ['type' => 'length', 'key' => 'content', 'rule' => '5,200', 'msg' => '请填写评价内容，5个字以上',],
            ['type' => 'empty', 'key' => 'ord_id', 'rule' => '', 'msg' => '参数有误',],
            ['type' => 'empty', 'key' => 'from', 'rule' => '', 'msg' => '参数有误',],
        ];
        $check = check_param($this->param, $rule);
        if ($check['code'] <> 0) {
            data_return($check['msg'], $check['code']);
        }
        $from = trim($this->param['from']);
        $id = intval($this->param['ord_id']);
        $orderGoods = AppCommon::data_get('order_goods', ['id' => $id]);
        if (empty($orderGoods)) {
            data_return('订单参数有误', -1);
        }
        if ($from == 'del') {
            $log = AppCommon::data_get('goods_comment', ['order_goods_id' => $orderGoods['id']]);
            if (empty($log) || $log['uid'] <> $this->uid) {
                data_return('仅限操作自己的评价', -1);
            }
            AppCommon::data_del('goods_comment', ['id' => $log['id']]);
            Msg::add($this->uid, [
                'title' => '删除商品评价',
                'content' => '您删除了对商品的评价',
                'type' => 1
            ]);
            data_return('评价已删除', -1);
        }


        if (!empty($this->param['imgs'])) {
            if (!is_array($this->param['imgs'])) {
                $this->param['imgs'] = array_filter(explode(',', str_replace('，', ',', $this->param['imgs'])));
            }
        }
        if (!empty($this->param['imgs']) && count($this->param['imgs']) > 3) {
            data_return('图片不能超过3张', -1);
        }

        $order = ServerOrder::get($orderGoods['order_sn'], 'uid,status');
        if (empty($order)) {
            data_return('订单参数有误', -1);
        } elseif ($order['uid'] <> $this->uid) {
            data_return('仅限操作自己的订单评价', -1);
        } elseif ($order['status'] <> 3) {
            data_return('仅限确认收货的订单评价', -1);
        }

        $has = AppCommon::data_get('goods_comment', ['goods_id' => $orderGoods['goods_id'], 'order_goods_id' => $id], 'id');
        if (!empty($has['id'])) {
            data_return('您已提交评价，请勿重复提交', -1);
        }
        $content = SafeService::filter_str(strip_tags($this->param['content']));
        $imgs = !empty($this->param['imgs']) ? join(',', $this->param['imgs']) : '';
        AppCommon::data_add('goods_comment', [
            'uid' => $this->uid,
            'goods_id' => $orderGoods['goods_id'],
            'content' => $content,
            'star' => intval($this->param['star']),
            'add_time' => time(),
            'imgs' => $imgs,
            'is_hide_user' => !empty($this->param['isHidden']) ? 1 : 0,
            'order_goods_id' => $orderGoods['id'],
            //0-待审核，1-已通过
            'status' => 0,
        ]);
        $allId = AppCommon::data_list_nopage('order_goods', ['order_sn' => $orderGoods['order_sn']], 'id');
        $ids = array_column($allId, 'id');
        $total = AppCommon::data_count('goods_comment', ['order_goods_id' => ['in', $ids]]);
        if ($total >= count($ids)) {
            //都评价了就改成完成
            ServerOrder::update($orderGoods['order_sn'], ['up_time' => time(), 'status' => 4]);
        }


        data_return('提交成功，谢谢您的评价');
    }

    //评价-查询某一个
    public function comment()
    {
        if (IS_AJAX) {
            if (!empty($this->param['from']) && $this->param['from'] == 'get') {
                if (empty($this->param['ord_id'])) {
                    data_return('参数有误', -1);
                }
                $data = AppCommon::data_get('goods_comment', ['order_goods_id' => intval($this->param['ord_id'])], '*');
                if (!empty($data)) {
                    if (!empty($data['imgs'])) {
                        $data['imgs'] = array_filter(explode(',', $data['imgs']));
                    }
                }

                data_return('ok', 0, ['comment' => $data]);
            }
        }
        return $this->fetch();
    }

    //虚拟发货信息
    public function virtual()
    {
        return $this->fetch();
    }

    //虚拟商品发货信息
    public function get_virtual_info()
    {
        if (empty($this->param['order_sn'])) {
            data_return('订单号未找到', -1);
        }
        $order = ServerOrder::get($this->param['order_sn'], 'order_sn,send_time,content_virtual,uid,add_time');

        if (empty($order)) {
            data_return('订单不存在', -1);
        } elseif ($order['uid'] <> $this->uid) {
            data_return('仅限操作自己的订单', -1);
        }
        if (!empty($order['content_virtual'])) {
            $order['content_virtual'] = htmlspecialchars_decode($order['content_virtual']);
            $order['send_time'] = date('Y-m-d H:i:s', $order['send_time']);
        }

        data_return('ok', 0, ['order' => $order]);
    }

    //物流查询
    public function express()
    {
        if (IS_AJAX) {
            if (empty($this->param['order_sn'])) {
                data_return('订单号未找到', -1);
            }
            $order = ServerOrder::get($this->param['order_sn'], 'order_sn,send_time,express_com,express_no');
            if (empty($order)) {
                data_return('订单不存在', -1);
            } elseif (empty($order['express_no'])) {
                data_return('订单未发货或者缺失物流单号', -1);
            }
            $conf = ConfigService::get('express');
            if (empty($conf['pt'])) {
                $pt = 'aliyun';
            } else {
                $pt = $conf['pt'];
            }

            if (empty($conf[$pt])) {
                data_return('物流配置接口未配置，暂不可用', -1);
            }
            $keyCache = 'express_info' . md5(json_encode($conf[$pt]) . $pt . $order['express_no']);
            $data = cache($keyCache);
            if (!empty($data)) {
                data_return('查询成功', 0, $data);
            }
            Express::set_config($conf[$pt]);
            Express::set_pt('aliyun');
            $res = Express::run($order['express_no']);
            if ($res['code'] <> 0) {
                data_return($res['msg'], -1);
            }
            //添加缓存
            cache($keyCache, [
                'express' => !empty($res['data']['list']) ? $res['data']['list'] : null,
                'expressName' => !empty($res['data']['typename']) ? $res['data']['typename'] : null
            ], 3600);

            data_return('查询成功', 0, [
                'express' => !empty($res['data']['list']) ? $res['data']['list'] : null,
                'expressName' => !empty($res['data']['typename']) ? $res['data']['typename'] : null
            ]);

        }

        return $this->fetch();
    }
}