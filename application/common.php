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
    $ip = $_SERVER['REMOTE_ADDR'];
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