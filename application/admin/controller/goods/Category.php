<?php


namespace app\admin\controller\goods;


use app\admin\controller\com\Admin;
use app\common\controller\AppCommon;

class Category extends Admin
{
    //分类管理
    public function index($getData = false)
    {
        $data = AppCommon::data_list_nopage('goods_category', [], '*', 'category_id desc');
        if ($data) {
            if ($getData) {
                return tree($data, 'category_id', 'parent_id', 'subcat');
            }
            $this->assign('data', tree($data, 'category_id', 'parent_id', 'subcat'));
        }
        return $this->fetch();
    }

    public function form()
    {
        if (!empty($this->param['id'])) {
            $this->assign('data', AppCommon::data_get('goods_category', ['category_id' => intval($this->param['id'])]));
        }
        $this->assign('category', $this->index(true));
        return $this->fetch();
    }

    public function action()
    {
        $id = !empty($this->param['id']) ? intval($this->param['id']) : 0;
        if (!empty($id)) {
            $data = AppCommon::data_get('goods_category', ['category_id' => $id]);
            if (empty($data)) {
                data_return('数据不存在', -1);
            }
            //仅删除
            if (!empty($this->param['ac']) && $this->param['ac'] == 'del') {
                $res = AppCommon::data_del('goods_category', ['category_id' => $data['category_id']]);

                $ids = [$data['category_id']];
                if ($res) {
                    $two = AppCommon::data_list_nopage('goods_category', ['parent_id' => $data['category_id']], 'category_id');
                    if (!empty($two)) {
                        $ids = array_merge($ids,array_column((array)$two, 'category_id'));
                        //移除二级
                        $ret = AppCommon::data_del('goods_category', ['parent_id' => $data['category_id']]);

                        if ($ret) {
                            //移除三级
                            AppCommon::data_del('goods_category', ['parent_id' => ['in', array_column((array)$two, 'category_id')]]);
                            //所有三级
                            $three = AppCommon::data_list_nopage('goods_category', ['parent_id' => ['in',array_column((array)$two, 'category_id')]], 'category_id');
                            $ids = array_merge($ids,array_column((array)$three, 'category_id'));
                        }
                    }
                }
                if (!empty($ids)){
                    AppCommon::data_update('goods',['category_id'=>['in',$ids]],['category_id'=>0]);
                }
                parent::add_admin_log(['title' => '删除商品分类', 'content' => $data]);
                data_return('删除成功');
            }
        }
        if (empty($this->param['title'])) {
            data_return('分类名称未设置', -1);
        }
        if (empty($this->param['img'])) {
            data_return('图片未上传', -1);
        }

        $baseData = [
            'name' => trim($this->param['title']),
            'img' => trim($this->param['img']),
            'parent_id' => intval($this->param['fid']),
            'status' => !empty($this->param['status']) ? 1 : 0,
        ];
        if (empty($data) && AppCommon::data_get('goods_category', ['parent_id' => $baseData['parent_id'], 'name' => $baseData['name']], 'category_id')) {
            data_return('分类已存在', -1);
        }
        if (!empty($data)) {
            AppCommon::data_update('goods_category', ['category_id' => $data['category_id']], $baseData);
        } else {
            AppCommon::data_add('goods_category', $baseData);
        }
        parent::add_admin_log(['title' => '增改商品分类', 'content' => $baseData]);
        data_return('操作成功');
    }
}