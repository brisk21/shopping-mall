<?php
if (!defined('BS_SHOP')){
    exit('access denied');
}
//配置目录
defined('ROOT_PATH') or define('ROOT_PATH',__DIR__.'/../');
defined('PUBLIC_PATH') or define('PUBLIC_PATH',ROOT_PATH.'/../');
defined('EXTEND_PATH') or define('EXTEND_PATH', ROOT_PATH . 'extend' . DIRECTORY_SEPARATOR);
defined('VENDOR_PATH') or define('VENDOR_PATH', ROOT_PATH . 'vendor' . DIRECTORY_SEPARATOR);
defined('RUNTIME_PATH') or define('RUNTIME_PATH', ROOT_PATH . 'runtime' . DIRECTORY_SEPARATOR);
defined('LOG_PATH') or define('LOG_PATH', RUNTIME_PATH . 'log' . DIRECTORY_SEPARATOR);
defined('CACHE_PATH') or define('CACHE_PATH', RUNTIME_PATH . 'cache' . DIRECTORY_SEPARATOR);
defined('TEMP_PATH') or define('TEMP_PATH', RUNTIME_PATH . 'temp' . DIRECTORY_SEPARATOR);
defined('CONF_PATH') or define('CONF_PATH', ROOT_PATH.'config'.DIRECTORY_SEPARATOR); // 配置文件目录


define('URL_WEB','http://shop.test.top/');

// 是否ajax
define('IS_AJAX', ((isset($_SERVER['HTTP_X_REQUESTED_WITH']) &&
        'xmlhttprequest' == strtolower($_SERVER['HTTP_X_REQUESTED_WITH'])) ||
    isset($_REQUEST['ajax']) && $_REQUEST['ajax'] == 'ajax'));
//是否post
define('IS_POST', isset($_SERVER['REQUEST_METHOD']) &&   strtolower($_SERVER['REQUEST_METHOD'])=='post');