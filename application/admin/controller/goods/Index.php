<?php


namespace app\admin\controller\goods;


use app\admin\controller\com\Admin;
use app\common\controller\AppCommon;
use app\service\DiyLog;
use app\service\Page;
use think\Paginator;
use think\paginator\driver\Bootstrap;

class Index extends Admin
{
    public function index($recycle = false)
    {
        $where = [];
        $sort = !empty($this->param['sort']) ? trim($this->param['sort']) : '';
        $status = isset($this->param['status']) && is_numeric($this->param['status']) ? intval($this->param['status']) : '';
        $categoryId = !empty($this->param['category_id']) ? intval($this->param['category_id']) : 0;
        $keyword = !empty($this->param['keyword']) ? trim($this->param['keyword']) : '';
        $orderBy = 'id desc';
        if ($sort == 'id_asc') {
            $orderBy = 'id asc';
        } elseif ($sort == 'id_desc') {
            $orderBy = 'id desc';
        } elseif ($sort == 'price_asc') {
            $orderBy = 'price asc';
        } elseif ($sort == 'price_desc') {
            $orderBy = 'price desc';
        } elseif ($sort == 'sale_asc') {
            $orderBy = 'sale asc';
        } elseif ($sort == 'sale_desc') {
            $orderBy = 'sale desc';
        } elseif ($sort == 'stock_asc') {
            $orderBy = 'stock asc';
        } elseif ($sort == 'stock_desc') {
            $orderBy = 'stock desc';
        }
        if ($status == '0' || $status == 1) {
            $where['status'] = $status;
        } elseif ($status == -1) {
            $where['stock'] = 0;
        }
        if (!empty($categoryId)) {
            $where['category_id'] = $categoryId;
        }
        if (!empty($keyword)) {
            $where['title'] = ['like', '%' . $keyword . '%'];
        }
        if ($recycle) {
            $where['is_del'] = 1;
        } else {
            $where['is_del'] = 0;
        }

        $page = !empty($this->param['page']) ? intval($this->param['page']) : 1;
        $pageSize = 10;

        $goods = AppCommon::data_list('goods', $where, $page . ',' . $pageSize, 'title,thumb,id,market_price,price,stock,stock_locked,status,sale,add_time', $orderBy);


        $total = AppCommon::data_count('goods', $where);
        $category = AppCommon::data_list_nopage('goods_category', ['status' => 1]);
        if ($category) {
            $this->assign('category', tree($category, 'category_id', 'parent_id', 'subcat'));
        }

        $this->assign('page', Page::set($goods, $pageSize, $page, $total, $this->param, url()));
        $this->assign('goods', $goods);
        if ($recycle) {
            $tpl = 'recycle';
        } else {
            $tpl = 'index';
        }
        return $this->fetch($tpl);
    }


    public function form()
    {
        $id = !empty($this->param['id']) ? intval($this->param['id']) : 0;
        if ($id) {
            $goods = AppCommon::data_get('goods', ['id' => $id]);
            if (!empty($goods)) {
                $goods['banners'] = json_decode($goods['banners'], true);
                $goods['content'] = htmlspecialchars_decode($goods['content']);
                $this->assign('goods', $goods);
            }

        }
        //??????
        $stores = AppCommon::data_list_nopage('stores');
        if (!empty($stores)) {
            $this->assign('stores', $stores);
        }


        $category = AppCommon::data_list_nopage('goods_category', ['status' => 1]);
        if ($category) {
            $this->assign('category', tree($category, 'category_id', 'parent_id', 'subcat'));
        }
        return $this->fetch();
    }

    //????????????
    public function action()
    {
        $id = !empty($this->param['id']) ? intval($this->param['id']) : 0;
        $ac = !empty($this->param['ac']) ? trim($this->param['ac']) : '';
        if (!empty($id)) {
            $goods = AppCommon::data_get('goods', ['id' => intval($id)]);
            if (empty($goods)) {
                data_return('??????????????????', -1);
            }
            //???????????????
            if ($ac == 'recycle') {
                AppCommon::data_update('goods', ['id' => $goods['id']], ['is_del' => 1, 'status' => 0]);
                data_return('????????????????????????????????????????????????');
            }elseif ($ac == 'copy') {
                $data = [
                    'title' => 'copy_' . $goods['title'],
                    'goods_desc' => trim($goods['goods_desc']),
                    'banners' => $goods['banners'],
                    'content' => $goods['content'],
                    'thumb' => $goods['thumb'],
                    'market_price' => floatval($goods['market_price']),
                    'price' => floatval($goods['price']),
                    'stock' => intval($goods['stock']),
                    'category_id' => intval($goods['category_id']),
                    'status' => 0,
                    'is_top' => $goods['is_top'],
                    'store_num' => $goods['store_num'],
                ];
                $data['add_time'] = time();
                $res = AppCommon::data_add('goods', $data);
                data_return('????????????');
            }
        }

        $rule = [
            ['type' => 'length', 'key' => 'title', 'rule' => '2,80', 'msg' => '????????????2~80??????',],
            ['type' => 'empty', 'key' => 'category_id', 'rule' => '', 'msg' => '???????????????',],
            ['type' => 'empty', 'key' => 'thumb', 'rule' => '', 'msg' => '??????????????????',],
            ['type' => 'min', 'key' => 'price', 'rule' => '0.01', 'msg' => '?????????????????????',],
            ['type' => 'min', 'key' => 'market_price', 'rule' => '0.01', 'msg' => '??????????????????',],
            ['type' => 'empty', 'key' => 'stock', 'rule' => '', 'msg' => '?????????????????????',],
            ['type' => 'empty', 'key' => 'banners', 'rule' => '', 'msg' => '????????????????????????',],
            ['type' => 'empty', 'key' => 'store_num', 'rule' => '', 'msg' => '???????????????',],
        ];
        $check = check_param($this->param, $rule);
        if ($check['code'] <> 0) {
            data_return($check['msg'], $check['code']);
        }
        if (count($this->param['banners']) > 10) {
            data_return('?????????????????????10???', -1);
        }

        $data = [
            'title' => trim($this->param['title']),
            'goods_desc' => trim($this->param['desc']),
            'banners' => json_encode($this->param['banners']),
            'content' => $this->param['content'],
            'thumb' => trim($this->param['thumb']),
            'market_price' => floatval($this->param['market_price']),
            'price' => floatval($this->param['price']),
            'stock' => intval($this->param['stock']),
            'category_id' => intval($this->param['category_id']),
            'status' => !empty($this->param['status']) ? 1 : 0,
            'banner2detail' => !empty($this->param['banner2detail']) ? 1 : 0,
            'is_top' => !empty($this->param['is_top']) ? 1 : 0,
            'store_num' => intval($this->param['store_num']),
        ];
        if (!empty($id)) {

            $res = AppCommon::data_update('goods', ['id' => intval($id)], $data);
        } else {
            $data['add_time'] = time();
            $res = AppCommon::data_add('goods', $data);
        }
        //parent::add_admin_log(['title' => '????????????', 'content' => $data]);

        data_return('????????????', 0, [
            'res' => $res
        ]);
    }

