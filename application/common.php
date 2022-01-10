<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006-2016 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: 流年 <liu21st@gmail.com>
// +----------------------------------------------------------------------

// 应用公共文件

/**
 * @param string $msg
 * @param int $code
 * @param array $data
 * @param bool $exit
 * @return array|void
 */
function data_return($msg = '操作成功', $code = 0, $data = [], $exit = true)
{
    $ret = [
        'code' => $code,
        'msg' => $msg,
        'data' => $data
    ];
    if ($exit) {
        exit(json_encode($ret, JSON_UNESCAPED_UNICODE));
    }
    return $ret;
}

/**
 * @param string $msg
 * @param int $code
 * @param array $data
 * @return array
 */
function data_return_arr($msg = '操作成功', $code = 0, $data = [])
{
    $ret = [
        'code' => $code,
        'msg' => $msg,
        'data' => $data
    ];
    return $ret;
}

/**
 * 生成随机字符串
 * @param $length integer 字符串长度
 * @param false $numeric 是否纯数字
 * @return string
 */
function get_random($length, $numeric = FALSE)
{
    $seed = base_convert(md5(microtime(true) . $_SERVER['DOCUMENT_ROOT']), 16, $numeric ? 10 : 35);
    $seed = $numeric ? (str_replace('0', '', $seed) . '012340567890') : ($seed . 'zZ' . strtoupper($seed));
    if ($numeric) {
        $hash = '';
    } else {
        $hash = chr(rand(1, 26) + rand(0, 1) * 32 + 64);
        $length--;
    }
    $max = strlen($seed) - 1;
    for ($i = 0; $i < $length; $i++) {
        $hash .= $seed{mt_rand(0, $max)};
    }
    return $hash;
}

/**
 * 获取IP
 * @return mixed
 */
function get_ip()
{
    $ip = isset($_SERVER['REMOTE_ADDR']) ? $_SERVER['REMOTE_ADDR'] : '';
    if (isset($_SERVER['HTTP_CDN_SRC_IP'])) {
        $ip = $_SERVER['HTTP_CDN_SRC_IP'];
    } elseif (isset($_SERVER['HTTP_CLIENT_IP']) && preg_match('/^([0-9]{1,3}\.){3}[0-9]{1,3}$/', $_SERVER['HTTP_CLIENT_IP'])) {
        $ip = $_SERVER['HTTP_CLIENT_IP'];
    } elseif (isset($_SERVER['HTTP_X_FORWARDED_FOR']) and preg_match_all('#\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}#s', $_SERVER['HTTP_X_FORWARDED_FOR'], $matches)) {
        foreach ($matches[0] as $xip) {
            if (!preg_match('#^(10|172\.16|192\.168)\.#', $xip)) {
                $ip = $xip;
                break;
            }
        }
    }
    return $ip;
}

/**
 * 数据验证
 * @param $data array 需要验证的数组对象
 * @param $rules array 规则
 * @return array
 * @author blog.alipay168.cn
 */
function check_param(&$data, $rules)
{
    if (empty($data) || !is_array($data) || empty($rules) || !is_array($rules)) {
        return ['code' => -500, 'msg' => '数据或者规则为空'];
    }
    foreach ($rules as $value) {
        if (empty($value['key']) || empty($value['msg']) || empty($value['type'])) {
            return ['code' => -500, 'msg' => '内部错误'];
        }
        switch (strtolower($value['type'])) {
            case 'length':
                if (empty($value['rule'])) {
                    return ['code' => -500, 'msg' => '内部错误'];
                }
                if (!isset($data[$value['key']])) {
                    return ['code' => -500, 'msg' => '内部错误:' . $value['key'] . '未设置'];
                }
                $rule = explode(',', $value['rule']);
                $length = mb_strlen($data[$value['key']]);
                if (count($rule) == 1) {
                    //固定长度
                    if ($length <> intval($rule[0])) {
                        return ['code' => -1, 'msg' => $value['msg']];
                    }
                } else {
                    //长度区间
                    if ($length < intval($rule[0]) || $length > intval($rule[1])) {
                        return ['code' => -1, 'msg' => $value['msg']];
                    }
                }
                break;
            case 'empty':
                if (empty($data[$value['key']])) {
                    return ['code' => -1, 'msg' => $value['msg']];
                }
                break;
            case 'isset':
                if (!isset($data[$value['key']])) {
                    return ['code' => -1, 'msg' => $value['msg']];
                }
                break;
            case 'in_array':
                if (empty($value['rule']) || !is_array($value['rule'])) {
                    return ['code' => -500, 'msg' => '内部错误'];
                }

                if (!in_array($data[$value['key']], $value['rule'])) {
                    return ['code' => -1, 'msg' => $value['msg']];
                }

                break;
            case 'func':
            case 'function':
                if (!is_callable($value['rule'])) {
                    return ['code' => -500, 'msg' => '内部错误'];
                }
                if (!isset($data[$value['key']]) || !$value['rule']($data[$value['key']])) {

                    return ['code' => -1, 'msg' => $value['msg']];
                }
                break;
            case 'min':
                if (!isset($data[$value['key']]) || intval($data[$value['key']]) < intval($value['rule'])) {
                    return ['code' => -1, 'msg' => $value['msg']];
                }
                break;
            case 'max':
                if (!isset($data[$value['key']]) || intval($data[$value['key']]) > intval($value['rule'])) {
                    return ['code' => -1, 'msg' => $value['msg']];
                }
                break;
            default:
                //todo 其他扩展

        }
    }
    return ['code' => 0, 'msg' => 'ok'];
}

