<?php


namespace app\api\controller\mall;


use app\common\controller\AppCommon;
use app\service\ConfigService;
use app\service\Msg;
use app\service\Order as ServerOrder;

class Order
{
    private $config_shop = null;

    protected function __construct()
    {
        $this->config_shop = ConfigService::get('mobile_shop');
    }

    //超时支付自动关闭
    public function auto_cancel()
    {
        $key = __FUNCTION__ . md5(__FUNCTION__ . __FILE__);
        if (cache($key)) {
            data_return('有任务在进行', -1);
        }
        cache($key, 1, 600);

        $data = AppCommon::data_list('order', ['status' => 0, 'cancel_pay_time' => ['<', time()]], '1,20', 'order_sn');
        if (empty($data)) {
            data_return('暂无订单需要关闭', -1);
        }
        $count = 0;
        foreach ($data as $item) {
            \app\service\Order::cancel($item['order_sn']);
            $count++;
        }
        cache($key, null);
        data_return('执行完成', 0, ['count' => $count]);
    }

    //自动确认收货
    public function auto_receive()
    {
        $key = __FUNCTION__ . md5(__FUNCTION__ . __FILE__);
        if (cache($key)) {
            data_return('有任务在进行', -1);
        }
        $day = !empty($this->config_shop['auto_receive_order_time']) ? $this->config_shop['auto_receive_order_time'] : 15;
        cache($key, 1, 600);

        $time = strtotime("-$day days", time());

        $data = AppCommon::data_list('order', ['status' => 0, 'cancel_pay_time' => ['<', $time]], '1,20', 'order_sn,uid,order_type');
        if (empty($data)) {
            data_return('暂无订单需要自动确认收货', -1);
        }
        $count = 0;
        foreach ($data as $item) {
            $newData = [
                'status' => 3,
                'up_time' => time(),
                'receive_time' => time(),
            ];
            //提货
            if ($item['order_type'] == 2) {
                $newData['send_time'] = time();
            }
            $res = ServerOrder::update($item['order_sn'], $newData);
            if ($res) {
                Msg::add($item['uid'], [
                    'title' => '确认收货成功' . $item['order_sn'],
                    'content' => '您购买的商品已被确认收货，订单发货后' . $day . '天自动确认收货，若您未收到请联系商家。',
                    'type' => 1
                ]);
            }
            $count++;
        }
        cache($key, null);
        data_return('执行完成', 0, ['count' => $count]);
    }
}