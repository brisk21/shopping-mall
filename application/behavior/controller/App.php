<?php


namespace app\behavior\controller;


use app\service\DiyLog;
use app\service\ErrorService;
use think\Response;

class App
{
    //app初始化行为监听
    function run($params)
    {
        //异常监听
        if (defined('BS_CATCH_ERROR')) {
            ErrorService::catch_error(BS_CATCH_ERROR);
        }

        //可以跨域的白名单
        $domains = ['localhost', 'g.abc.top', $_SERVER['HTTP_HOST']];
        $refer = isset($_SERVER['HTTP_REFERER']) ? $_SERVER['HTTP_REFERER'] : '';
        if (!empty($refer) && in_array(parse_url($refer, PHP_URL_HOST), $domains)) {
            header('Access-Control-Allow-Origin: *');
            header('Access-Control-Allow-Methods: POST, GET, PUT, OPTIONS'); //支持的http 动作
            header('Access-Control-Allow-Headers: *');//设置支持的header
            // 带 cookie 的跨域访问
            //header('Access-Control-Allow-Credentials: true');
            // 响应头设置
            //header('Access-Control-Allow-Headers:x-requested-with,Content-Type,X-CSRF-Token');
            //响应options这种试探类型请求
            if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
                header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization");
                Response::create()->contentType("application/json")->code(200)->send();
            }
        } else {
            //DiyLog::file($refer, '跨域.txt');
        }

    }

}