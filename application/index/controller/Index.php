<?php
namespace app\index\controller;

use app\common\controller\AppCommon;
use think\App;
use think\Controller;
use think\Db;

class Index extends Controller
{
    public function index()
    {
        AppCommon::$fetch_sql = 1;
        AppCommon::$db_where_or = [
            'title'=>'adfdsdfs'
        ];
        AppCommon::$db_where = ['id'=>['>=','1']];
        AppCommon::$db_order = 'id desc ,title desc ';
        $data = AppCommon::data_list('goods',['id'=>['>','1']],1);
        $this->assign('data',$data);
        print_r($data);exit();
        return $this->fetch();
    }

    public function up()
    {
        AppCommon::$fetch_sql = 1;
       $res = AppCommon::data_update('goods',['id'=>9],['title'=>'adfdsfsf'.time()]);

       var_dump($res);
    }

    public function del()
    {

        echo AppCommon::data_del('goods',['id'=>8]);
    }


}
