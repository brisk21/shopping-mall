<?php


namespace app\service;


use app\common\controller\AppCommon;

class CommonUser
{
    /**新增用户
     * @param $uid int|string 用户的id或者uid
     * @param string $field
     * @return array|bool|\PDOStatement|string|\think\Model|null
     */
    public static function get($uid, $field = '*')
    {
        $where = ['uid' => $uid];
        if (is_numeric($uid)) {
            $where = ['id' => intval($uid)];
        }

        return AppCommon::data_get('common_user', $where, $field);
    }

    /**
     * 更新信息
     * @param $uid
     * @param $data
     * @return false|int|string
     */
    public static function update($uid, $data)
    {
        if (!self::get($uid)) {
            return false;
        }
        return AppCommon::data_update('common_user', ['uid' => $uid], $data);
    }
}