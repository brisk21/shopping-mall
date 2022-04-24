<?php


namespace app\admin\controller\order;


use app\admin\controller\com\Admin;
use app\common\controller\AppCommon;
use app\service\Msg;
use app\service\Order;
use app\service\Order as ServerOrder;
use app\service\Page;

class Index extends Admin
{
    public function index()
    {
        $where = [];
        $page = !empty($this->param['page']) ? intval($this->param['page']) : 1;
        $pageSize = 10;

        $status = isset($this->param['status']) && is_numeric($this->param['status']) ? intval($this->param['status']) : '';
        $orderType = isset($this->param['orderType']) && is_numeric($this->param['orderType']) ? intval($this->param['orderType']) : '';

        $pay_type = !empty($this->param['pay_type']) ? trim($this->param['pay_type']) : '';
        $keyword = !empty($this->param['keyword']) ? trim($this->param['keyword']) : '';
        $store_num = !empty($this->param['store_num']) ? trim($this->param['store_num']) : '';

        $orderBy = 'id desc';

        //-1-已取消，0-待支付，1-已支付，2-待收货，3-已完，-2-已退款
        if ($status !== '') {
            $where['status'] = $status >= 3 ? ['in', [3, 4]] : $status;
        }

        if (is_numeric($orderType)) {
            $where['order_type'] = $orderType;
        }
        if (!empty($keyword)) {
            $where['order_sn'] = $keyword;
        }
        if (!empty($store_num)) {
            $where['store_num'] = $store_num;
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
            '4' => '<span class="bs-green">已完成(已评价)</span>',
        ];
        $type = [
            '0' => '<span class="bs-green">销售</span>',
            '1' => '<span class="bs-blue">展示</span>',
            '2' => '<span class="bs-blue-2">自提</span>',
            '3' => '<span class="bs-orangered">虚拟商品</span>',
        ];
        $data = AppCommon::data_list('order', $where, $page . ',' . $pageSize, 'id,order_sn,uid,status,price,	pay_price,add_time,up_time,send_time,pay_time,pay_type,trans_id,address,cancel_pay_time,store_num,is_del,pay_openid,order_type', $orderBy);

        if (!empty($data)) {
            $num = array_unique(array_column($data,'store_num'));
            $stores = AppCommon::data_list_nopage('stores',['store_num'=>['in',$num]],'store_num,store_name,store_logo');
            if (!empty($stores)){
                $stores = array_column($stores,null,'store_num');
            }
            foreach ($data as &$v) {
                $v['typeDesc'] = isset($type[$v['order_type']]) ? $type[$v['order_type']] : $type[0];
                $v['statusDesc'] = $status[$v['status']];
                $v['payType'] = $v['pay_type'] == 'wechat' ? '<span class="bs-green">微信</span>' : ($v['pay_type'] == 'credit' ? '<span class="">余额</span>' : ($v['pay_type'] == 'alipay' ? '<span class="bs-blue">支付宝</span>' : '<span class="bs-blue">待定</span>'));
                //获取一条记录
                $v['goods'] = AppCommon::data_get('order_goods', ['order_sn' => $v['order_sn']], 'thumb,title');
                if (!empty($v['goods'])) {
                    $v['goods']['title'] = mb_substr($v['goods']['title'], 0, 15) . '......';
                } else {
                    $v['goods']['title'] = '未知....';
                    $v['goods']['thumb'] = '';
                }

                if (isset($stores[$v['store_num']])){
                    $v['store'] = $stores[$v['store_num']];
                }

                $v['user'] = AppCommon::data_get('common_user', ['uid' => $v['uid']], 'account,nickname');
                if (empty($v['user'])) {
                    $v['user']['uid'] = '用户不存在';
                    $v['user']['account'] = '用户不存在';
                }

                $v['refund'] = AppCommon::data_get('order_refund_apply_log', ['order_sn' => $v['order_sn'], 'status' => 0], 'id,apply_money');

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
            '4' => '<span class="bs-green">已评价</span>',
        ];


        if (!empty($data['address'])) {
            $addr = json_decode($data['address'], true);
            $data['address'] = $addr;
            $data['full_address'] = $addr['province'] . '/' . $addr['city'] . '/' . $addr['area'] . '/' . $addr['town'] . '/' . $addr['address'];
        }
        $data['statusDesc'] = $status[$data['status']];
        if ($data['order_type'] == 2) {
            if ($data['status'] == 1) {
                $data['statusDesc'] = '<span class="bs-red">待提货</span>';
            }
        }


        $goods = AppCommon::data_list('order_goods', ['order_sn' => $this->param['order_sn']], '1,50');

        $data['refund'] = AppCommon::data_get('order_refund_apply_log', ['order_sn' => $data['order_sn'], 'status' => 0]);

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
            'send_time' => empty($data['send_time']) ? time() : $data['send_time'],
            'status' => $data['status'] == 1 ? 2 : $data['status'],
        ];
        $res = Order::update($data['order_sn'], $upData);
        if ($res) {
            Msg::add($data['uid'], [
                'title' => '订单物流状态改变',
                'content' => '您的订单已发货，您可以查看物流状态，有疑问请联系客服。',
                'type' => 1
            ]);
            parent::add_admin_log(['title' => '操作物流发货信息：', 'content' => $upData]);
        }

        data_return('物流已保存');
    }

