<?php


namespace app\mall\controller;


use app\common\controller\AppCommon;
use app\mall\controller\com\Mall;
use think\Db;

class Order extends Mall
{
    public function info()
    {
        return $this->fetch();
    }

    //批量下单
    public function info2()
    {
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
        $where = ['uid'=>$this->uid];
        $page = !empty($this->param['page'])?intval($this->param['page']):1;
        $status = isset($this->param['status']) && is_numeric($this->param['status'])?intval($this->param['status']):'';
        if (is_numeric($status)){
            //-1-已取消，0-待支付，1-已支付，2-待收货，3-已完，-2-已退款
            $where['status'] = $status;
        }
        AppCommon::$db_order = 'id desc';
        $orders = AppCommon::data_list('order',$where,$page,'order_sn,price,status,pay_time,pay_price,add_time');

        if (!empty($orders)){
            foreach ($orders as &$order){
                $order['goods_list'] = AppCommon::data_list('order_goods',['order_sn'=>$order['order_sn']],1,'*');
            }
            unset($order);
        }

        data_return('ok',0,[
            'orders'=>$orders
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
                'totalMoney' => round($goods['count'] * $goods['price'], 2)
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
                $val['totalPrice'] = round($val['price'] * $val['count'], 2);
                $totalMoney += $val['totalPrice'];
            }
            unset($val);
            $order = [
                'totalMoney' => round($totalMoney, 2)
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

            $res = \app\service\Order::add($arg);

            if ($res['code'] <> 0) {
                data_return('服务正忙，请稍后', -1);
            }

            //添加商品
            $resGoods = \app\service\Order::add_order_goods([
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
            $arg = [
                'address' => $address,
                'price' => $totalMoney,
                'uid' => $this->uid,
                'store_num' => $goods[0]['store_num'],
            ];

            $res = \app\service\Order::add($arg);
            if ($res['code'] <> 0) {
                data_return('服务正忙，请稍后', -1);
            }
            $order_sn = $res['data']['order_sn'];
            foreach ($goods as $value) {
                \app\service\Order::add_order_goods([
                    'order_sn' => $order_sn,
                    'goods_id' => $value['id'],
                    'count' => $value['count'],
                    'thumb' => $value['thumb'],
                    'price' => $value['price'],
                    'title' => $value['title'],
                ]);
                //锁库
                AppCommon::data_update('goods', ['id' => $value['goods_id']], ['stock_locked' => $value['count'] + $value['stock_locked'], 'stock' => $value['stock'] - $value['count']]);
            }
            //清理对应的购物车
            AppCommon::data_del('cart', ['uid' => $this->uid, 'status' => 1]);
            data_return('ok', 0, $res['data']);
        }
    }
}