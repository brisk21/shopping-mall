<?php


namespace app\admin\controller\extend;


use app\admin\controller\com\Admin;

class Index extends Admin
{
    public function index()
    {
        return $this->fetch();
    }

    //管理
    public function manager()
    {
        return $this->fetch();
    }
}