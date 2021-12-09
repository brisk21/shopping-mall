<?php


namespace app\admin\controller\system;


use app\admin\controller\com\Admin;
use app\common\controller\AppCommon;
use app\service\ConfigService;
use app\service\Mailer;

/**
 * 根据key区分不同的设置，谨慎操作
 * Class Index
 * @package app\admin\controller\system
 */
class Index extends Admin
{
    //邮箱配置
    public function email()
    {
        $conf = ConfigService::get('email');
        if (!empty($conf)) {
            $this->assign('data', $conf);
        }
        return $this->fetch();
    }

    //邮箱配置更新
    public function email_action()
    {
        $rule = [
            ['type' => 'length', 'key' => 'host', 'rule' => '2,80', 'msg' => '发送域名未设置',],
            ['type' => 'empty', 'key' => 'username', 'rule' => '', 'msg' => '发送账号未设置',],
            ['type' => 'empty', 'key' => 'pwd', 'rule' => '', 'msg' => '发送授权密码未设置',],
            ['type' => 'empty', 'key' => 'port', 'rule' => '', 'msg' => '端口号未设置',],
            ['type' => 'empty', 'key' => 'encryption', 'rule' => '', 'msg' => '加密方式未选择',],
        ];
        $check = check_param($this->param, $rule);
        if ($check['code'] <> 0) {
            data_return($check['msg'], $check['code']);
        }
        $data = [
            'host' => trim($this->param['host']),
            'username' => trim($this->param['username']),
            'nickname' => trim($this->param['nickname']),
            'pwd' => trim($this->param['pwd']),
            'port' => trim($this->param['port']),
            'isHtml' => intval($this->param['isHtml']),
            'encryption' => trim($this->param['encryption']),
        ];
        $key = 'email';
        ConfigService::action($key, $data);
        parent::add_admin_log(['title' => '操作邮件配置', 'content' => $data]);
        data_return('保存成功');
    }

    //测试发送
    public function email_test()
    {
        if (empty($this->param['email']) || !is_email($this->param['email'])) {
            data_return('请输入测试邮箱', -1);
        }

        $data = [
            'to' => trim($this->param['email']),
            'title' => '世上无难事只怕有心人',
            'content' => '有没有收到数据，发送时间：' . date('Y-m-d H:i:s')
        ];
        $res = Mailer::send($data);
        if ($res['code'] == 0) {
            data_return($res['msg'], 0);
        }
        data_return($res['msg'], -1);
    }

    //网站
    public function web()
    {
        $conf = ConfigService::get('web');
        if (!empty($conf)) {
            $this->assign('data', $conf);
        }
        return $this->fetch();
    }

    //网站配置更新
    public function web_action()
    {
        $rule = [
            ['type' => 'length', 'key' => 'title', 'rule' => '2,80', 'msg' => '后台标题未设置',],
            ['type' => 'empty', 'key' => 'enable_reg', 'rule' => '', 'msg' => '是否支持注册后台',],
            ['type' => 'empty', 'key' => 'sms_type', 'rule' => '', 'msg' => '请选择发送短信的厂商',],
        ];
        $check = check_param($this->param, $rule);
        if ($check['code'] <> 0) {
            data_return($check['msg'], $check['code']);
        }
        $data = [
            'enable_reg' => intval($this->param['enable_reg']),
            'title' => trim($this->param['title']),
            'sms_type' => trim($this->param['sms_type']),
        ];
        $key = 'web';
        ConfigService::action($key, $data);

        parent::add_admin_log(['title' => '操作网站配置', 'content' => $data]);
        data_return('保存成功');
    }

    //支付
    public function pay()
    {
        $conf = ConfigService::get('wxpay');
        if (!empty($conf)) {
            $this->assign('data', $conf);
        }
        return $this->fetch();
    }

    //支付配置更新
    public function pay_action()
    {
        $rule = [
            ['type' => 'empty', 'key' => 'app_id', 'rule' => '2,80', 'msg' => '公众号APPID未设置',],
            ['type' => 'empty', 'key' => 'mch_id', 'rule' => '2,80', 'msg' => '支付商户id未设置',],
            ['type' => 'empty', 'key' => 'mch_key', 'rule' => '2,80', 'msg' => '支付商户秘钥未设置',],
        ];
        $check = check_param($this->param, $rule);
        if ($check['code'] <> 0) {
            data_return($check['msg'], $check['code']);
        }
        $data = [
            'app_id' => trim($this->param['app_id']),
            'mch_id' => trim($this->param['mch_id']),
            'mch_key' => trim($this->param['mch_key']),
            'cert_pem' => !empty($this->param['cert_pem']) ? $this->param['cert_pem'] : '',
            'key_pem' => !empty($this->param['cert_pem']) ? $this->param['key_pem'] : '',
        ];
        $key = 'wxpay';
        ConfigService::action($key, $data);
        parent::add_admin_log(['title' => '操作微信支付配置', 'content' => $data]);
        data_return('保存成功');
    }

    //短信
    public function sms()
    {
        $conf = ConfigService::get('sms');
        if (!empty($conf)) {
            $this->assign('data', $conf);
        }
        return $this->fetch();
    }

    //短信操作
    public function sms_action()
    {
        if (empty($this->param['from'])) {
            data_return('操作厂商有误', -1);
        }
        $key = 'sms';
        $conf = ConfigService::get($key,true);
        $from = trim($this->param['from']);
        if ($from == 'yunpian') {
            $rule = [
                ['type' => 'empty', 'key' => 'sms_tpl', 'rule' => '2,80', 'msg' => '通用验证码模板未填写内容',],
                ['type' => 'empty', 'key' => 'api_key', 'rule' => '2,80', 'msg' => '云片后台的apikey未设置',],
            ];
            $check = check_param($this->param, $rule);
            if ($check['code'] <> 0) {
                data_return($check['msg'], $check['code']);
            }
            $conf['yunpian'] = [
                'sms_tpl' => trim($this->param['sms_tpl']),
                'api_key' => trim($this->param['api_key'])
            ];
            ConfigService::action($key, $conf);
            parent::add_admin_log(['title' => '操作云片短信配置', 'content' => $this->param]);
            data_return('云片操作-保存成功');
        } elseif ($from == 'aliyun') {
            $rule = [
                ['type' => 'empty', 'key' => 'accessKeyId', 'rule' => '2,80', 'msg' => 'accessKeyId未填写内容',],
                ['type' => 'empty', 'key' => 'accessKeySecret', 'rule' => '2,80', 'msg' => 'accessKeySecret未填写内容',],
                ['type' => 'empty', 'key' => 'sms_id', 'rule' => '2,80', 'msg' => '模板ID未设置',],
                ['type' => 'empty', 'key' => 'sms_sign', 'rule' => '2,80', 'msg' => '短信签名没填写',],
            ];
            $check = check_param($this->param, $rule);
            if ($check['code'] <> 0) {
                data_return($check['msg'], $check['code']);
            }
            $conf['aliyun'] = [
                'accessKeyId' => trim($this->param['accessKeyId']),
                'accessKeySecret' => trim($this->param['accessKeySecret']),
                'sms_id' => trim($this->param['sms_id']),
                'sms_sign' => trim($this->param['sms_sign']),
            ];
            ConfigService::action($key, $conf);
            parent::add_admin_log(['title' => '操作阿里云短信配置', 'content' => $this->param]);
            data_return('阿里云操作-保存成功');
        } else {
            //todo 兼容其他类型
            data_return('暂不支持的商户类型', -1);
        }

    }
}