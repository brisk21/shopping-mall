<?php


namespace app\admin\controller\goods;


use app\admin\controller\com\Admin;
use app\common\controller\AppCommon;
use app\service\Page;
use think\Paginator;
use think\paginator\driver\Bootstrap;

class Index extends Admin
{
    public function index()
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
        return $this->fetch();
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
        //已通过审核的店铺
        $stores = AppCommon::data_list_nopage('stores', ['is_check' => 1]);
        if (!empty($stores)) {
            $this->assign('stores', $stores);
        }


        $category = AppCommon::data_list_nopage('goods_category', ['status' => 1]);
        if ($category) {
            $this->assign('category', tree($category, 'category_id', 'parent_id', 'subcat'));
        }
        return $this->fetch();
    }

    //商品操作
    public function action()
    {
        $id = !empty($this->param['id']) ? intval($this->param['id']) : 0;
        if (!empty($id)) {
            $goods = AppCommon::data_get('goods', ['id' => intval($id)]);
            if (empty($goods)) {
                data_return('商品已不存在', -1);
            }
            //仅删除
            if (!empty($this->param['ac']) && $this->param['ac'] == 'del') {
                AppCommon::data_del('goods', ['id' => $goods['id']]);
                parent::add_admin_log(['title' => '删除商品', 'content' => $goods]);
                data_return('删除成功');
            }
        }

        $rule = [
            ['type' => 'length', 'key' => 'title', 'rule' => '2,80', 'msg' => '商品名称2~80字符',],
            ['type' => 'empty', 'key' => 'category_id', 'rule' => '', 'msg' => '请选择分类',],
            ['type' => 'empty', 'key' => 'thumb', 'rule' => '', 'msg' => '请选择封面图',],
            ['type' => 'min', 'key' => 'price', 'rule' => '0.01', 'msg' => '请输入商品价格',],
            ['type' => 'min', 'key' => 'market_price', 'rule' => '0.01', 'msg' => '市场价未设置',],
            ['type' => 'empty', 'key' => 'stock', 'rule' => '', 'msg' => '商品库存未设置',],
            ['type' => 'empty', 'key' => 'banners', 'rule' => '', 'msg' => '轮播图未选择图片',],
            ['type' => 'empty', 'key' => 'store_num', 'rule' => '', 'msg' => '请选择店铺',],
        ];
        $check = check_param($this->param, $rule);
        if ($check['code'] <> 0) {
            data_return($check['msg'], $check['code']);
        }
        if (count($this->param['banners']) > 10) {
            data_return('轮播图不能超过10张', -1);
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
            'is_top' => !empty($this->param['is_top']) ? 1 : 0,
            'store_num' => intval($this->param['store_num']),
        ];
        if (!empty($id)) {

            $res = AppCommon::data_update('goods', ['id' => intval($id)], $data);
        } else {
            $data['add_time'] = time();
            $res = AppCommon::data_add('goods', $data);
        }
        //parent::add_admin_log(['title' => '增改商品', 'content' => $data]);

        data_return('操作完成', 0, [
            'res' => $res
        ]);
    }

    //评价列表
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

        if ($data){
            foreach ($data as &$v){
                $v['add_time'] = date('Y-m-d H:i:s',$v['add_time']);
                if (!empty($v['imgs'])){
                    $v['imgs'] = explode(',',$v['imgs']);
                }
                $v['user']['avatar'] = URL_WEB.'/static/com/img/user-default.jpg';
                $v['user'] = AppCommon::data_get('common_user', ['uid' => $v['uid']], 'account,nickname');
                if (empty($v['user'])) {
                    $v['user']['nickname'] = '已注销';
                    $v['user']['account'] = '已注销';
                }elseif($v['is_hide_user']==1){
                    $v['user']['nickname'] = '匿名用户';
                }
                $v['goods'] = AppCommon::data_get('goods',['id'=>$v['goods_id']],'title,thumb');
                if ($v['status']==0){
                    $v['statusDesc'] = '<span class="bs-red">待审核</span>';
                }else{
                    $v['statusDesc'] = '<span class="bs-green">已通过</span>';
                }
            }
            unset($v);
        }


        $this->assign('page', Page::set($data, $pageSize, $page, $total, $this->param, url()));
        $this->assign('data', $data);
        return $this->fetch();
    }

    //评价操作
    public function comment_action()
    {
        $id = !empty($this->param['id']) ? intval($this->param['id']) : 0;
        if (!empty($id)) {
            $data = AppCommon::data_get('goods_comment', ['id' => intval($id)]);
            if (empty($data)) {
                data_return('记录不存在', -1);
            }
            //仅删除
            if (!empty($this->param['ac']) && $this->param['ac'] == 'del') {
                AppCommon::data_del('goods_comment', ['id' => $data['id']]);
                parent::add_admin_log(['title' => '删除商品评价', 'content' => $data]);
                data_return('删除成功');
            }
        }
        $res = AppCommon::data_update('goods_comment', ['id' => intval($id)], ['status'=>1]);
        data_return('已通过', 0, [
            'res' => $res
        ]);
    }
}