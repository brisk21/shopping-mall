<?php


namespace app\mall\controller;


use app\common\controller\AppCommon;
use app\mall\controller\com\Mall;

class Home extends Mall
{
    public function index()
    {
        return $this->fetch();
    }

    public function news_info()
    {
        return $this->fetch();
    }

    public function news_list()
    {
        return $this->fetch();
    }

    //获取轮播图
    public function get_banner()
    {
        $data = AppCommon::data_list('banner', ['status' => 0, 's_time' => ['<=', time()], 'e_time' => ['>=', time()]], 1, 'id,title,url,img');
        if (!empty($data)) {
            array_walk($data, function (&$v) {
                if (stripos($v['img'], 'http') === false) {
                    $v['img'] = URL_WEB . ltrim($v['img'], '/');
                }
            });
        }
        data_return('ok', 0, [
            'banner' => $data
        ]);
    }

    //获取导航图标
    public function get_navs()
    {
        $data = AppCommon::data_list('navs', ['status' => 0, 's_time' => ['<=', time()], 'e_time' => ['>=', time()]], 1, 'id,title,url,img');
        if (!empty($data)) {
            array_walk($data, function (&$v) {
                if (stripos($v['img'], 'http') === false) {
                    $v['img'] = URL_WEB . ltrim($v['img'], '/');
                }
            });
        }
        data_return('ok', 0, [
            'navs' => $data
        ]);
    }

    //获取导航公告文章
    public function get_article()
    {
        AppCommon::$db_order = 'id desc';
        $data = AppCommon::data_list('article', ['status' => 1], 1, 'id,title');

        data_return('ok', 0, [
            'article' => $data ? $data : null
        ]);
    }

    //获取导航公告文章-详情
    public function get_article_info($id=0)
    {
        AppCommon::$db_order = 'id desc';
        $data = AppCommon::data_get('article', ['id'=>intval($id),'status' => 1],  '*');

        if ($data){
            $data['content'] = htmlspecialchars_decode($data['content']);
            $data['add_time'] = date('Y-m-d',$data['add_time']);
        }

        data_return('ok', 0, [
            'article' => $data ? $data : null
        ]);
    }
}