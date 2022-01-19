<?php


namespace app\mall\controller;


use app\common\controller\AppCommon;
use app\mall\controller\com\Mall;
use app\service\CommonUser;
use app\service\ConfigService;
use app\service\DiyLog;
use app\service\WechatService;

class Home extends Mall
{
    public $whiteList = [
        'mall/home/index',
        'mall/home/news_info',
        'mall/home/config',
        'mall/home/news_list',
        'mall/home/get_banner',
        'mall/home/get_navs',
        'mall/home/get_article',
        'mall/home/get_article_info',
        'mall/home/get_xieyi_info',
        'mall/home/openid',
    ];

    //商城配置
    public function config()
    {
        $conf = ConfigService::get('mobile_shop');
        if (!empty($conf)) {
            data_return('ok', 0, $conf);
        }
        data_return('未配置', -1);
    }

    //微信授权缓存openid
    public function wx_openid()
    {
        if (cookie('authbacktourl')){
            $authbacktourl = cookie('authbacktourl');
            cookie('authbacktourl',null);
        }else{
            $authbacktourl = url('index');
        }

        if (!empty($this->param['from'])&&$this->param['from']=='gzh'){
            if (empty($this->param['code'])) {
                return $this->error('获取code授权失败');
            }
            $getOpenid = WechatService::get_openid($this->param['code']);
            if (empty($getOpenid['data']['openid'])){
                return $this->error('微信授权失败:'.$getOpenid['msg']);
            }
            //todo 用户信息的获取
            cookie('my_gzh_openid', $getOpenid['data']['openid']);

            $conf = WechatService::get_gzh_conf();
            if (!empty($conf['pt']) && $conf['pt'] =='gzh' && !empty($conf['userinfo'])) {
                $info = WechatService::get_user_info($getOpenid['data']['openid'],$this->param['state'],$getOpenid['data']['access_token']);
                if (!empty($info['data']['nickname'])){
                    CommonUser::update($this->uid,['nickname'=>$info['data']['nickname']]);
                }

            }

            return $this->redirect($authbacktourl);
        }else{
            $openid = input('openid');
            if (!empty($openid)) {
                cookie('my_gzh_openid', $openid);

                return $this->redirect($authbacktourl);
            }
            return $this->error('微信授权失败');
        }

    }

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
        $data = AppCommon::data_list_nopage('navs', ['status' => 0, 's_time' => ['<=', time()], 'e_time' => ['>=', time()]],  'id,title,url,img');
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
        $data = AppCommon::data_list('article', ['status' => 1], 1, 'id,title', 'id desc');

        data_return('ok', 0, [
            'article' => $data ? $data : null
        ]);
    }

    //获取导航公告文章-详情
    public function get_article_info($id = 0)
    {
        $data = AppCommon::data_get('article', ['id' => intval($id), 'status' => 1], '*');

        if ($data) {
            $data['content'] = htmlspecialchars_decode($data['content']);
            $data['add_time'] = date('Y-m-d', $data['add_time']);
            AppCommon::db('article')->where(['id'=>$data['id']])->setInc('count_view',1,5);
        }



        data_return('ok', 0, [
            'article' => $data ? $data : null
        ]);
    }

    //获取导航公告文章-详情
    public function get_xieyi_info()
    {
        $data = null;
        $gtype = !empty($this->param['gtype'])?trim($this->param['gtype']):'reg';
        if ($gtype=='reg'){
            $data = AppCommon::data_get('article_sys', ['id' => 1, 'status' => 1], '*');
        }

        if (!empty($data)) {
            $data['content'] = htmlspecialchars_decode($data['content']);
            $data['add_time'] = date('Y-m-d', $data['add_time']);
            AppCommon::db('article')->where(['id'=>$data['id']])->setInc('count_view',1,5);
        }

        data_return('ok', 0, [
            'article' => $data
        ]);
    }
}