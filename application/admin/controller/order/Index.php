<?php


namespace app\admin\controller\order;


use app\admin\controller\com\Admin;
use app\common\controller\AppCommon;
use app\service\Order;
use app\service\Page;

class Index extends Admin
{
    public function index()
    {
        $where = [];
        $page = !empty($this->param['page']) ? intval($this->param['page']) : 1;
        $pageSize = 10;

        $status = isset($this->param['status']) && is_numeric($this->param['status']) ? intval($this->param['status']) : '';

        $pay_type = !empty($this->param['pay_type']) ? trim($this->param['pay_type']) : '';
        $keyword = !empty($this->param['keyword']) ? trim($this->param['keyword']) : '';
        $orderBy = 'id desc';

        //-1-已取消，0-待支付，1-已支付，2-待收货，3-已完，-2-已退款
        if ($status !== '') {
            $where['status'] = $status;
        }

        if (!empty($keyword)) {
            $where['order_sn'] = $keyword;
        }
        if (!empty($pay_type)) {
            $where['pay_type'] = $pay_type;
        }

        $status = [
            '-1' => '<span class="bs-grey">已取消</span>',
            '-2' => '<span class="bs-red">已退款</span>',
            '0' => '<span class="">待付款</span>',
            '1' => '<span class="bs-green">待发货</span>',
            '2' => '<span class="bs-blue">待收货</span>',
            '3' => '<span class="bs-green">已完成</span>',
        ];
        $data = AppCommon::data_list('order', $where, $page . ',' . $pageSize, 'id,order_sn,uid,status,price,	pay_price,add_time,up_time,send_time,pay_time,pay_type,trans_id,address,cancel_pay_time,store_num,is_del,pay_openid', $orderBy);

        if (!empty($data)) {
            foreach ($data as &$v) {
                $v['statusDesc'] = $status[$v['status']];
                $v['payType'] = $v['pay_type'] == 'wechat' ? '<span class="bs-green">微信</span>' : ($v['pay_type'] == 'credit' ? '<span class="">余额</span>' : ($v['pay_type']=='alipay'?'<span class="bs-blue">支付宝</span>':'<span class="bs-blue">待定</span>'));
                //获取一条记录
                $v['goods'] = AppCommon::data_get('order_goods', ['order_sn' => $v['order_sn']], 'thumb,title');
                $v['goods']['title'] = mb_substr($v['goods']['title'], 0, 15) . '......';

                $v['user'] = AppCommon::data_get('common_user', ['uid' => $v['uid']], 'account');
                if (empty($v['user'])) {
                    $v['user']['uid'] = '用户不存在';
                }

            }
            unset($v);
        }

        $total = AppCommon::data_count('order', $where);

        $this->assign('page', Page::set($data, $pageSize, $page, $total, $this->param, url()));
        $this->assign('data', $data);
        return $this->fetch();
    }

    public function detail()
    {
        if (empty($this->param['order_sn'])) {
            return $this->error('参数有误');
        }
        $data = Order::get($this->param['order_sn'], '*');

        $status = [
            '-1' => '<span class="bs-grey">已取消</span>',
            '-2' => '<span class="bs-red">已退款</span>',
            '0' => '<span class="">待付款</span>',
            '1' => '<span class="bs-green">待发货</span>',
            '2' => '<span class="bs-blue">待收货</span>',
            '3' => '<span class="bs-green">已完成</span>',
        ];

        if (!empty($data['address'])) {
            $addr = json_decode($data['address'], true);
            $data['address'] = $addr;
            $data['full_address'] = $addr['province'] . '/' . $addr['city'] . '/' . $addr['area'] . '/' . $addr['town'] . '/' . $addr['address'];
        }

        $data['statusDesc'] = $status[$data['status']];

        $goods = AppCommon::data_list('order_goods', ['order_sn' => $this->param['order_sn']], '1,50');

        //物流公司模拟
        $expressCom = [
            ['com' => 'yunda', 'name' => '韵达'],
            ['com' => 'yuantong', 'name' => '圆通'],
            ['com' => 'shunfeng', 'name' => '顺丰'],
            ['com' => 'jitu', 'name' => '极兔'],
            ['com' => 'other', 'name' => '其它'],
        ];

        $this->assign('data', [
            'order' => $data,
            'goods_list' => $goods,
            'expressCom' => $expressCom
        ]);

        return $this->fetch();
    }

    //物流发货
    public function send()
    {
        if (empty($this->param['express_com'])) {
            data_return('请选择物流公司', -1);
        } elseif (empty($this->param['express_no'])) {
            data_return('请输入物流单号', -1);
        } elseif (empty($this->param['order_sn'])) {
            data_return('订单参数有误', -1);
        }
        $data = Order::get($this->param['order_sn'], '*');
        if (empty($data)) {
            data_return('订单未找到', -1);
        }
        if (!in_array($data['status'], [1, 2])) {
            data_return('仅支持待发货和待收货状态操作', -1);
        }
        $upData = [
            'express_com' => trim($this->param['express_com']),
            'express_no' => trim($this->param['express_no']),
            'status' => $data['status'] == 1 ? 2 : $data['status'],
        ];
        $res = Order::update($data['order_sn'], $upData);
        if ($res) {
            parent::add_admin_log(['title' => '操作物流发货信息：', 'content' => $upData]);
        }

        data_return('物流已保存');
    }
}