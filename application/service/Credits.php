<?php


namespace app\service;


use app\common\controller\AppCommon;

class Credits
{
    /**
     * @param $uid int|string 用户的id或者uid
     * @param string $field
     */
    public static function get($uid, $field = '*')
    {
        if (!CommonUser::get($uid, 'uid')) {
            return [];
        }

        $where = ['uid' => $uid];
        if (is_numeric($uid)) {
            $where = ['id' => intval($uid)];
        }


        $data = AppCommon::data_get('common_user_credits', $where, $field);

        if (empty($data)) {
            self::add($uid);
            $data = AppCommon::data_get('common_user_credits', $where, $field);
        }
        return $data;
    }

    public static function add($uid)
    {
        AppCommon::data_add('common_user_credits', [
            'credit' => 0,
            'point' => 0,
            'uid' => $uid
        ]);
    }

    /**
     * 更新账户余额
     * @param $uid string 用户uid
     * @param $field string 字段,credit-余额，point-积分
     * @param $num float 大于零是增加，否则减少
     */
    public static function update($uid, $field, $num)
    {
        $account = self::get($uid, $field);
        if (empty($account[$field]) || $num == 0) {
            return false;
        }
        $before = $account[$field];
        if ($num < 0) {
            $after = $before - abs($num);
        } else {
            $after = $before + abs($num);
        }

        return AppCommon::data_update('common_user_credits',['uid'=>$uid],[$field=>$after]);
    }

    //添加流水记录
    public static function log_add($data)
    {
        $data['add_time'] = time();
        return AppCommon::data_add('common_user_credit_log', $data);
    }
}