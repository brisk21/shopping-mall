<?php


namespace app\service;


use app\common\controller\AppCommon;

class Uploader
{
    /**
     * 执行上传
     * @param $fileKey :上传的文件的key
     * @param $toPath :保存的路径，如/var/www/upload/
     * @param $returnUrl :返回的链接资源地址,如http://abc.com/upload/
     * @param string $fileName 文件的名称
     * @return array
     */
    public static function start_upload($fileKey, $toPath = '', $returnUrl = '', $fileName = '')
    {
        $conf = config('upload');
        if (empty($conf['method'])) {
            return ['code' => -1, 'msg' => '未配置上传'];
        }
        if ($conf['method'] == 'local') {
            if (empty($toPath)) {
                $toPath = $conf['defaultPath'];
            }
            if (!isset($_FILES[$fileKey])) {
                return ['code' => -1, 'msg' => '文件未选择'];
            }
            $files = $_FILES[$fileKey];

            if (is_uploaded_file($files['tmp_name'])) {
                if ($files['error'] == 0 &&
                    $files['size'] > 0 &&
                    $files['size'] < $conf['fileSizeLimit']) {
                    $extArray = explode('.', $files['name']);
                    //获取扩展名后缀
                    $fileExt = $extArray[count($extArray) - 1];
                    if (!in_array(strtolower($fileExt), $conf['enable_type'])) {
                        return ['code' => -1, 'msg' => '上传的文件类型不支持'];
                    }
                    if (!$fileName) {
                        $fileName = md5(time() . rand(1, 9999999)) . '.' . $fileExt;
                    }
                    if ((!is_dir($toPath) && !@mkdir($toPath, 0777, true)) || !is_writable($toPath)) {
                        return ['code' => 500, 'msg' => '上传目录无权操作'];
                    }
                    if (is_file($toPath . $fileName) && !is_writeable($toPath . $fileName)) {
                        return ['code' => 500, 'msg' => '文件替换失败'];
                    }
                    if (move_uploaded_file($files['tmp_name'], $toPath . $fileName)) {
                        //成功,返回完整的图片地址
                        self::add_log([
                            'name' => $files['name'],
                            'size' => $files['size'],
                            'type' => $files['type'],
                            'upload_type' => 'local',
                            'path' => str_replace(PUBLIC_PATH,'',$toPath . $fileName),
                        ]);
                        return ['code' => 0, 'msg' => '上传成功', 'data' => $returnUrl . $fileName, 'location' => $returnUrl . $fileName];
                    }
                    return ['code' => 500, 'msg' => '移动到指定路径失败'];
                }
                return ['code' => -1, 'msg' => '文件过大'];
            }
            return ['code' => 500, 'msg' => '临时文件上传失败'];
        } else {
            return ['code' => 500, 'msg' => '未配置其他上传方式'];
        }

    }

    //添加上传记录
    public static function add_log($arg = [])
    {
        if (empty($arg['upload_type'])) {
            return false;
        }
        $data = [
            'name' => !empty($arg['name']) ? trim($arg['name']) : '未知',
            'size' => !empty($arg['size']) ? intval($arg['size']) : '0',
            'type' => !empty($arg['type']) ? trim($arg['type']) : '未知',
            'path' => !empty($arg['path']) ? trim($arg['path']) : '',
            'upload_type' => !empty($arg['upload_type']) ? trim($arg['upload_type']) : '',
            'add_time' => time()
        ];
        return AppCommon::data_add('upload_files_log', $data);
    }
}