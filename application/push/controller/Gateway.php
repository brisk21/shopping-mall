<?php
/**
 * Gateway独立模块，可以单独启动，方便windows调试
 */

namespace app\push\controller;

use think\worker\Server;

class Gateway extends Server
{
    public function __construct()
    {
        $gateway = new \GatewayWorker\Gateway("websocket://0.0.0.0:8002");
        $gateway->name = 'BS_SHOPGateway';
        $gateway->count = 2;
        //lanIp是Gateway所在服务器的内网IP，默认填写127.0.0.1即可。多服务器分布式部署的时候需要填写真实的内网ip，不能填写127.0.0.1。注意：lanIp只能填写真实ip，不能填写域名或者其它字符串，无论如何都不能写0.0.0.0 .
        $gateway->lanIp = '127.0.0.1';
        $gateway->startPort = 2900;
        $gateway->registerAddress = '127.0.0.1:8001';

        // 如果不是在根目录启动，则运行runAll方法
        if (!defined('GLOBAL_START')) {
            \Workerman\Worker::runAll();
        }
    }
}