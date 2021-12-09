<?php


namespace app\index\controller;


use think\Controller;

class Error extends Controller
{
    public function err_404()
    {
        return $this->fetch();
    }
}