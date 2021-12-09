<?php


namespace app\admin\controller\caiwu;


use app\admin\controller\com\Admin;
use app\common\controller\AppCommon;
use app\service\ErrorService;
use app\service\Page;
ErrorService::catch_error();
class Index extends Admin
{
    //余额记录
    public function credit()
    {
        $where = [];
        $orderBy = 'id desc';
        $page = !empty($this->param['page']) ? intval($this->param['page']) : 1;
        $pageSize = 10;
        $keyword = !empty($this->param['keyword']) ? trim($this->param['keyword']) : '';

        if (!empty($keyword)) {
            if (is_uid($keyword)) {
                $where['uid'] = $keyword;
            } else {
                $user = AppCommon::data_list_nopage('common_user', ['account' => ['like', '%' . $keyword . '%']], 'uid');
                if (!empty($user)) {
                    $where['uid'] = ['in', array_column($user, 'uid')];
                } else {
                    $where['uid'] = '';
                }
            }

        }

        $total = AppCommon::data_count('common_user_credit_log', $where);
        $data = AppCommon::data_list('common_user_credit_log', $where, $page . ',' . $pageSize, '*', $orderBy);
        if (!empty($data)) {
            foreach ($data as &$v) {
                $v['user'] = AppCommon::data_get('common_user', ['uid' => $v['uid']], 'account,uid');
                if (empty($v['user'])) {
                    $v['user'] = [
                        'uid' => $v['uid'],
                        'account' => '<span class="bs-red">已注销</span>'
                    ];
                }
            }
            unset($v);
        }

        $this->assign('page', Page::set($data, $pageSize, $page, $total, $this->param, url()));
        $this->assign('data', $data);
        return $this->fetch();
    }

    //积分记录
    public function point()
    {
        $where = [];
        $orderBy = 'id desc';
        $page = !empty($this->param['page']) ? intval($this->param['page']) : 1;
        $pageSize = 10;
        $keyword = !empty($this->param['keyword']) ? trim($this->param['keyword']) : '';

        if (!empty($keyword)) {
            if (is_uid($keyword)) {
                $where['uid'] = $keyword;
            } else {
                $user = AppCommon::data_list_nopage('common_user', ['account' => ['like', '%' . $keyword . '%']], 'uid');
                if (!empty($user)) {
                    $where['uid'] = ['in', array_column($user, 'uid')];
                } else {
                    $where['uid'] = '';
                }
            }

        }

        $total = AppCommon::data_count('common_user_point_log', $where);
        $data = AppCommon::data_list('common_user_point_log', $where, $page . ',' . $pageSize, '*', $orderBy);
        if (!empty($data)) {
            foreach ($data as &$v) {
                $v['user'] = AppCommon::data_get('common_user', ['uid' => $v['uid']], 'account,uid');
                if (empty($v['user'])) {
                    $v['user'] = [
                        'uid' => $v['uid'],
                        'account' => '<span class="bs-red">已注销</span>'
                    ];
                }
            }
            unset($v);
        }

        $this->assign('page', Page::set($data, $pageSize, $page, $total, $this->param, url()));
        $this->assign('data', $data);
        return $this->fetch();
    }
}