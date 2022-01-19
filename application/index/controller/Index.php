<?php

namespace app\index\controller;

use app\common\controller\AppCommon;
use app\service\DiyLog;
use app\service\Pay;
use app\service\WechatService;
use think\App;
use think\Controller;
use think\Db;

class Index extends Controller
{
    public function index()
    {
        return $this->redirect(url('/mall/home/index'));
    }


}
