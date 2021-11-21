<?php


namespace app\service;


use app\common\controller\AppCommon;

class CommonUser
{
    /**
     * @param $uid int|string 用户的id或者uid
     * @param string $field
     */
    public static function get($uid,$field='*')
    {
        $where = ['uid'=>$uid];
        if (is_numeric($uid)){
            $where = ['id'=>intval($uid)];
        }

        return AppCommon::data_get('common_user',$where,$field);
    }
}