    //虚拟商品发货
    public function send_virtual()
    {
        if (empty($this->param['content_virtual'])) {
            data_return('发货内容未设置', -1);
        } elseif (mb_strlen($this->param['content_virtual']) > 1000) {
            data_return('输入内容超过最大限度1000，请缩减', -1);
        } elseif (empty($this->param['order_sn'])) {
            data_return('订单参数有误', -1);
        }
        $data = Order::get($this->param['order_sn'], '*');
        if (empty($data)) {
            data_return('订单未找到', -1);
        } elseif ($data['order_type'] <> 3) {
            data_return('仅支持虚拟商品订单操作', -1);
        } elseif ($data['status'] < 1) {
            data_return('仅支持待发货和待收货状态操作', -1);
        }
        $upData = [
            'content_virtual' => $this->param['content_virtual'],
            'status' => $data['status'] == 1 ? 2 : $data['status'],
            'send_time' => time()
        ];
        $res = Order::update($data['order_sn'], $upData);
        if ($res) {
            Msg::add($data['uid'], [
                'title' => '您购买的商品发货啦',
                'content' => '您购买的商品发货了，查看发货信息：订单->发货信息',
                'type' => 1
            ]);
            parent::add_admin_log(['title' => '操作虚拟商品发货：', 'content' => $this->param]);
        }

        data_return('发货信息已保存');
    }

    //提货操作
    public function action_tihuo()
    {
        if (empty($this->param['code'])) {
            data_return('请填写提货码', -1);
        } elseif (empty($this->param['order_sn'])) {
            data_return('订单参数有误', -1);
        }
        $data = Order::get($this->param['order_sn'], '*');
        if (empty($data)) {
            data_return('订单未找到', -1);
        } elseif ($this->param['code'] <> $data['code_tihuo']) {
            data_return('提货码不匹配', -1);
        } elseif (!in_array($data['status'], [1, 2])) {
            data_return('仅支持待提货状态操作', -1);
        }
        $upData = [
            'send_time' => time(),
            'receive_time' => time(),
            'status' => 3,//完成
        ];
        $res = Order::update($data['order_sn'], $upData);
        if ($res) {
            Msg::add($data['uid'], [
                'title' => '提货成功',
                'content' => '您购买的商品已被提货，若不是您自己操作，请联系商家',
                'type' => 1
            ]);
            parent::add_admin_log(['title' => '操作订单提货：', 'content' => $this->param]);
        }

        data_return('操作成功');
    }

    //售后处理
    public function refund()
    {
        if (empty($this->param['order_sn'])) {
            data_return('订单参数有误', -1);
        }
        $order = ServerOrder::get($this->param['order_sn']);
        if (empty($order)) {
            data_return('订单未找到', -1);
        }

        $dotype = intval($this->param['dotype']);
        $refund_type = intval($this->param['refund_type']);
        if ($dotype == -1 && empty($this->param['refuse_reason'])) {
            data_return('驳回必须填写驳回原因', -1);
        }
        $refuse_reason = $this->param['refuse_reason'];
        $log = AppCommon::data_get('order_refund_apply_log', ['order_sn' => $this->param['order_sn'], 'status' => 0]);
        if (empty($log)) {
            data_return('售后维权未找到或已被取消', -1);
        }
        $status = $dotype == -1 ? -1 : 1;
        if ($status == 1) {
            if ($refund_type == 1) {
                $res = Order::refund($this->param['order_sn'], $log['apply_money']);
                if ($res['code'] <> 0) {
                    data_return($res['msg'], -1);
                }
            }
        }
        //更新申请记录
        AppCommon::data_update('order_refund_apply_log', ['id' => $log['id']], [
            'up_time' => time(),
            'refuse_reason' => $status == -1 ? $refuse_reason : '',
            'refund_type' => $refund_type,
            'status' => $status
        ]);
        Msg::add($order['uid'], [
            'title' => '退款成功',
            'content' => '您的订单已退款，请自行查看订单状态，退款到账可能存在延迟。',
            'type' => 1
        ]);
        parent::add_admin_log(['title' => '售后处理', 'content' => $this->param]);
        data_return('售后已处理');
    }
}