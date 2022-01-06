<?php


namespace app\mall\controller;


use app\common\controller\AppCommon;
use app\mall\controller\com\Mall;
use app\service\CommonUser;
use app\service\Credits;
use app\service\FeedBackService;
use think\Request;

class User extends Mall
{
    public function __construct(Request $request = null)
    {
        parent::__construct($request);
    }

    //个人中心
    public function index()
    {
        return $this->fetch();
    }

    public function address_info()
    {
        return $this->fetch();
    }

    public function address_list()
    {
        return $this->fetch();
    }

    //交易记录
    public function record()
    {
        return $this->fetch();
    }

    //用户信息
    public function info()
    {
        $data = CommonUser::get($this->uid, 'account,uid,status');

        data_return('ok', 0, ['user_info' => $data]);
    }

    //我的地址
    public function my_address()
    {
        $data = AppCommon::data_list('common_user_address', ['uid' => $this->uid], 1, '*', 'is_default desc,id asc');

        data_return('ok', 0, [
            'address' => $data
        ]);
    }

    //地址详情
    public function my_address_info()
    {
        if (empty($this->param['id'])) {
            data_return('参数有误', -1);
        }
        $data = AppCommon::data_get('common_user_address', ['id' => intval($this->param['id']), 'uid' => $this->uid]);

        if (empty($data)) {
            data_return('地址不存在', -1);
        }

        data_return('ok', 0, [
            'address' => $data
        ]);

    }

    //操作地址
    public function my_address_action($id = 0)
    {
        if (!empty($this->param['id'])) {
            $data = AppCommon::data_get('common_user_address', ['id' => intval($this->param['id']), 'uid' => $this->uid]);
            if (!empty($this->param['from']) && $this->param['from'] == 'del') {
                AppCommon::data_del('common_user_address', ['id' => $data['id']]);
                data_return('删除成功', 0);
            }
        }
        $rule = [
            ['type' => 'empty', 'key' => 'addr', 'rule' => '', 'msg' => '请选择地址',],
            ['type' => 'empty', 'key' => 'detail', 'rule' => '', 'msg' => '请填写详细地址',],
            ['type' => 'empty', 'key' => 'mobile', 'rule' => '', 'msg' => '请填写收件人手机号',],
            ['type' => 'empty', 'key' => 'username', 'rule' => '', 'msg' => '请填写收件人',],
        ];
        $check = check_param($this->param, $rule);
        if ($check['code'] <> 0) {
            data_return($check['msg'], $check['code']);
        }


        $addr = explode(' ', $this->param['addr']);
        if (empty($addr[2])) {
            data_return('地址选择不正确', -1);
        }
        $newData = [
            'province' => strip_tags($addr[0]),
            'city' => strip_tags($addr[1]),
            'area' => strip_tags($addr[2]),
            'town' => '',
            'is_default' => !empty($this->param['is_default']) ? 1 : 0,
            'address' => strip_tags($this->param['detail']),
            'username' => strip_tags($this->param['username']),
            'mobile' => strip_tags($this->param['mobile'])
        ];
        //先清理其他默认情况
        if (!empty($this->param['is_default'])) {
            AppCommon::data_update('common_user_address', ['uid' => $this->uid], ['is_default' => 0]);
        }
        if (empty($data)) {
            $newData['uid'] = $this->uid;
            AppCommon::data_add('common_user_address', $newData);
        } else {
            AppCommon::data_update('common_user_address', ['id' => $data['id']], $newData);
        }

        data_return('操作成功');
    }

