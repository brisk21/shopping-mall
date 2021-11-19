<?php


namespace app\mall\controller\com;


use think\Controller;
use think\Request;

class Mall extends Controller
{
    public $param = null;

    public $uid = null;
    //公共用户缓存key
    public $key_cache_user = 'common_user_uid';

    public function __construct(Request $request = null)
    {
        parent::__construct($request);
        $this->param = input();

        $this->uid = session($this->key_cache_user);
    }



}