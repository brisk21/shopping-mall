<?php


namespace app\mall\controller;


use app\common\controller\AppCommon;
use app\mall\controller\com\Mall;
use app\service\Credits;
use think\Db;
use app\service\Order as ServerOrder;

class Order extends Mall
{
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
        if (IS_AJAX) {
            if (empty($this->param['order_sn'])) {
                data_return('订单号缺失', -1);
            }

            $order = ServerOrder::get(trim($this->param['order_sn']));
            if (empty($order) || $order['is_del']) {
                data_return('订单找不到了', -1);
            }


            $address = json_decode($order['address'], true);

            AppCommon::$db_pageSize = 50;
            $goods = AppCommon::data_list('order_goods', ['order_sn' => $order['order_sn']]);
            data_return('ok', 0, [
                'order' => $order,
                'address' => $address,
                'goods_list' => $goods
            ]);
        }

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
        AppCommon::$db_order = 'id desc';
        $orders = AppCommon::data_list('order', $where, $page, 'order_sn,price,status,pay_time,pay_price,add_time');

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
            if (empty($item['bid']) || ($item['stock'] - $item['stock_locked'] <= 0) || $item['status'] <> 1) {
                data_return('存在已下架或已售罄商品', -1);
            }
            if (($item['stock'] - $item['stock_locked']) < $item['count']) {
                data_return($item['title'] . '库存不足', -1);
            }
        }

        return $goods;
    }

    //创建订单
    public function create()
    {
        if (!empty($this->param['id'])) {
            //立即购买
            $goods = AppCommon::data_get('goods', ['id' => intval($this->param['id'])], 'id,thumb,title,price,status,stock,stock_locked,store_num');
            if (empty($goods) || $goods['status'] <> 1 || ($goods['stock'] - $goods['stock_locked']) <= 0) {
                data_return('商品已售罄', -1);
            }
            $whereAddr = ['uid' => $this->uid,];
            if (empty($this->param['addr_id'])) {
                data_return('请选则地址', -1);
            }
            $whereAddr['id'] = intval($this->param['addr_id']);
            $address = AppCommon::data_get('common_user_address', $whereAddr);
            if (empty($address)) {
                data_return('地址不存在', -1);
            }
            $goods['count'] = !empty($this->param['count']) ? intval($this->param['count']) : 1;
            if (($goods['stock'] - $goods['stock_locked']) < $goods['count']) {
                data_return('库存不足', -1);
            }

            $totalPrice = floatval($goods['count'] * $goods['price']);

            $arg = [
                'address' => $address,
                'price' => $totalPrice,
                'uid' => $this->uid,
                'store_num' => $goods['store_num'],
            ];

            $res = ServerOrder::add($arg);

            if ($res['code'] <> 0) {
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
                data_return('服务正忙，请稍后', -1);
            }

            //锁库
            AppCommon::data_update('goods', ['id' => $goods['id']], ['stock_locked' => $goods['count'] + $goods['stock_locked'], 'stock' => $goods['stock'] - $goods['count']]);

            data_return('ok', 0, $res['data']);
        } else {
            $goods = $this->check_status();
            $whereAddr = ['uid' => $this->uid,];
            if (empty($this->param['addr_id'])) {
                data_return('请选择地址', -1);
            }
            $whereAddr['id'] = intval($this->param['addr_id']);
            $address = AppCommon::data_get('common_user_address', $whereAddr);
            if (empty($address)) {
                data_return('地址不存在', -1);
            }
            $totalMoney = 0;
            foreach ($goods as $val) {
                $val['totalPrice'] = round($val['price'] * $val['count'], 2);
                $totalMoney += $val['totalPrice'];
            }
            //目前这个版本是一个店铺,todo 扩展多店铺版本
            $ret = [];
            Db::transaction(function () use ($address, $totalMoney, $goods, &$ret) {
                $arg = [
                    'address' => $address,
                    'price' => $totalMoney,
                    'uid' => $this->uid,
                    'store_num' => $goods[0]['store_num'],
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
            $res1 = Credits::update($this->uid, 'credit', -$order['price']);
            if (!$res1) {
                $ret = false;
                return;
            }

            //资金扣除流水记录
            $log = [
                'uid' => $this->uid,
                'remark' => '购买商品支付',
                'type' => 1,//1-购买商品，2-充值记录，3-提现记录,
                'before_num' => $creditInfo['credit'],
                'num' => -$order['price'],
                'after_num' => $creditInfo['credit'] - $order['price']
            ];
            $res2 = Credits::log_add($log);

            if (!$res2) {
                $ret = false;
                return;
            }

            //更新订单
            $data = [
                'pay_price' => $order['price'],
                'pay_time' => time(),
                'up_time' => time(),
                'status' => 1,
            ];
            $up = ServerOrder::update($order['order_sn'], $data);

            if (!$up) {
                $ret = false;
                return;
            }

            //更新库存
            AppCommon::$db_pageSize = 50;
            $orderGoods = AppCommon::data_list('order_goods', ['order_sn' => $order['order_sn']], 1, 'goods_id,count');
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
}