<?php


namespace app\mall\controller;


use app\common\controller\AppCommon;
use app\mall\controller\com\Mall;
use think\captcha\Captcha;
use think\Request;

class Account extends Mall
{
    public function __construct(Request $request = null)
    {
        parent::__construct($request);
    }

    public function login()
    {
        if (session($this->key_cache_user)){
            return redirect('/mall/account/index');
        }
        return $this->fetch();
    }

    public function index()
    {
        exit('ok');
    }


    public function get_vcode()
    {
        return captcha_img();
    }

    public function reg()
    {
        return $this->fetch();
    }

    //注册操作
    public function reg_action()
    {
        $rule = [
            ['type' => 'length', 'key' => 'account', 'rule' => '2,16', 'msg' => '账号2~16字符',],
            ['type' => 'empty', 'key' => 'pwd1', 'rule' => '', 'msg' => '密码不能为空',],
            ['type' => 'empty', 'key' => 'pwd2', 'rule' => '', 'msg' => '确认密码不能为空',],
            ['type' => 'empty', 'key' => 'vcode', 'rule' => '', 'msg' => '请输入图形验证码',],
        ];
        $check = check_param($this->param, $rule);
        if ($check['code'] <> 0) {
            data_return($check['msg'], $check['code']);
        }
        if (strlen($this->param['account']) < 3) {
            data_return('账号不合法', -1);
        }
        if (strlen($this->param['pwd1']) < 6) {
            data_return('密码不够安全', -1);
        }
        if (!captcha_check($this->param['vcode'], 'abc')) {
            data_return('验证码不正确', -1);
        }
        if ($this->param['pwd1'] !== $this->param['pwd2']) {
            data_return('两次密码不一样', -1);
        }

        $has = AppCommon::data_get('common_user', ['account' => trim($this->param['account'])], 'id');
        if (!empty($has['id'])) {
            data_return('账号已被注册', -1);
        }

        $salt = get_random(10, false);
        $uid = 'bs' . md5($this->param['account'] . rand(1, 99999) . time() . $salt);
        while (true) {
            $tmp = AppCommon::data_get('common_user', ['uid' => $uid], 'id');
            if (empty($tmp['id'])) {
                break;
            }
            $uid = 'bs' . md5($this->param['account'] . rand(1, 99999) . time() . get_random(10, false));
        }
        $data = [
            'account' => trim($this->param['account']),
            'uid' => $uid,
            'pwd' => md5($this->param['pwd1'] . $salt),
            'salt' => $salt, 'add_time' => time(),
            'up_time' => time(),
            'status' => 0
        ];

        AppCommon::data_add('common_user', $data);
        //登录状态
        session($this->key_cache_user, $data['uid'], 'bs_');

        data_return('注册成功');
    }

    public function do_login()
    {
        if (empty($this->param['account'])) {
            data_return('账号未设置', -1);
        } elseif (empty($this->param['pwd'])) {
            data_return('密码未输入', -1);
        }
        $data = AppCommon::data_get('common_user', ['account' => trim($this->param['account'])], 'id,uid,pwd,salt,pwd_err_count,up_time,loginCount');

        if (empty($data)) {
            data_return('账号不存在', -1);
        }
        if ($data['pwd_err_count'] >= 5 && ($data['up_time'] > time() - 1800)) {
            data_return('密码错误次数过多，请稍后重试', -1);
        }
        if (md5($this->param['pwd'] . $data['salt']) <> $data['pwd']) {
            AppCommon::data_update('common_user', ['id' => $data['id']], ['pwd_err_count' => $data['pwd_err_count'] + 1, 'up_time' => time()]);
            data_return('账号密码不匹配', -1);
        }
        //重生盐值加密
        $salt = get_random(10, false);
        $pwd = md5($this->param['pwd'] . $salt);
        AppCommon::data_update('common_user', ['id' => $data['id']], ['pwd_err_count' => 0, 'salt' => $salt, 'pwd' => $pwd, 'loginCount' => $data['loginCount'] + 1]);

        $loginData = [
            'uid' => $data['uid'],
            'add_time' => time(),
            'ip' => ip2long(get_ip()),
        ];
        AppCommon::data_add('common_user_login_log', $loginData);

        //设置登录状态
        session($this->key_cache_user,$data['uid']);

        data_return('登录成功');
    }

    public function xieyi()
    {
        return $this->fetch();
    }

    public function pwd_change()
    {
        return $this->fetch();
    }
}