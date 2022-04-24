<?php
namespace app\push\controller;

use think\Controller;
use think\Db;
use GatewayWorker\Lib\Gateway;
/**

 * 主要是处理 onConnect onMessage onClose 三个方法
 */
class Events extends Controller
{
    /**
     * 当客户端发来消息时触发
     * @param int $client_id 连接id
     * @param mixed $message 具体消息
     */
    public static function onMessage($client_id, $message)
    {
        $message =  @json_decode($message, true);
        if (empty($message['type'])){
            return ;
        }
        $type = $message['type'];
        switch ($type) {
            case 'start':
                if (empty($message['bsid'])){
                    return ;
                }
                //需要绑定的ID，可以是用户登录的ID、uid、特殊标识
                $bsid = $message['bsid'];
                //保存
                $_SESSION['bs_id'] = $bsid;
                $_SESSION['bs_name'] = 'BS_SHOP_'.rand(1000,10000);
                //绑定UID到当前登录的id，方便推送消息
                // 将当前链接与uid绑定
                Gateway::bindUid($client_id, $bsid);
                // 通知当前客户端初始化
                $message_data = array(
                    'type' => 'login',
                    'code' => 0,
                    'message' =>'success',
                    'time'=>time(),
                    'data'=>[

                    ]
                );
                //给当前登录的id发送消息
               // Gateway::sendToClient($client_id, json_encode($message_data,JSON_UNESCAPED_UNICODE));

                //给所有在线用户发送消息
                /*$message_data = array(
                    'type' => 'info',
                    'code' => 0,
                    'message' =>'欢迎新用户登录:'.$bsid,
                    'time'=>time(),
                    'data'=>[

                    ]
                );
                Gateway::sendToAll(json_encode($message_data,JSON_UNESCAPED_UNICODE));*/
                break;
                return;
            case 'ping':
                //心跳检测，返回ok
                Gateway::sendToClient($client_id, 'pong');
                return;
            case 'test':
                //随机返回句子
                $arr = [
                    1 => '机遇对于有准备的头脑有特别的亲和力。', 2 => '不求与人相比，但求超越自己，要哭就哭出激动的泪水，要笑就笑出成长的性格！', 3 => '在你内心深处，还有无穷的潜力，有一天当你回首看时，你就会知道这绝对是真的。', 4 => '无论你觉得自己多么的了不起，也永远有人比你更强；无论你觉得自己多么的不幸，永远有人比你更加不幸。', 5 => '不要浪费你的生命，在你一定会后悔的地方上。', 6 => '放弃该放弃的是无奈，放弃不该放弃的是无能；不放弃该放弃的是无知，不放弃不该放弃的是执着。', 7 => '不要轻易用过去来衡量生活的幸与不幸！每个人的生命都是可以绽放美丽的，只要你珍惜。', 8 => '千万别迷恋网络游戏，要玩就玩好人生这场大游戏。', 9 => '过错是暂时的遗憾，而错过则是永远的遗憾！', 10 => '人生是个圆，有的人走了一辈子也没有走出命运画出的圆圈，其实，圆上的每一个点都有一条腾飞的切线。'
                ];
                $k = array_rand($arr);
                $message_data = array(
                    'type' => 'text',
                    'code' => 0,
                    'message' =>'success',
                    'time'=>time(),
                    'data'=>[
                        'content'=>$arr[$k]
                    ]
                );
                //给当前登录的id发送消息
                Gateway::sendToClient($client_id, json_encode($message_data,JSON_UNESCAPED_UNICODE));
                return;
            default:

                Gateway::sendToClient($client_id, json_encode(self::other_logic($message),JSON_UNESCAPED_UNICODE));
                return;

        }
        return ;
    }

    //其它逻辑
    private static function other_logic($message)
    {
        $data = array(
            'type' => 'unknown',
            'code' => 0,
            'message' =>'未知消息类型',
            'time'=>time(),
            'data'=>[
               'content' =>'abcccc'
            ]
        );
        return $data;
    }

    /**
     * 当客户端连接时触发
     * @param int $client_id 连接id
     */
    public static function onConnect($client_id)
    {

    }

    /**
     * 当连接断开时触发的回调函数
     * @param $connection
     */
    public static function onClose($client_id)
    {
        $message_data = array(
            'type' => 'info',
            'code' => 0,
            'message' =>'用户退出:'.$_SESSION['bs_id'],
            'data'=>[
                'time'=>time()
            ]
        );
        Gateway::sendToAll(json_encode($message_data,JSON_UNESCAPED_UNICODE));
    }

    /**
     * 当客户端的连接上发生错误时触发
     * @param $connection
     * @param $code
     * @param $msg
     */
    public static function onError($client_id, $code, $msg)
    {
        echo "error $code $msg\r\n";
    }

    /**
     * 每个进程启动
     * @param $worker
     */
    public static function onWorkerStart($worker)
    {

    }
}