//通用返回父类和子类分类树，树形，php tree
//getTree($data,'category_id','parent_id');

function tree($arr, $id = 'id', $fid = 'fid', $child_name = 'children')
{
    $refer = array();
    $tree = array();
    foreach ($arr as $k => $v) {
        $refer[$v[$id]] = &$arr[$k]; //创建主键的数组引用
    }
    foreach ($arr as $k => $v) {
        $pid = $v[$fid]; //获取当前分类的父级id
        if ($pid == 0) {
            $tree[] = &$arr[$k]; //顶级栏目
        } else {
            if (isset($refer[$pid])) {
                $refer[$pid][$child_name][] = &$arr[$k]; //如果存在父级栏目，则添加进父级栏目的子栏目数组中
            }
        }
    }
    return $tree;
}

//判断访问的终端
function fromClient()
{
    if (isset($_SERVER['HTTP_USER_AGENT']) && strpos($_SERVER['HTTP_USER_AGENT'], 'MicroMessenger')) {
        return "weixin";
    } elseif (isset($_SERVER['HTTP_USER_AGENT']) && strpos($_SERVER['HTTP_USER_AGENT'], 'AlipayClient')) {
        return "alipay";
    } elseif (isset($_SERVER['HTTP_USER_AGENT']) && strpos($_SERVER['HTTP_USER_AGENT'], 'QQ')) {
        return "qq";
    } else if (!isMobile()) {
        return 'pc';
    } else {
        return 'other';
    }
}


/*移动端判断*/
function isMobile()
{
    // 如果有HTTP_X_WAP_PROFILE则一定是移动设备
    if (isset ($_SERVER['HTTP_X_WAP_PROFILE'])) {
        return true;
    }
    // 如果via信息含有wap则一定是移动设备,部分服务商会屏蔽该信息
    if (isset ($_SERVER['HTTP_VIA'])) {
        // 找不到为flase,否则为true
        return stristr($_SERVER['HTTP_VIA'], "wap") ? true : false;
    }
    // 脑残法，判断手机发送的客户端标志,兼容性有待提高
    if (isset ($_SERVER['HTTP_USER_AGENT'])) {
        $clientkeywords = array('nokia',
            'sony', 'ericsson', 'mot', 'samsung', 'htc', 'sgh', 'lg', 'sharp', 'sie-', 'philips', 'panasonic', 'alcatel',
            'lenovo', 'iphone', 'ipod', 'blackberry', 'meizu', 'android', 'netfront', 'symbian', 'ucweb', 'windowsce',
            'palm', 'operamini', 'operamobi', 'openwave', 'nexusone', 'cldc', 'midp', 'wap', 'mobile'
        );
        // 从HTTP_USER_AGENT中查找手机浏览器的关键字
        if (preg_match("/(" . implode('|', $clientkeywords) . ")/i", strtolower($_SERVER['HTTP_USER_AGENT']))) {
            return true;
        }
    }
    // 协议法，因为有可能不准确，放到最后判断
    if (isset ($_SERVER['HTTP_ACCEPT'])) {
        // 如果只支持wml并且不支持html那一定是移动设备
        // 如果支持wml和html但是wml在html之前则是移动设备
        if ((strpos($_SERVER['HTTP_ACCEPT'], 'vnd.wap.wml') !== false) && (strpos($_SERVER['HTTP_ACCEPT'], 'text/html') === false || (strpos($_SERVER['HTTP_ACCEPT'], 'vnd.wap.wml') < strpos($_SERVER['HTTP_ACCEPT'], 'text/html')))) {
            return true;
        }
    }
    return false;

}

/**
 * 打印数据
 * @param $data
 * @param bool $hide
 */
function view_data($data, $hide = false)
{
    if ($hide) {
        echo '<!--';
        print_r($data);
        echo '-->';
    } else {
        print_r($data);
    }
}

