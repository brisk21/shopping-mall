<?php


namespace app\mall\controller;


use app\common\controller\AppCommon;
use app\mall\controller\com\Mall;

class User extends Mall
{
    //个人中心
    public function index()
    {
        return $this->fetch();
    }

    public function address_info()
    {
        return $this->fetch();
    }

    public function address_list()
    {
        return $this->fetch();
    }

    //我的地址
    public function my_address()
    {
        AppCommon::$db_order = ' is_default desc,id asc ';
        $data = AppCommon::data_list('common_user_address', ['uid' => $this->uid], 1);

        data_return('ok', 0, [
            'address' => $data
        ]);
    }

    //地址详情
    public function my_address_info()
    {
        if (empty($this->param['id'])) {
            data_return('参数有误', -1);
        }
        $data = AppCommon::data_get('common_user_address', ['id' => intval($this->param['id']), 'uid' => $this->uid]);

        if (empty($data)) {
            data_return('地址不存在', -1);
        }

        data_return('ok', 0, [
            'address' => $data
        ]);

    }

    //操作地址
    public function my_address_action($id = 0)
    {
        if (!empty($this->param['id'])) {
            $data = AppCommon::data_get('common_user_address', ['id' => intval($this->param['id']), 'uid' => $this->uid]);
            if (!empty($this->param['from']) && $this->param['from'] == 'del') {
                AppCommon::data_del('common_user_address', ['id' => $data['id']]);
                data_return('删除成功', 0);
            }
        }
        $rule = [
            ['type' => 'empty', 'key' => 'addr', 'rule' => '', 'msg' => '请选择地址',],
            ['type' => 'empty', 'key' => 'detail', 'rule' => '', 'msg' => '请填写详细地址',],
            ['type' => 'empty', 'key' => 'mobile', 'rule' => '', 'msg' => '请填写收件人手机号',],
            ['type' => 'empty', 'key' => 'username', 'rule' => '', 'msg' => '请填写收件人',],
        ];
        $check = check_param($this->param, $rule);
        if ($check['code'] <> 0) {
            data_return($check['msg'], $check['code']);
        }


        $addr = explode(' ', $this->param['addr']);
        if (empty($addr[2])) {
            data_return('地址选择不正确', -1);
        }
        $newData = [
            'province' => strip_tags($addr[0]),
            'city' => strip_tags($addr[1]),
            'area' => strip_tags($addr[2]),
            'town' => '',
            'is_default' => !empty($this->param['is_default']) ? 1 : 0,
            'address' => strip_tags($this->param['detail']),
            'username' => strip_tags($this->param['username']),
            'mobile' => strip_tags($this->param['mobile'])
        ];
        //先清理其他默认情况
        if (!empty($this->param['is_default'])) {
            AppCommon::data_update('common_user_address', ['uid' => $this->uid], ['is_default' => 0]);
        }
        if (empty($data)) {
            $newData['uid'] = $this->uid;
            AppCommon::data_add('common_user_address', $newData);
        } else {
            AppCommon::data_update('common_user_address', ['id' => $data['id']], $newData);
        }

        data_return('操作成功');
    }

    //订单统计
    public function order_count()
    {
        $prefix = config('database')['prefix'];
        $table = $prefix . 'order';
        $data = AppCommon::db('order')->query("select 
        sum(if(status=0,1,0)) as count0,
        sum(if(status=1,1,0)) as count1,
        sum(if(status=2,1,0)) as count2,
        sum(if(status=3,1,0)) as count3 from $table  where uid='" . $this->uid . "' ");

        $data = !empty($data[0]) ? $data[0] : [];
        !empty($data['count0']) || $data['count0'] = 0;
        !empty($data['count1']) || $data['count1'] = 0;
        !empty($data['count2']) || $data['count2'] = 0;
        !empty($data['count3']) || $data['count3'] = 0;

        data_return('ok', 0, [
            'count' => $data
        ]);

    }
}