<?php


namespace app\mall\controller\com;


use think\Controller;
use think\Log;
use think\Request;

class Mall extends Controller
{
    public $param = null;

    //不用登录的方法
    public $whiteList = [];

    public $uid = null;
    //公共用户缓存key
    public $key_cache_user = 'common_user_uid';
    public $session_prefix = 'bs_';

    public function __construct(Request $request = null)
    {
        parent::__construct($request);
        $this->param = input();
        $this->uid = session($this->key_cache_user,'',$this->session_prefix);
        $this->check_login($request);
    }

    //检查登录状态
    public function check_login(Request $request = null)
    {
        $model = $request->module();
        $controller = $request->controller();
        $action = $request->action();


        $route = strtolower($model.'/'.$controller.'/'.$action);

        if (empty($this->whiteList) || !in_array($route,$this->whiteList)){

            if (empty($this->uid)){
                if (IS_AJAX){
                    data_return('登录超时',4003,[
                        'login_url'=>URL_WEB.ltrim(url('/mall/account/login'),'/')
                    ]);
                }else{
                    return $this->redirect(url('/mall/account/login'),[],4003);
                }
            }
        }
        return true;
    }



}