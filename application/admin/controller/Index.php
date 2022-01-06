<?php


namespace app\admin\controller;


use app\admin\controller\com\Admin;
use app\common\controller\AppCommon;
use think\Request;

class Index extends Admin
{
    public function __construct(Request $request = null)
    {
        parent::__construct($request);
    }

    public function default_index()
    {
        $this->assign('data', $this->index(true));
        return $this->fetch();
    }

    public function index($return = false)
    {
        $k = 'admin_default_frame_style' . $this->admin_uid;
        $type = cache($k);
        if (IS_AJAX) {
            if ($type == 'iframe') {
                $type = 'single_page';
                $url = url('/admin/index/index');
            } else {
                $type = 'iframe';
                $url = url('/admin/index/index_iframe');
            }
            cache($k, $type);

            data_return('ok', 0, ['type' => $type, 'url' => $url]);
        }

        $data = [];
        $data['order'] = AppCommon::data_count('order');
        $data['order_pay'] = AppCommon::data_count('order', ['status' => ['>', 0]]);
        $data['order_need_send'] = AppCommon::data_count('order', ['status' => ['=', 1]]);
        $data['user'] = AppCommon::data_count('common_user');
        $data['credit'] = AppCommon::data_sum('common_user_credits', null, 'credit');
        $data['order_pay_rate'] = 0;
        if (!empty($data['order_pay'])) {
            $data['order_pay_rate'] = round($data['order_pay'] / $data['order'] * 100, 2);
        }

        if ($return) {
            return $data;
        }
        if ($type == 'iframe') {
            return $this->redirect(url('/admin/index/index_iframe'));
        }
        $this->assign('data', $data);
        return $this->fetch();
    }

    public function index_iframe()
    {
        $k = 'admin_default_frame_style' . $this->admin_uid;
        $type = cache($k);
        if ($type <> 'iframe') {
            return $this->redirect(url('/admin/index/index'));
        }
        return $this->fetch();
    }


}