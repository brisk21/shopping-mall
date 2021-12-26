<?php


namespace app\mall\controller;


use app\common\controller\AppCommon;
use app\mall\controller\com\Mall;
use app\service\CommonUser;
use app\service\ConfigService;
use app\service\DiyLog;
use app\service\Mailer;
use app\service\Msg;
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
        'mall/account/pwd_forget',
        'mall/account/reset_pwd',
        'mall/account/get_forget_pwd_dcode',
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


    //获取图形验证码
    public function get_vcode()
    {
        return captcha($id = 'bs_vcode', $config = [
            // 中文验证码字符串
            'useImgBg' => false,
            // 使用背景图片
            'fontSize' => 30,
            // 验证码字体大小(px)
            'useCurve' => true,
            // 是否画混淆曲线
            'useNoise' => true,
            // 是否添加杂点
            'imageH' => 0,
            // 验证码图片高度
            'imageW' => 0,
            // 验证码图片宽度
            'length' => 4,
            // 验证码位数
            'fontttf' => '',
            // 验证码字体，不设置随机获取
            'bg' => [243, 251, 254],
            // 背景颜色
            'reset' => true,
            // 验证成功后是否重置
            'useArithmetic' => false //是否使用算术验证码
        ]);
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
        if (!captcha_check($this->param['vcode'], 'bs_vcode')) {
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

    //获取找个密码的动态码
    public function get_forget_pwd_dcode()
    {
        if (empty($this->param['account'])) {
            data_return('登录账号未设置', -1);
        }
        if (empty($this->param['vcode'])) {
            data_return('请填写图形验证码', -1);
        }
        if (!captcha_check($this->param['vcode'], 'bs_vcode')) {
            data_return('图形验证码不正确', -1);
        }
        $user = AppCommon::data_get('common_user', ['account' => trim($this->param['account'])]);
        if (empty($user)) {
            data_return('账号不存在', 401);
        }
        if (!is_email($this->param['account']) && !is_phone($this->param['account'])) {
            data_return('仅支持手机号或者邮箱账户', -1);
        }
        $res = VerifyCode::send($this->param['account']);
        if ($res['code'] <> 0) {
            data_return($res['msg'], -1);
        }
        data_return('发送成功,注意查收');
    }

    //找回密码重置
    public function reset_pwd()
    {
        if (empty($this->param['account'])) {
            data_return('登录账号未设置', -1);
        }
        if (empty($this->param['dcode'])) {
            data_return('请输入动态码', -1);
        }
        if (empty($this->param['pwd'])) {
            data_return('密码没设置', -1);
        }
        if (strlen($this->param['pwd']) < 6) {
            data_return('密码不够安全', -1);
        }
        $user = AppCommon::data_get('common_user', ['account' => trim($this->param['account'])]);

        if (empty($user)) {
            data_return('账号不存在', 401);
        }
        $res = VerifyCode::check_code($user['account'], $this->param['dcode']);
        if ($res['code'] <> 0) {
            data_return($res['msg'], -1);
        }
        $this->do_change_pwd(trim($this->param['pwd']), $user['uid']);
        data_return('修改成功');
    }

    private function do_change_pwd($newPwd, $uid)
    {
        $salt = get_random(10, false);

        $data = [
            'pwd' => md5($newPwd . $salt),
            'salt' => $salt,
            'up_time' => time(),
            'pwd_err_count' => 0,
        ];
        return CommonUser::update($uid, $data);
    }

    //获取修改密码的动态码
    public function get_change_pwd_dcode()
    {
        $user = AppCommon::data_get('common_user', ['account' => trim($this->param['account'])]);

        if (empty($user)) {
            data_return('账号不存在', 401);
        }
        if (!is_email($user['account']) && !is_phone($user['account'])) {
            data_return('仅支持手机号或者邮箱账户', -1);
        }
        $res = VerifyCode::send($user['account']);
        if ($res['code'] <> 0) {
            data_return($res['msg'], -1);
        }
        data_return('发送成功,注意查收');
    }

    //修改密码
    public function change_pwd()
    {
        if (empty($this->param['dcode'])) {
            data_return('请输入动态码', -1);
        }
        if (empty($this->param['pwd'])) {
            data_return('密码没设置', -1);
        }
        if (strlen($this->param['pwd']) < 6) {
            data_return('密码不够安全', -1);
        }
        $user = CommonUser::get($this->uid, 'account');
        if (empty($user)) {
            data_return('登录超时', 401);
        }
        $res = VerifyCode::check_code($user['account'], $this->param['dcode']);
        if ($res['code'] <> 0) {
            data_return($res['msg'], -1);
        }
        $this->do_change_pwd(trim($this->param['pwd']), $user['uid']);

        data_return('修改成功');
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
            if (!captcha_check($this->param['vcode'], 'bs_vcode')) {
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
            'status' => 0,
            'loginCount' => 1,
        ];

        CommonUser::add($data);

        //登录记录
        AppCommon::data_add('common_user_login_log', [
            'uid' => $data['uid'],
            'add_time' => time(),
            'ip' => ip2long(get_ip()),
        ]);

        //登录状态
        session($this->key_cache_user, $data['uid'], $this->session_prefix);
        //简单生成一个token
        $key = md5(get_random(32) . time());
        $token = base64_encode($key);
        //清理其它token
        cache(null, $this->key_cache_user . $data['uid']);
        //设置新的token
        cache($this->key_cache_user_token . $key, $data['uid'], ['expire' => 86400 * 7], $this->key_cache_user . $data['uid']);

        data_return('注册成功', 0, ['token' => $token]);
    }

    //游客登录
    private function login_tmp_user()
    {
        $conf = ConfigService::get('mobile_shop');
        if (empty($conf['login_tmp_user'])) {
            data_return('系统已关闭游客登录功能', -1);
        }
        //生成游客账号
        $this->param['account'] = get_random(20);
        while (true) {
            $has = AppCommon::data_get('common_user', ['account' => trim($this->param['account'])], 'id');
            if (empty($has['id'])) {
                break;
            }
            $this->param['account'] = get_random(20);
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
            'pwd' => md5(get_random(32) . $salt),
            'salt' => $salt,
            'add_time' => time(),
            'up_time' => time(),
            'status' => 0,
            'loginCount' => 1,
            'nickname' => '游客' . get_random(6, true),
            'remark' => '游客临时用户',
        ];

        CommonUser::add($data);

        //登录记录
        AppCommon::data_add('common_user_login_log', [
            'uid' => $data['uid'],
            'add_time' => time(),
            'ip' => ip2long(get_ip()),
        ]);

        //登录状态
        session($this->key_cache_user, $data['uid'], $this->session_prefix);
        //简单生成一个token
        $key = md5(get_random(32) . time());
        $token = base64_encode($key);
        //清理其它token
        cache(null, $this->key_cache_user . $data['uid']);
        //设置新的token
        cache($this->key_cache_user_token . $key, $data['uid'], ['expire' => 86400 * 7], $this->key_cache_user . $data['uid']);

        Msg::add($data['uid'], [
            'title' => '游客账号创建成功',
            'content' => '您的账号是：' . $this->param['account'] . '，游客账号拥有和注册账号一样的权限，但仅限本次使用，如需要再次使用请记录本账号，并让后台管理帮您绑定邮箱、手机号或者修改密码，操作后即可成为正常可登录账号。<span style="color: red;display: block;">需要充值、下单请务必记得账号，否则难以找回。</span>',
            'type' => 1
        ]);

        data_return('登录成功', 0, ['token' => $token]);
    }

    public function do_login()
    {
        $from = !empty($this->param['from']) ? trim($this->param['from']) : '';
        if ($from === 'tmp_user') {
            //游客身份
            $this->login_tmp_user();
        }


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

        //简单生成一个token
        $key = md5(get_random(32));
        $token = base64_encode($key);
        //清理其它token
        cache(null, $this->key_cache_user . $data['uid']);
        //设置新的token
        cache($this->key_cache_user_token . $key, $data['uid'], ['expire' => 86400 * 7], $this->key_cache_user . $data['uid']);


        data_return('登录成功', 0, ['token' => $token]);
    }

    public function xieyi()
    {
        return $this->fetch();
    }

    //修改密码
    public function pwd_change()
    {
        return $this->fetch();
    }

    //忘记密码
    public function pwd_forget()
    {
        return $this->fetch();
    }

    //退出
    public function logout()
    {
        session($this->key_cache_user, null, $this->session_prefix);
        cache(null, $this->key_cache_user . $this->uid);
        if (IS_POST || IS_AJAX) {
            data_return();
        }
        return redirect('/mall/account/login');
    }
}