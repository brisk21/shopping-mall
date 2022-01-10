<?php
/**
 * @email blog.alipay168.cn
 * @author bs_shop
 * @link http://blog.alipay168.cn
 * @Date: 2022-01-10 19:16:19
 */
namespace app\plugin\controller\bs_app_demo;

use think\Controller;
class Index extends Controller
{
    function index()
    {
        return $this->fetch();
    }

    //配置的方式，可选
    public static function config()
    {
        $element = [];
        return [
            "element"=> $element,
        ];
    }
}