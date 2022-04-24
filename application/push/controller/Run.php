<?php
/**
 * 全部启动功能
 * linux 下使用，全部运行功能，对应workerman/service_all.php
 */

namespace app\push\controller;

use GatewayWorker\BusinessWorker;
use Workerman\Worker;
use GatewayWorker\Gateway;
use GatewayWorker\Register;

class Run extends Worker
{
    public function __construct()
    {
        $this->start_register();
        $this->start_business();
        $this->start_gateway();
        //运行所有Worker;
        // 如果不是在根目录启动，则运行runAll方法
        if (!defined('GLOBAL_START')) {
            Worker::runAll();
        }

    }

    //开始注册
    private function start_register()
    {
        $register = new Register('text://0.0.0.0:8001');
        $register->name = 'BS_SHOPRegister';
    }

    //初始化 bussinessWorker 进程,注意最后的绑定事件，这样可以融合在自定义的模块
    private function start_business()
    {
        $worker = new BusinessWorker();
        $worker->name = 'BS_SHOPBusinessWorker';
        $worker->count = 4;
        $worker->registerAddress = '127.0.0.1:8001';
        //异常日志目录
        $worker::$logFile = RUNTIME_PATH.'log/workman.log';
        //绑定事件监听类
        $worker->eventHandler = '\app\push\controller\Events';
    }

    //初始化gateway
    private function start_gateway()
    {
        $gateway = new Gateway("websocket://0.0.0.0:8002");
        $gateway->name = 'BS_SHOPGateway';
        $gateway->count = 2;
        //lanIp是Gateway所在服务器的内网IP，默认填写127.0.0.1即可。多服务器分布式部署的时候需要填写真实的内网ip，不能填写127.0.0.1。注意：lanIp只能填写真实ip，不能填写域名或者其它字符串，无论如何都不能写0.0.0.0

        $gateway->lanIp = '127.0.0.1';
        $gateway->startPort = 2900;
        $gateway->registerAddress = '127.0.0.1:8001';
    }


}