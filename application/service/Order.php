<?php


namespace app\service;


use app\common\controller\AppCommon;

class Order
{
    //创建订单
    public static function add($arg)
    {
        $order_sn = 'BS' . date('YmdHis') . get_random(8, 1);
        while (true) {
            $has = AppCommon::data_get('order', ['order_sn' => $order_sn], 'id');
            if (empty($has['id'])) {
                break;
            }
            $order_sn = 'BS' . date('YmdHis') . get_random(8, 1);
        }

        $data = [
            'uid' => $arg['uid'],
            'store_num' => $arg['store_num'],
            'address' => !empty($arg['address']) ? json_encode($arg['address'], JSON_UNESCAPED_UNICODE) : '',
            'order_sn' => $order_sn,
            'status' => 0,
            'price' => $arg['price'],
            'add_time' => time(),
            'up_time' => time(),
            'cancel_pay_time' => time() + 3600,//x秒后不可支付
        ];

        $res = AppCommon::data_add('order', $data);
        if (!$res) {
            return ['code' => -1, 'msg' => '创建失败'];
        }
        return ['code' => 0, 'msg' => 'ok', 'data' => ['order_sn' => $order_sn]];
    }

    //更新订单
    public static function update($order_sn, $data)
    {
        if (!self::get($order_sn, 'id')) {
            return false;
        }
        return AppCommon::data_update('order', ['order_sn' => $order_sn], $data);
    }

    //查询订单
    public static function get($order_sn, $field = '*')
    {
        return AppCommon::data_get('order', ['order_sn' => trim($order_sn)], $field);
    }

    //删除订单:①未支付直接删除，②已付款的直接修改状态
    public static function del($order_sn)
    {
        $order = self::get($order_sn, 'status,order_sn,uid');
        if (empty($order)) {
            return false;
        }
        if ($order['status'] == 0) {
            AppCommon::data_del('order', ['order_sn' => $order_sn]);
            //锁库解锁
            $allGoods = AppCommon::data_list('order_goods', ['order_sn' => $order_sn], '1,50', 'goods_id,count');

            if ($allGoods) {
                foreach ($allGoods as $goods) {
                    AppCommon::db('goods')->where(['id' => $goods['goods_id']])->setInc('stock', $goods['count']);
                    AppCommon::db('goods')->where(['id' => $goods['goods_id']])->setDec('stock_locked', $goods['count']);
                }
            }
            //todo 增加用户消息

        } else {
            AppCommon::data_update('order', ['order_sn' => $order_sn], ['is_del' => 1]);
        }

        return true;
    }

    //订单商品
    public static function add_order_goods($data)
    {
        return AppCommon::data_add('order_goods', $data);
    }
}