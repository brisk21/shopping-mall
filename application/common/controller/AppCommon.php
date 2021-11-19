<?php


namespace app\common\controller;


use think\Controller;
use think\Db;

class AppCommon extends Controller
{
    public static $db_where = null;
    public static $db_where_or = null;
    public static $fetch_sql = false;
    public static $db_order = null;


    /**
     * 新增数据
     * @param $table
     * @param $data
     * @return int|string
     */
    public static function data_add($table, $data)
    {
        return Db::name($table)->fetchSql(self::$fetch_sql)->insertGetId($data);
    }

    //更新数据
    public static function data_update($table, $where, $newData)
    {
        return Db::name($table)->fetchSql(self::$fetch_sql)->where($where)->where(self::$db_where)->update($newData);
    }

    //删除数据
    public static function data_del($table, $where)
    {
        return Db::name($table)->fetchSql(self::$fetch_sql)->where($where)->where(self::$db_where)->delete();
    }

    //单条查询
    public static function data_get($table, $where = null,$field='*')
    {
        return Db::name($table)->fetchSql(self::$fetch_sql)->where($where)->where(self::$db_where)->field($field)->find();
    }

    //批量查询
    public static function data_list($table, $where = null,$page=null,$field='*')
    {
        return Db::name($table)->fetchSql(self::$fetch_sql)->where($where)->where(self::$db_where)->whereOr(self::$db_where_or)->order(self::$db_order)->page($page)->field($field)->select();
    }

    public static function db($table)
    {
        return Db::name($table);
    }

}