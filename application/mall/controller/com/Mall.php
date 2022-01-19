<?php


namespace app\mall\controller\com;


use app\service\DiyLog;
use app\service\WechatService;
use think\Controller;
use think\Log;
use think\Request;

class Mall extends Controller
{
    public $param = null;

    //不用登录的方法
    public $whiteList = [];

    public $uid;
    //公共用户缓存key
    public $key_cache_user = 'common_user_uid';
    //前后分离key
    public $key_cache_user_token = 'common_user_token';
    public $session_prefix = 'bs_';

    public function __construct(Request $request = null)
    {
        parent::__construct($request);
        $this->param = input();
        $this->get_header($request);
        if (empty($this->uid)) {
            $this->uid = session($this->key_cache_user, '', $this->session_prefix);
        }
        $this->check_login($request);

    }

    //通过header获取uid,仅针对前后分离的逻辑，mvc用session
    private function get_header($request)
    {
        if (empty($this->uid)) {
            $header = $request->header();
            if (!empty($header['bstoken'])) {
                $key = base64_decode($header['bstoken']);
                $uid = cache($this->key_cache_user_token . $key);
                if ($uid) {
                    $this->uid = $uid;
                }
            }
        }
    }



    //微信环境检测授权
    public function wx_env()
    {
        if (fromClient() <> 'weixin') {
            return;
        }
        $openid = cookie('my_gzh_openid');
        if (!empty($openid)){
            return;
        }
        $conf = WechatService::get_gzh_conf();
        if (empty($conf['pt'])) {
            if (IS_AJAX) {
                data_return('未配置公众号信息', -1);
            }
            return $this->error('未配置公众号信息');
        }
        if ($conf['pt'] == 'wei1-top') {
            $type = !empty($conf['userinfo'])?'userInfo':'openid';
            if (!IS_AJAX) {
                cookie('authbacktourl',\request()->url());
                $curl = URL_WEB . url('/mall/home/wx_openid');
                $url = "https://wxauth.alipay168.cn/weixin/gzh/$type/akey/" . $conf['akey'] . ".html?my_redirect_uri=" . urlencode($curl);
                return $this->redirect($url);
            } elseif (empty($openid)) {
                $curl = URL_WEB . url('/mall/home/wx_openid');
                $url = "https://wxauth.alipay168.cn/weixin/gzh/$type/akey/" . $conf['akey'] . ".html?my_redirect_uri=" . urlencode($curl);
                data_return('微信环境检测，即将进入首页...', 30002, $url);
            }
        } else {
            $url = URL_WEB . trim(url('/mall/home/wx_openid', ['from' => 'gzh']), '/');
            $codeUrl = WechatService::get_code($url, !empty($conf['userinfo']));
            if (!IS_AJAX) {
                cookie('authbacktourl',\request()->url());
                return $this->redirect($codeUrl['data']['url']);
            } else {
                $url = $codeUrl['data']['url'];
                data_return('微信环境检测，即将进入首页...', 30002, $url);
            }
        }
    }

    //检查登录状态
    public function check_login(Request $request = null)
    {
        $model = $request->module();
        $controller = $request->controller();
        $action = $request->action();

        $route = strtolower($model . '/' . $controller . '/' . $action);

        if (empty($this->whiteList) || !in_array($route, $this->whiteList)) {

            if (empty($this->uid)) {
                if (IS_AJAX || IS_POST) {
                    data_return('登录超时', 401, [
                        'login_url' => URL_WEB . ltrim(url('/mall/account/login'), '/')
                    ]);
                } else {
                    return $this->redirect(url('/mall/account/login'), [], 4003);
                }
            }
        }
        return true;
    }


}