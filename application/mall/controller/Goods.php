<?php


namespace app\mall\controller;


use app\common\controller\AppCommon;
use app\mall\controller\com\Mall;
use app\service\DiyLog;
use think\App;

class Goods extends Mall
{
    public $whiteList = [
        'mall/goods/goods_list',
        'mall/goods/goods_detail',
        'mall/goods/get_classify',
        'mall/goods/pro_list',
        'mall/goods/classify',
        'mall/goods/detail',
        'mall/goods/my_cart_total',
        'mall/goods/get_comment',
    ];

    //商品列表
    public function goods_list()
    {
        $page = !empty($this->param['page']) ? intval($this->param['page']) : 1;
        $sort = !empty($this->param['sort']) ? trim($this->param['sort']) : 'normal';
        $from = !empty($this->param['from']) ? trim($this->param['from']) : '';
        if ($sort == 'normal') {
            $order = 'sale desc,id desc';
        } elseif ($sort == 'price_desc') {
            $order = "price desc,sale desc,id desc";
        } elseif ($sort == 'price_asc') {
            $order = "price asc,sale desc,id desc";
        } elseif ($sort == 'sale_asc') {
            $order = "sale asc,id desc";
        } elseif ($sort == 'sale_desc') {
            $order = "sale desc,id desc";
        }

        $where = ['status' => 1];
        //首页精选推荐
        if ($from == 'home-jingxuan') {
            $where['is_top'] = 1;
        } elseif ($from == 'home_list') {
            //来自首页猜你喜欢
            $where['is_top'] = 0;
        } elseif ($from == 'hot_category') {
            //首页推荐商品,todo 动态化后台
            $where['category_id'] = '13';
        } elseif ($from == 'detail') {
            //详情的看了又看推荐 todo 根据用户搜索记录、购买记录推荐
            $order = 'sale desc';
        }

        if (!empty($this->param['category_id'])) {
            $where['category_id'] = intval($this->param['category_id']);
        }

        if (!empty($this->param['keyword'])) {
            $where['title'] = ['like', '%' . trim(strip_tags($this->param['keyword'])) . '%'];
        }

        $goods = AppCommon::data_list('goods', $where, $page, 'id,title,market_price,price,stock,sale,thumb', $order);
        $total = AppCommon::data_count('goods', $where);

        data_return('ok', 0, [
            'goods' => $goods,
            'total' => $total
        ]);
    }

    //商品详情
    public function goods_detail()
    {
        $id = !empty($this->param['id']) ? intval($this->param['id']) : 0;
        $goods = AppCommon::data_get('goods', ['id' => $id, 'status' => 1], 'id,title,goods_desc,thumb,market_price,price,stock,sale,status,banners,content,category_id,store_num');
        if ($goods) {
            if (!empty($goods['banners'])) {
                $goods['banners'] = json_decode($goods['banners'], true);
            }
            $goods['content'] = htmlspecialchars_decode($goods['content'], ENT_QUOTES);

            $goods['has_favorite'] = AppCommon::data_get('goods_favorite', ['uid' => $this->uid, 'goods_id' => $goods['id']], 'id');
        }
        data_return('ok', 0, [
            'goods' => $goods
        ]);

    }

    //收藏操作
    public function favorite_action($id = 0)
    {
        $goods = AppCommon::data_get('goods', ['id' => intval($id)], 'id,status');
        if (!$goods || $goods['status'] <> 1) {
            data_return('商品已下线', -1);
        }
        $uid = $this->uid;

        $has = AppCommon::data_get('goods_favorite', ['uid' => $uid, 'goods_id' => $goods['id']]);

        if (!empty($has['id'])) {
            AppCommon::data_del('goods_favorite', ['id' => $has['id']]);
            $status = 0;
        } else {
            AppCommon::data_add('goods_favorite', ['uid' => $uid, 'goods_id' => $goods['id']]);
            $status = 1;
        }

        data_return($status == 1 ? '收藏成功' : '已取消收藏', 0, ['status' => $status]);
    }

    //我的收藏商品
    public function my_favorite_goods()
    {
        $where = [
            'a.uid' => $this->uid
        ];
        $page = !empty($this->param['page']) ? intval($this->param['page']) : 1;

        //关联查询
        $goods = AppCommon::db('goods_favorite a')
            ->join('goods b', 'b.id = a.goods_id')
            ->where($where)
            ->page($page)
            //->fetchSql(1)
            ->order('id desc')
            ->field('b.id,b.title,b.market_price,b.price,b.stock,b.sale,b.thumb,a.id as aid')
            ->select();

        data_return('ok', 0, [
            'goods' => $goods
        ]);

    }

    //我的收藏商品
    public function my_cart_goods()
    {
        $where = [
            'a.uid' => $this->uid
        ];
        $page = !empty($this->param['page']) ? intval($this->param['page']) : 1;

        //关联查询
        $goods = AppCommon::db('cart a')
            ->join('goods b', 'b.id = a.goods_id')
            ->join('stores c', 'b.store_num = c.store_num')
            ->where($where)
            ->page($page)
            ->order('id desc')
            ->field('b.title,b.price,b.thumb,a.id,a.count,a.status,a.goods_id,c.store_name,c.store_name')
            ->select();

        $has = AppCommon::data_get('cart', ['uid' => $this->uid, 'status' => 0], 'id');
        $isAllChecked = true;
        if (!empty($has['id'])) {
            $isAllChecked = false;
        }

        data_return('ok', 0, [
            'goods' => $goods,
            'isAllChecked' => $isAllChecked
        ]);

    }

