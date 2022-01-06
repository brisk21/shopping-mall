<?php


namespace app\mall\controller;


use app\mall\controller\com\Mall;
use app\service\Uploader;
use think\Request;

class Com extends Mall
{
    public function uploader()
    {

        $from = !empty($this->param['from']) ? $this->param['from'] : '';
        if (!$from) {
            data_return('非法上传', -1);
        } elseif (!in_array($this->param['from'], ['comment','feedback'])) {
            data_return('非法操作', -1);
        }
        $cacheKey = $from . md5(__FILE__ . __FUNCTION__);

        $ord_id = !empty($this->param['ord_id']) ? intval($this->param['ord_id']) : 0;
        if ($from == 'comment' && empty($ord_id)) {
            data_return('参数不合法', -1);

        } elseif ($from == 'comment' && cache($cacheKey) >= 3) {
            data_return('评价目前最多支持3只图片哦', -1);
        }elseif ($from == 'feedback' && cache($cacheKey) >= 3) {
            data_return('反馈目前最多支持3只图片哦', -1);
        }


        $toPath = config('upload')['defaultPath'] . 'mall/' . trim($this->param['from']) . '/';
        //拼接全连接
        $returnUrl = str_replace(PUBLIC_PATH, URL_WEB, $toPath);
        $this->param['fileKey'] = 'file';
        $res = Uploader::start_upload($this->param['fileKey'], $toPath, $returnUrl, '', 2);

        if ($res['code'] == 0) {
            if ($from == 'comment') {
                $count = cache($cacheKey);
                cache($cacheKey, $count ? $count++ : 1, 3600);
            }
        }

        data_return(
            $res['code'] == 0 ? '上传成功' : $res['msg'],
            $res['code'],
            [
                'url' => isset($res['data']) ? $res['data'] : '',
            ]
        );

    }
}