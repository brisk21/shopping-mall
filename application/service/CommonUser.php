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
     * 创建账号
     * @param $data
     * @return false|int|string
     */
    public static function add($data)
    {
        if (empty($data['uid'])) {
            return false;
        }
        $conf = ConfigService::get('mobile_shop');
        if (empty($conf['reg_type']) || $conf['reg_type'] == -1) {
            return false;
        }

        $id = AppCommon::data_add('common_user', [
            'account' => !empty($data['account']) ? strip_tags($data['account']) : '',
            'uid' => $data['uid'],
            'pwd' => !empty($data['pwd']) ? $data['pwd'] : md5(get_random(32)),
            'salt' => get_random(10),
            'add_time' => time(),
            'up_time' => time(),
            'status' => 0,
            'loginCount' => !empty($data['loginCount']) ? $data['loginCount'] : 0,
            'nickname' => !empty($data['nickname']) ? $data['nickname'] : '',
            'remark' => !empty($data['remark']) ? $data['remark'] : '',
            'openid_wx' => !empty($data['openid_wx']) ? $data['openid_wx'] : '',
        ]);
        if ($id && !empty($conf['reg_gift_credit'])) {
            $res = Credits::update($data['uid'], 'credit', $conf['reg_gift_credit'], [
                'remark' => '注册赠送余额',
                'type' => 2,//1-购买商品，2-充值记录，3-提现记录,
            ]);
        }
        return $id;
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