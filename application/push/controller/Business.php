<?php
/**
 * Business独立模块，可以单独启动，方便windows调试
 */
namespace app\push\controller;
use GatewayWorker\BusinessWorker;
use think\worker\Server;

class Business extends Server
{
    /**
     * 构造函数
     * @access public
     */

    public function __construct()
    {
        //初始化 bussinessWorker 进程
        $worker = new BusinessWorker();
        $worker->name = 'BS_SHOPBusinessWorker';
        $worker->count = 2;
        $worker->registerAddress = '127.0.0.1:8001';
        //设置处理业务的类,此处制定Events的命名空间
        $worker->eventHandler = '\app\push\controller\Events';
        //异常日志目录
        $worker::$logFile = RUNTIME_PATH.'log/workman.log';
        // 如果不是在根目录启动，则运行runAll方法
        if(!defined('GLOBAL_START'))
        {
            \Workerman\Worker::runAll();
        }

    }
}