//浏览器控制台调试
function view_data_console($data)
{
    if (is_object($data) || is_array($data)) {
        $data = json_encode($data, JSON_UNESCAPED_UNICODE);
    }

    $js = '<script >console.log(' . $data . ')</script>';
    echo $js;
}

/**
 * @param $str
 * @return bool
 */
function is_url($str)
{
    $pattern = "#(http|https)://(.*\.)?.*\..*#i";
    if (preg_match($pattern, $str)) {
        return true;
    } else {
        return false;
    }
}

/***
 * 随机生成数字
 * @param int $length
 * @return string
 */
function GetNumberCode($length = 6)
{
    $code = '';
    for ($i = 0; $i < intval($length); $i++) $code .= rand(1, 9);
    return $code;
}

/**
 * 隐藏部分字符串,比如隐藏手机中间4位，用*号代表：str_hidden(13500000000,3,4,'****');//135****0000
 * @param $str string 要处理的字符串
 * @param $start int 开始位置
 * @param $length int 处理长度
 * @param string $replaceTo 替换后的字符串
 * @return mixed
 */

function str_hidden($str, $start, $length, $replaceTo = '****')
{
    return substr_replace($str, $replaceTo, $start, $length);
}

/**
 * 支持中文的字符串截取
 * @param $str
 * @param $start
 * @param $length
 * @param null $enc
 * @return string
 */
function str_mb_hidden($str, $start, $length, $enc = null)
{
    return mb_substr($str, $start, $length, $enc = null);
}

/**
 * 截取字符串
 * @param $str
 * @param $length
 * @param int $start
 * @return string
 */
function str_cut($str, $length, $start = 0)
{
    return mb_substr($str, $start, $length, 'utf-8');
}


/**
 * 获取设备类型
 * @return string
 */
function get_device_type()
{
    //全部变成小写字母
    $agent = isset($_SERVER['HTTP_USER_AGENT']) ? strtolower($_SERVER['HTTP_USER_AGENT']) : '';
    $type = 'other';
    //分别进行判断
    if (strpos($agent, 'iphone') || strpos($agent, 'ipad')) {
        $type = 'ios';
    }

    if (strpos($agent, 'android')) {
        $type = 'android';
    }
    return $type;
}

/**
 * 是否是手机号
 * @param $mobile
 * @return bool
 */
function is_phone($mobile)
{
    if (!is_numeric($mobile)) {
        return false;
    }
    return preg_match('#^1[3,4,5,7,8,9]{1}[\d]{9}$#', $mobile) ? true : false;
}


/**
 * 判断是否属于uid
 * @param $str
 * @return bool
 */
function is_uid($str)
{
    if (stripos($str, 'bs') !== false && mb_strlen($str) === 34) {
        return true;
    }
    return false;
}

/**
 * 是否为邮箱
 * @param $email
 * @return bool
 */
function is_email($email)
{
    $chars = "/^([a-z0-9+_]|\\-|\\.)+@(([a-z0-9_]|\\-)+\\.)+[a-z]{2,6}\$/i";
    if (strpos($email, '@') !== false && strpos($email, '.') !== false) {
        if (preg_match($chars, $email)) {
            return true;
        } else {
            return false;
        }
    } else {
        return false;
    }

}

/**
 * 删除目录
 * @param $dirName
 */
function del_dir($dirName)
{
    if (is_dir($dirName)) {
        $dir = opendir($dirName);
        while ($fileName = readdir($dir)) {
            if ($fileName != "." && $fileName != "..") {
                $file = $dirName . "/" . $fileName;
                if (is_dir($file)) {
                    del_dir($file);
                } else {
                    @unlink($file);
                }
            }
        }
        closedir($dir);
        //删除目录
        rmdir($dirName);
    }
}


/**
 * 判断IP输入是否合法
 * @param string $ip IP地址
 * @return bool
 */
function is_ip($ip)
{
    if (preg_match('/^((?:(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))\.){3}(?:25[0-5]|2[0-4]\d|((1\d{2})|([1 -9]?\d))))$/', $ip)) {
        return true;
    } else {
        return false;
    }
}

/**
 * 循环删除目录和文件
 * @param string $dir_name
 * @return bool
 */
function delete_dir_file($dir_name)
{
    $result = false;
    if (is_dir($dir_name)) {
        if ($handle = opendir($dir_name)) {
            while (false !== ($item = readdir($handle))) {
                if ($item != '.' && $item != '..') {
                    if (is_dir($dir_name . DS . $item)) {
                        delete_dir_file($dir_name . DS . $item);
                    } else {

                        unlink($dir_name . DS . $item);
                    }
                }
            }
            closedir($handle);
            if (rmdir($dir_name)) {
                $result = true;
            }
        }
    }
    return $result;
}