    //????????????
    public function comment()
    {
        $where = [];
        $status = isset($this->param['status']) && is_numeric($this->param['status']) ? intval($this->param['status']) : '';
        $orderBy = 'id desc';

        if ($status) {
            $where['status'] = $status;
        }


        $page = !empty($this->param['page']) ? intval($this->param['page']) : 1;
        $pageSize = 10;
        $total = AppCommon::data_count('goods_comment', $where);
        $data = AppCommon::data_list('goods_comment', $where, $page . ',' . $pageSize, '*', $orderBy);

        if ($data) {
            foreach ($data as &$v) {
                $v['add_time'] = date('Y-m-d H:i:s', $v['add_time']);
                if (!empty($v['imgs'])) {
                    $v['imgs'] = explode(',', $v['imgs']);
                }
                $v['user']['avatar'] = URL_WEB . '/static/com/img/user-default.jpg';
                $v['user'] = AppCommon::data_get('common_user', ['uid' => $v['uid']], 'account,nickname');
                if (empty($v['user'])) {
                    $v['user']['nickname'] = '?????????';
                    $v['user']['account'] = '?????????';
                } elseif ($v['is_hide_user'] == 1) {
                    $v['user']['nickname'] = '????????????';
                }
                $v['goods'] = AppCommon::data_get('goods', ['id' => $v['goods_id']], 'title,thumb');
                if ($v['status'] == 0) {
                    $v['statusDesc'] = '<span class="bs-red">?????????</span>';
                } else {
                    $v['statusDesc'] = '<span class="bs-green">?????????</span>';
                }
            }
            unset($v);
        }


        $this->assign('page', Page::set($data, $pageSize, $page, $total, $this->param, url()));
        $this->assign('data', $data);
        return $this->fetch();
    }

    //????????????
    public function comment_action()
    {
        $id = !empty($this->param['id']) ? intval($this->param['id']) : 0;
        if (!empty($id)) {
            $data = AppCommon::data_get('goods_comment', ['id' => intval($id)]);
            if (empty($data)) {
                data_return('???????????????', -1);
            }
            //?????????
            if (!empty($this->param['ac']) && $this->param['ac'] == 'del') {
                AppCommon::data_del('goods_comment', ['id' => $data['id']]);
                parent::add_admin_log(['title' => '??????????????????', 'content' => $data]);
                data_return('????????????');
            }
        }
        $res = AppCommon::data_update('goods_comment', ['id' => intval($id)], ['status' => 1]);
        data_return('?????????', 0, [
            'res' => $res
        ]);
    }

    //?????????
    public function recycle()
    {
        return $this->index(true);
    }

    //???????????????
    public function recycle_action()
    {
        if (!IS_AJAX) {
            data_return('????????????', -1);
        }
        $id = !empty($this->param['id']) ? intval($this->param['id']) : 0;
        if (empty($id)) {
            data_return('????????????', -1);
        }
        $goods = AppCommon::data_get('goods', ['id' => intval($id)]);
        if (empty($goods)) {
            data_return('??????????????????', -1);
        }
        $ac = !empty($this->param['ac']) ? $this->param['ac'] : '';
        //????????????
        if ($ac == 'del') {
            AppCommon::data_del('goods', ['id' => $goods['id']]);
            DiyLog::file($goods, 'del_goods_' . date('Ymd') . '.log');
            data_return('????????????', 0);
        } elseif ($ac == 'restore') {
            //??????
            AppCommon::data_update('goods', ['id' => $goods['id']], ['is_del' => 0]);
            data_return('????????????');
        }
        data_return('????????????', -1);
    }

}