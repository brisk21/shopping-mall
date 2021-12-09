<?php


namespace app\mall\controller;


use app\common\controller\AppCommon;
use app\mall\controller\com\Mall;
use app\service\ConfigService;
use app\service\Mailer;
use app\service\VerifyCode;
use think\captcha\Captcha;
use think\Request;

class Account extends Mall
{
    public $whiteList = [
        'mall/account/login',
        'mall/account/index',
        'mall/account/get_vcode',
        'mall/account/get_dcode',
        'mall/account/reg',
        'mall/account/reg_action',
        'mall/account/do_login',
        'mall/account/xieyi',
        'mall/account/pwd_change',
    ];

    public function __construct(Request $request = null)
    {
        parent::__construct($request);
    }

    public function login()
    {
        if ($this->uid) {
            return redirect('/mall/home/index');
        }
        return $this->fetch();
    }

    public function index()
    {
        return redirect('/mall/account/login');
    }


    public function get_vcode()
    {
        return captcha_img();
    }

    //动态码
    public function get_dcode()
    {
        $conf = ConfigService::get('mobile_shop');
        if (empty($conf['reg_type']) || $conf['reg_type'] == -1) {
            data_return('系统已关闭注册', -1);
        }
        if (empty($this->param['vcode'])) {
            data_return('请填写图形验证码', -1);
        }
        if (!captcha_check($this->param['vcode'], 'reg_vcode')) {
            data_return('图形验证码不正确', -1);
        }
        if (empty($this->param['account'])) {
            data_return('请填写账号', -1);
        }
        //1-仅手机，2-仅邮箱，3-手机或者邮箱，4-任意字符串，-1-关闭注册
        $type = $conf['reg_type'];
        if ($type == 4) {
            data_return('词注册类型无需动态码', 500);
        } elseif ($type == 1) {
            if (!is_phone($this->param['account'])) {
                data_return('目前仅支持手机号注册');
            }
            $res = VerifyCode::send($this->param['account']);
            if ($res['code'] <> 0) {
                data_return($res['msg'], -1);
            }
            data_return('发送成功,注意查收');
        } elseif ($type == 2) {
            if (!is_email($this->param['account'])) {
                data_return('目前仅支持邮箱注册');
            }
            $res = VerifyCode::send($this->param['account']);
            if ($res['code'] <> 0) {
                data_return($res['msg'], -1);
            }
            data_return('发送成功,注意查收');
        } elseif ($type == 3) {
            if (!is_email($this->param['account']) && !is_phone($this->param['account'])) {
                data_return('仅支持手机号或者邮箱注册', -1);
            }
            $res = VerifyCode::send($this->param['account']);
            if ($res['code'] <> 0) {
                data_return($res['msg'], -1);
            }
            data_return('发送成功,注意查收');
        }

        data_return('系统错误', 500, $type);
    }

    public function reg()
    {
        return $this->fetch();
    }

    //注册操作
    public function reg_action()
    {
        $conf = ConfigService::get('mobile_shop');
        if (empty($conf['reg_type']) || $conf['reg_type'] == -1) {
            data_return('系统已关闭注册', -1);
        }
        $rule = [
            ['type' => 'length', 'key' => 'account', 'rule' => '2,16', 'msg' => '账号2~16字符',],
            ['type' => 'empty', 'key' => 'pwd1', 'rule' => '', 'msg' => '密码不能为空',],
            ['type' => 'empty', 'key' => 'pwd2', 'rule' => '', 'msg' => '确认密码不能为空',],
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
        //1-仅手机，2-仅邮箱，3-手机或者邮箱，4-任意字符串，-1-关闭注册
        $type = $conf['reg_type'];
        if ($type == 1) {
            if (!is_phone($this->param['account'])) {
                data_return('目前仅支持手机号注册');
            }
        } elseif ($type == 2) {
            if (!is_email($this->param['account'])) {
                data_return('目前仅支持邮箱注册');
            }
            if (empty($this->param['dcode'])) {
                data_return('请输入动态码', -1);
            }
            $res = VerifyCode::check_code($this->param['account'], $this->param['dcode']);
            if ($res['code'] <> 0) {
                data_return($res['msg'], -1);
            }
        } elseif ($type == 3) {
            if (!is_email($this->param['account']) && !is_phone($this->param['account'])) {
                data_return('仅支持手机号或者邮箱注册', -1);
            }
            if (empty($this->param['dcode'])) {
                data_return('请输入动态码', -1);
            }
            $res = VerifyCode::check_code($this->param['account'], $this->param['dcode']);
            if ($res['code'] <> 0) {
                data_return($res['msg'], -1);
            }
        } elseif ($type == 4) {
            if (!captcha_check($this->param['vcode'], 'reg_vcode')) {
                data_return('验证码不正确', -1);
            }
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

        //登录记录
        AppCommon::data_add('common_user_login_log', [
            'uid' => $data['uid'],
            'add_time' => time(),
            'ip' => ip2long(get_ip()),
        ]);

        //登录状态
        session($this->key_cache_user, $data['uid'], $this->session_prefix);

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
        session($this->key_cache_user, $data['uid'], $this->session_prefix);

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

    //退出
    public function logout()
    {
        session($this->key_cache_user, null, $this->session_prefix);
        return redirect('/mall/account/login');
    }
}