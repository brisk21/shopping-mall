<?php


namespace app\behavior\controller;

use app\common\controller\AppCommon;
use app\service\ConfigService;
use app\service\DiyLog;
use app\service\ErrorService;
use think\Cache;
use think\Db;
use think\Response;

class App
{
    //app初始化行为监听
    function run($params)
    {
        $this->limit_request($params);
        //异常监听
        if (defined('BS_CATCH_ERROR')) {
            ErrorService::catch_error(BS_CATCH_ERROR);
        }
        //可以跨域的白名单
        $domains = ['localhost', 'shop.test.top', 'demo.bs.shop.wei1.top'];
        $refer = isset($_SERVER['HTTP_REFERER']) ? $_SERVER['HTTP_REFERER'] : '';
        if (!empty($refer) && in_array(parse_url($refer, PHP_URL_HOST), $domains)) {
            @header('Access-Control-Allow-Origin: *');
            @header('Access-Control-Allow-Methods: POST, GET, PUT, OPTIONS'); //支持的http 动作
            @header('Access-Control-Allow-Headers: *');//设置支持的header
            // 带 cookie 的跨域访问
            //header('Access-Control-Allow-Credentials: true');
            // 响应头设置
            //header('Access-Control-Allow-Headers:x-requested-with,Content-Type,X-CSRF-Token');
            //响应options这种试探类型请求
            if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
                @header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization");
                Response::create()->contentType("application/json")->code(200)->send();
            }
        }

        //数据库查询慢日志监控
        Db::listen(function ($sql, $time, $explain, $master) {
            if ($time >= 5 && stripos($sql, 'SHOW COLUMNS') === false) {
                DiyLog::$save_path = RUNTIME_PATH . '/log/diy/sql/';
                DiyLog::file([
                    'sql' => $sql, 'time' => $time, 'explain' => $explain, 'master' => $master
                ], date('Ymd.log'));
            }
        });
    }

    function appEnd($params)
    {

    }

    /**
     * 限流设置
     * @param $params
     * @author blog@alipay168.cn
     */
    private function limit_request($params)
    {
        $ip = request()->ip();
        $confIpBlackList = ConfigService::get('ip_blacklist', false);
        if (!empty($confIpBlackList)) {
            if (in_array($ip, $confIpBlackList)) {
                Response::create()->contentType("application/json")->code(403)->send();
                data_return('访问异常，请稍后重试', 403);
            }
        }
        //限流配置
        $route = !empty($params['module']) ? join('|', $params['module']) : '';
        $keyRequest = 'request_limit_' . md5($ip . $route . __FILE__ . date('YmdHis'));
        if (extension_loaded('redis')) {
            $cacheDriver = 'redis';
        } elseif (extension_loaded('memcached')) {
            $cacheDriver = 'memcached';
        } elseif (extension_loaded('memcache')) {
            $cacheDriver = 'memcache';
        } else {
            $cacheDriver = 'default';
        }
        $ipCount = Cache::store($cacheDriver)->get($keyRequest);
        if (empty($ipCount)) {
            $ipCount = 1;
        } else {
            $ipCount++;
        }
        Cache::store($cacheDriver)->set($keyRequest, $ipCount, 3);

        //同一个接口请求每秒限流
        if ($ipCount >= 10) {
            $webSafeConf = ConfigService::get('web_safe');
            if (empty($webSafeConf['api_limit_set_second'])) {
                $webSafeConf['api_limit_set_second'] = 20;
            }
            if ($ipCount >= $webSafeConf['api_limit_set_second']) {
                $this->add_ip_list($ip, 'black');
                Response::create()->contentType("application/json")->code(403)->send();
            } else {
                $this->add_ip_list($ip);
                //todo 来个温馨提示，请求过于频繁
            }
        }

    }

    /**
     * 添加到IP名单
     * @param $ip
     * @param string $type dubious-可疑，black-黑名单
     */
    private function add_ip_list($ip, $type = 'dubious')
    {
        if ($type == 'dubious') {
            $key = 'request_limit_ips';
            $data = ConfigService::get($key);
            if (!empty($data)) {
                $data = array_unique(array_merge($data, [$ip]));
            } else {
                $data = [$ip];
            }
        } else {
            //直接拉黑
            $key = 'ip_blacklist';
            $data = ConfigService::get($key);
            if (!empty($data)) {
                $data = array_unique(array_merge($data, [$ip]));
            } else {
                $data = [$ip];
            }
            //移除可疑列表中的ip
            $limit_ips = ConfigService::get('request_limit_ips');
            if (!empty($limit_ips)) {
                $limit_ips = array_flip($limit_ips);
                if (isset($limit_ips[$ip])) {
                    unset($limit_ips[$ip]);
                }
                $limit_ips = array_flip($limit_ips);
                ConfigService::action('request_limit_ips', $limit_ips);
            }
        }
        ConfigService::action($key, $data);
    }

}