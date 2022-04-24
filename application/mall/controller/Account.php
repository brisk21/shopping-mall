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
use app\service\WechatService;
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
        'mall/account/wx_login',
    ];

    public function __construct(Request $request = null)
    {
        parent::__construct($request);

    }



    public function index()
    {
        return redirect('/mall/home/index');
    }







}