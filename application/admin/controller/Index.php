<?php


namespace app\admin\controller;


use app\admin\controller\com\Admin;
use think\Request;

class Index extends Admin
{
    public function __construct(Request $request = null)
    {
        parent::__construct($request);
        return $this->redirect(url('/admin/goods.index/'));
    }


}