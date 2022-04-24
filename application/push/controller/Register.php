<?php
/**
 * Register独立模块，可以单独启动，方便windows调试
 */

namespace app\push\controller;


use think\worker\Server;

class Register extends Server
{

    public function __construct()
    {
        //初始化register
        $register = new \GatewayWorker\Register('text://0.0.0.0:8001');
        $register->name = 'BS_SHOPRegister';
        // 如果不是在根目录启动，则运行runAll方法
        if (!defined('GLOBAL_START')) {
            \Workerman\Worker::runAll();
        }

    }
}