    //操作购物车
    public function my_cart_action()
    {
        $type = !empty($this->param['dotype']) ? $this->param['dotype'] : 'add';
        $id = !empty($this->param['id']) ? intval($this->param['id']) : 0;
        $count = !empty($this->param['count']) ? intval($this->param['count']) : 0;

        if (!empty($id)) {
            $data = AppCommon::data_get('cart', ['id' => $id, 'uid' => $this->uid]);
            //todo 判断商品是否可用
        }

        if ($type == 'Decrease' || $type == 'del') {
            if ($count <= 0) {
                //删除
                AppCommon::data_del('cart', ['uid' => $this->uid, 'id' => intval($id)]);
            } elseif (empty($data)) {
                data_return('先添加购物车', -1);
            } else {
                AppCommon::data_update('cart', ['id' => $id], [
                    'count' => $count
                ]);
            }
        } else {
            $goods_id = !empty($this->param['goods_id']) ? intval($this->param['goods_id']) : 0;
            if (!empty($goods_id)) {
                if (!AppCommon::data_get('goods', ['id' => $goods_id])) {
                    data_return('商品不存在', -1);
                }

                $data = AppCommon::data_get('cart', ['uid' => $this->uid, 'goods_id' => $goods_id]);
            }
            if (!empty($data)) {
                AppCommon::data_update('cart', ['id' => $id], [
                    'count' => $count
                ]);
            } elseif (!empty($goods_id)) {
                AppCommon::data_add('cart', [
                    'uid' => $this->uid,
                    'goods_id' => $goods_id,
                    'count' => 1,
                    'status' => 1
                ]);
            }
        }
        data_return();
    }

    public function my_cart_select_status()
    {
        $type = !empty($this->param['dotype']) ? $this->param['dotype'] : '';
        $id = !empty($this->param['id']) ? intval($this->param['id']) : 0;
        $where = ['uid' => $this->uid];
        if (!empty($id)) {
            $where['id'] = $id;
        }
        if ($type == '1') {
            AppCommon::data_update('cart', $where, ['status' => 1]);
        } else {
            AppCommon::data_update('cart', $where, ['status' => 0]);
        }

        data_return();
    }

    //商品评价
    public function get_comment()
    {
        if (empty($this->param['id'])){
            data_return('参数有误',-1);
        }
        $page = !empty($this->param['page']) ? intval($this->param['page']) : 1;
        $data = AppCommon::data_list('goods_comment',['goods_id'=>intval($this->param['id']),'status'=>1],$page,'is_hide_user,content,imgs,status,add_time,uid,star','id desc');
        if ($data){
            foreach ($data as &$v){
                $v['add_time'] = date('Y-m-d',$v['add_time']);
                if (!empty($v['imgs'])){
                    $v['imgs'] = explode(',',$v['imgs']);
                }
                $v['user']['avatar'] = URL_WEB.'/static/com/img/user-default.jpg';
                if ($v['is_hide_user']==1){
                    $v['user']['nickname'] = '匿名用户';
                }else{
                    $v['user'] = AppCommon::data_get('common_user', ['uid' => $v['uid']], 'account,nickname');
                    if (empty($v['user']['nickname'])) {
                        $v['user']['nickname'] = '匿名用户';
                    }
                }

            }
            unset($v);
        }

        data_return('ok',0,['comment'=>$data]);
    }

    //评价列表
    public function comment_list()
    {
        return $this->fetch()
;    }

    //我的购物车统计
    public function my_cart_total()
    {
        $prefix = config('database')['prefix'];
        $from = !empty($this->param['from']) ? trim($this->param['from']) : '';
        $where = " a.uid='" . $this->uid . "' ";
        if ($from == 'checked') {
            $where .= " and a.status=1 ";
        }

        $goods = AppCommon::query("
            select count(a.id) as total,sum(a.count*b.price) as totalMoney from " . $prefix . "cart as a 
            left join " . $prefix . "goods as b on a.goods_id = b.id
            
            where " . $where . " 
        
        ");
        if (empty($goods[0]['total'])) {
            $goods[0]['total'] = 0;
        }
        if (empty($goods[0]['totalMoney'])) {
            $goods[0]['totalMoney'] = '0.00';
        }

        data_return('ok', 0, $goods[0]);
    }

    //分类接口
    public function get_classify()
    {
        $data = AppCommon::data_list('goods_category', ['status' => 1]);

        data_return('ok', 0, [
            'category' => $data ? tree($data, 'category_id', 'parent_id', 'subcat') : null
        ]);
    }

    public function pro_list()
    {
        return $this->fetch();
    }

    public function detail()
    {
        return $this->fetch();
    }

    //我的收藏
    public function my_favorite()
    {
        return $this->fetch();
    }

    //分类页面
    public function classify()
    {
        return $this->fetch();
    }

    //购物车页面
    public function cart()
    {
        return $this->fetch();
    }
}