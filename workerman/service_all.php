#!/usr/bin/env php
<?php
define('APP_PATH', __DIR__ . '/../application/');
#绑定模块,这是一个总模块，在linux直接启动这个就好了，windows需要用另外的独立打开（用bat那个文件启动也行）
define('BIND_MODULE','push/Run');
# 加载框架引导文件
require __DIR__ . '/../thinkphp/start.php';