    //订单统计
    public function order_count($getData = false)
    {
        $prefix = config('database')['prefix'];
        $table = $prefix . 'order';
        $data = AppCommon::query("select 
        sum(if(status=0,1,0)) as count0,
        sum(if(status=1,1,0)) as count1,
        sum(if(status=2,1,0)) as count2,
        sum(if(status=3,1,0)) as count3 from $table  where uid='" . $this->uid . "' ");

        $data = !empty($data[0]) ? $data[0] : [];
        !empty($data['count0']) || $data['count0'] = 0;
        !empty($data['count1']) || $data['count1'] = 0;
        !empty($data['count2']) || $data['count2'] = 0;
        !empty($data['count3']) || $data['count3'] = 0;
        if ($getData) {
            return $data;
        }

        data_return('ok', 0, [
            'count' => $data
        ]);
    }

    //我的账户余额
    public function my_credits($getData = false)
    {
        $data = Credits::get($this->uid, 'point,credit');
        //我收藏的商品数量
        $data['goods'] = AppCommon::db('goods_favorite')->where(['uid' => $this->uid])->count('*');
        if ($getData) {
            return $data;
        }
        data_return('ok', 0, [
            'credits' => $data
        ]);
    }

    //数量统计
    public function data_count()
    {
        $data['order'] = $this->order_count(true);

        $data['credit'] = Credits::get($this->uid, 'point,credit');

        $data['goods'] = AppCommon::db('goods_favorite')->where(['uid' => $this->uid])->count('*');
        //未读消息
        $data['msg'] = AppCommon::db('common_user_msg')->where(['uid' => $this->uid, 'read_time' => 0])->count('*');

        data_return('ok', 0, [
            'count' => $data
        ]);
    }

    //我的交易记录
    public function my_records()
    {
        $type = !empty($this->param['type']) ? intval($this->param['type']) : 1;
        $where = ['uid' => $this->uid, 'type' => $type];
        $page = !empty($this->param['page']) ? intval($this->param['page']) : 1;

        $data = AppCommon::data_list('common_user_credit_log', $where, $page, 'add_time,remark,num,type', 'id desc');

        if (!empty($data)) {
            foreach ($data as &$value) {
                $value['add_time'] = date('Y-m-d H:i:s', $value['add_time']);
                if ($value['num'] > 0) {
                    $value['ctype'] = '+';
                } else {
                    $value['num'] = abs($value['num']);
                    $value['ctype'] = '-';
                }
            }
            unset($value);
        }

        data_return('ok', 0, [
            'records' => $data
        ]);
    }

    public function recharge()
    {
        return $this->fetch();
    }

    public function balance()
    {
        return $this->fetch();
    }

    public function msg()
    {
        return $this->fetch();
    }

    public function msg_detail()
    {
        if (IS_AJAX || IS_POST) {
            if (!empty($this->param['id'])) {
                $data = AppCommon::data_get('common_user_msg', ['uid' => $this->uid, 'id' => intval($this->param['id'])], '*');
                if (empty($data)) {
                    data_return('消息不存在', -1);
                }
                $data['add_time'] = date('Y年m月d日', $data['add_time']);
                $data['typeDesc'] = $data['type'] == 0 ? '普通消息' : '系统通知';
                if (empty($data['read_time'])) {
                    AppCommon::data_update('common_user_msg', ['id' => $data['id']], ['read_time' => time()]);
                }
                unset($data['read_time']);

                data_return('ok', 0, [
                    'msg' => $data
                ]);
            }
        }
        return $this->fetch();
    }

    public function msg_list()
    {
        $page = !empty($this->param['page']) ? intval($this->param['page']) : 1;
        $data = AppCommon::data_list('common_user_msg', ['uid' => $this->uid], $page, 'id,title,content,type,add_time,read_time', 'id desc');
        if ($data) {
            foreach ($data as &$v) {
                $v['add_time'] = date('Y年m月d日', $v['add_time']);
                $v['content'] = mb_substr($v['content'], 0, 15, 'utf-8') . '......';
                $v['typeDesc'] = $v['type'] == 1 ? '普通消息' : '系统通知';
                if ($v['read_time'] > 0) {
                    $v['status'] = 1;
                } else {
                    $v['status'] = 0;
                }
                unset($v['read_time']);
            }
            unset($v);
        }
        data_return('ok', 0, [
            'msg_list' => $data
        ]);
    }


    //设置中心
    public function setting()
    {
        return $this->fetch();
    }

    //留言反馈
    public function feedback()
    {
        if (IS_AJAX || IS_POST) {
            if (empty($this->param['category']) || empty($this->param['content'])) {
                data_return('请填写选择分类填写内容', -1);
            }

            if (!empty($this->param['imgs'])) {
                if (!is_array($this->param['imgs'])) {
                    $this->param['imgs'] = array_filter(explode(',', str_replace('，', ',', $this->param['imgs'])));
                }
            }
            if (!empty($this->param['imgs']) && count($this->param['imgs']) > 3) {
                data_return('图片不能超过3张', -1);
            }

            if (AppCommon::data_count('feedback', ['uid' => $this->uid, 'add_time' => ['>=', strtotime('today')]]) >= 5) {
                data_return('今天您已提交多次，请明天继续哦', -1);
            }

            $res = FeedBackService::add([
                'uid' => $this->uid,
                'category' => $this->param['category'],
                'content' => $this->param['content'],
                'imgs' => !empty($this->param['imgs']) ? join(',', $this->param['imgs']) : '',
            ]);

            data_return('感谢您的留言/反馈');


        }

        return $this->fetch();
    }

}