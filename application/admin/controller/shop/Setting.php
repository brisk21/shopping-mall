<?php


namespace app\admin\controller\shop;


use app\admin\controller\com\Admin;
use app\service\ConfigService;

class Setting extends Admin
{
    public function index()
    {
        $conf = ConfigService::get('mobile_shop');
        if (!empty($conf)) {
            $this->assign('data', $conf);
        }
        return $this->fetch();
    }

    public function config_action()
    {
        $rule = [
            ['type' => 'length', 'key' => 'shop_name', 'rule' => '2,80', 'msg' => '名称未设置',],
            ['type' => 'empty', 'key' => 'reg_type', 'rule' => '', 'msg' => '注册类型未选择',],
        ];
        $check = check_param($this->param, $rule);
        if ($check['code'] <> 0) {
            data_return($check['msg'], $check['code']);
        }
        $data = [
            'reg_type' => intval($this->param['reg_type']),
            'shop_name' => trim($this->param['shop_name']),
            'gift_order_point' => intval($this->param['gift_order_point']),
        ];
        $key = 'mobile_shop';
        ConfigService::action($key, $data);

        parent::add_admin_log(['title' => '操作网站配置', 'content' => $data]);
        data_return('保存成功');
    }
}