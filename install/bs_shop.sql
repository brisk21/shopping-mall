

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for bs_admin
-- ----------------------------
DROP TABLE IF EXISTS `bs_admin`;
CREATE TABLE `bs_admin`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '昵称',
  `account` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '登录账号',
  `pwd` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '密码',
  `salt` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '随机盐',
  `add_time` int(10) NULL DEFAULT 0,
  `up_time` int(10) UNSIGNED NULL DEFAULT 0,
  `user_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '简单描述',
  `role_id` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '角色编号',
  `uid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '唯一标识',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0-禁用，1-启用',
  `pwd_err_count` tinyint(1) NOT NULL DEFAULT 0 COMMENT '密码错误次数',
  `loginCount` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '登录次数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_admin
-- ----------------------------
INSERT INTO `bs_admin` VALUES (1, 'bsshop', 'bsshop', '55536755c2260ff81d7913d577e419ca', 'ACbUej3v4m', 1642216312, 1642216312, '超级', 0, 'bs57646d01bf5b6cd475756971e45e501c', 1, 0, 1);

-- ----------------------------
-- Table structure for bs_admin_action_log
-- ----------------------------
DROP TABLE IF EXISTS `bs_admin_action_log`;
CREATE TABLE `bs_admin_action_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `add_time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `uid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '管理员uid',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 510 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员操作日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_admin_action_log
-- ----------------------------

-- ----------------------------
-- Table structure for bs_admin_login_log
-- ----------------------------
DROP TABLE IF EXISTS `bs_admin_login_log`;
CREATE TABLE `bs_admin_login_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `add_time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 66 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_admin_login_log
-- ----------------------------

-- ----------------------------
-- Table structure for bs_admin_menu
-- ----------------------------
DROP TABLE IF EXISTS `bs_admin_menu`;
CREATE TABLE `bs_admin_menu`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '菜单名称',
  `fid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上级菜单',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '0-已禁用，1-启用中',
  `type` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1-菜单类型，0-功能类型（不在左侧显示）',
  `is_new` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1-显示“new”字样',
  `url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '菜单链接',
  `qx_str` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '权限标识',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'css样式class',
  `sort` int(10) NULL DEFAULT 0 COMMENT '越大越靠前',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 139 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '后台管理菜单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_admin_menu
-- ----------------------------
INSERT INTO `bs_admin_menu` VALUES (1, '商品管理', 0, 1, 1, 0, '/admin/goods.index/index', '@admin@goods@index@index', 'fa-shopping-basket', 999);
INSERT INTO `bs_admin_menu` VALUES (2, '管理员', 0, 1, 1, 0, '/admin/auth.auser/index', '@admin@auth@auser@index', 'fa-users', 0);
INSERT INTO `bs_admin_menu` VALUES (3, '新增商品', 1, 1, 1, 0, '/admin/goods.index/form', '@admin@goods@index@form', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (4, '商品操作', 7, 1, 0, 0, '/admin/goods.index/action', '@admin@goods@index@action', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (7, '商品列表', 1, 1, 1, 0, '/admin/goods.index/index', '@admin@goods@index@index', 'fa-cookie-bite', 90);
INSERT INTO `bs_admin_menu` VALUES (8, '商品分类', 1, 1, 1, 0, '/admin/goods.category/index', '@admin@goods@category@index', 'fa-object-ungroup', 80);
INSERT INTO `bs_admin_menu` VALUES (9, '权限菜单', 2, 1, 1, 0, '/admin/auth.index/menu', '@admin@auth@index@menu', 'fa-project-diagram', 0);
INSERT INTO `bs_admin_menu` VALUES (11, '操作菜单', 9, 1, 0, 0, '/admin/auth.index/action', '@admin@auth@index@action', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (12, '操作管理员', 23, 1, 1, 0, '/admin/auth.auser/action', '@admin@auth@auser@action', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (21, '分类操作', 8, 1, 0, 0, '/admin/goods.category/action', '@admin@goods@category@action', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (22, '分类操作表单', 8, 1, 1, 1, '/admin/goods.category/form', '@admin@goods@category@form', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (23, '管理员列表', 2, 1, 1, 0, '/admin/auth.auser/index', '@admin@auth@auser@index', 'fa-users', 0);
INSERT INTO `bs_admin_menu` VALUES (24, '角色管理', 2, 1, 1, 0, '/admin/auth.auser/role', '@admin@auth@auser@role', 'fa-user-tag', 0);
INSERT INTO `bs_admin_menu` VALUES (25, '角色操作', 24, 1, 0, 0, '/admin/auth.auther/role_action', '@admin@auth@auther@role_action', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (27, '操作表单', 23, 1, 0, 0, '/admin/auth.auser/form', '@admin@auth@auser@form', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (28, '权限管理', 24, 1, 0, 0, '/admin/auth.auser/role_set', '@admin@auth@auser@role_set', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (29, '权限操作', 24, 1, 0, 0, '/admin/auth.auser/role_auth_action', '@admin@auth@auser@role_auth_action', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (30, '操作表单', 9, 1, 0, 0, '/admin/auth.index/form', '@admin@auth@index@form', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (32, '订单管理', 0, 1, 1, 0, '/admin/order.index/index', '@admin@order@index@index', 'fa-database', 998);
INSERT INTO `bs_admin_menu` VALUES (33, '订单列表', 32, 1, 1, 0, '/admin/order.index/index', '@admin@order@index@index', 'fa-list-ul', 0);
INSERT INTO `bs_admin_menu` VALUES (36, '商城设置', 0, 1, 1, 0, '/admin/shop.nav/index', '@admin@shop@nav@index', 'fa-cart-plus', 0);
INSERT INTO `bs_admin_menu` VALUES (37, '轮播图管理', 36, 1, 1, 0, '/admin/shop.banner/index', '@admin@shop@banner@index', 'fa-images', 1);
INSERT INTO `bs_admin_menu` VALUES (38, '导航管理', 36, 1, 1, 0, '/admin/shop.nav/index', '@admin@shop@nav@index', 'fa-location-arrow', 1);
INSERT INTO `bs_admin_menu` VALUES (39, '公告管理', 36, 1, 1, 0, '/admin/shop.notice/index', '@admin@shop@notice@index', 'fa-volume-up', 1);
INSERT INTO `bs_admin_menu` VALUES (40, '基本配置', 36, 1, 1, 0, '/admin/shop.setting/index', '@admin@shop@setting@index', 'fa-tools', 1);
INSERT INTO `bs_admin_menu` VALUES (41, '会员管理', 0, 1, 1, 0, '/admin/user.index/index', '@admin@user@index@index', 'fa-users', 1);
INSERT INTO `bs_admin_menu` VALUES (42, '会员列表', 41, 1, 1, 0, '/admin/user.index/index', '@admin@user@index@index', 'fa-user-friends', 2);
INSERT INTO `bs_admin_menu` VALUES (44, '财务管理', 0, 1, 1, 0, '/admin/caiwu.index/credit', '@admin@caiwu@index@credit', 'fa-cog', 2);
INSERT INTO `bs_admin_menu` VALUES (46, '积分记录', 44, 1, 1, 0, '/admin/caiwu.index/point', '@admin@caiwu@index@point', 'fa-gift', 0);
INSERT INTO `bs_admin_menu` VALUES (47, '余额记录', 44, 1, 1, 0, '/admin/caiwu.index/credit', '@admin@caiwu@index@credit', 'fa-credit-card', 0);
INSERT INTO `bs_admin_menu` VALUES (48, '日志管理', 0, 1, 1, 0, '/admin/log.index/verifycode', '@admin@log@index@verifycode', 'fa-clipboard-list', 0);
INSERT INTO `bs_admin_menu` VALUES (49, '异常日志', 48, 1, 1, 0, '/admin/log.index/error_log', '@admin@log@index@error_log', 'fa-bug', 1);
INSERT INTO `bs_admin_menu` VALUES (50, '验证码日志', 48, 1, 1, 0, '/admin/log.index/verifycode', '@admin@log@index@verifycode', 'fa-comment-dots', 1);
INSERT INTO `bs_admin_menu` VALUES (52, '操作日志', 48, 1, 1, 0, '/admin/log.index/admin_log', '@admin@log@index@admin_log', 'fa-hammer', 0);
INSERT INTO `bs_admin_menu` VALUES (55, '系统设置', 0, 1, 1, 0, '/admin/system.index/web', '@admin@system@index@web', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (56, '邮件配置', 55, 1, 1, 0, '/admin/system.index/email', '@admin@system@index@email', 'fa-at', 0);
INSERT INTO `bs_admin_menu` VALUES (57, '支付配置', 55, 1, 1, 0, '/admin/system.index/pay', '@admin@system@index@pay', 'fa-comments-dollar', 0);
INSERT INTO `bs_admin_menu` VALUES (58, '网站设置', 55, 1, 1, 0, '/admin/system.index/web', '@admin@system@index@web', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (59, '设置备注', 42, 1, 0, 0, '/admin/user.index/action_remark', '@admin@user@index@action_remark', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (60, '设置状态', 42, 1, 0, 0, '/admin/user.index/action_status', '@admin@user@index@action_status', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (61, '公告表单', 39, 1, 0, 0, '/admin/shop.notice/form', '@admin@shop@notice@form', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (62, '公告操作', 39, 1, 0, 0, '/admin/shop.notice/notice_action', '@admin@shop@notice@notice_action', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (63, '设置状态', 39, 1, 0, 0, '/admin/shop.notice/action_status', '@admin@shop@notice@action_status', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (64, '操作配置', 58, 1, 0, 0, '/admin/system.index/web_action', '@admin@system@index@web_action', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (65, '操作配置', 57, 1, 0, 0, '/admin/system.index/pay_action', '@admin@system@index@pay_action', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (66, '操作配置', 56, 1, 0, 0, '/admin/system.index/email_action', '@admin@system@index@email_action', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (67, '短信配置', 55, 1, 1, 0, '/admin/system.index/sms', '@admin@system@index@sms', 'fa-sms', 0);
INSERT INTO `bs_admin_menu` VALUES (68, '操作配置', 67, 1, 0, 0, '/admin/system.index/sms_action', '@admin@system@index@sms_action', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (69, '导航操作', 38, 1, 0, 0, '/admin/shop.nav/nav_action', '@admin@shop@nav@nav_action', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (70, '设置状态', 38, 1, 0, 0, '/admin/shop.nav/action_status', '@admin@shop@nav@action_status', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (71, '操作表单', 38, 1, 0, 0, '/admin/shop.nav/form', '@admin@shop@nav@form', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (72, '操作表单', 37, 1, 0, 0, '/admin/shop.banner/form', '@admin@shop@banner@form', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (73, '轮播操作', 37, 1, 0, 0, '/admin/shop.banner/banner_action', '@admin@shop@banner@banner_action', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (74, '设置状态', 37, 1, 0, 0, '/admin/shop.banner/action_status', '@admin@shop@banner@action_status', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (75, '订单详情', 33, 1, 0, 0, '/admin/order.index/detail', '@admin@order@index@detail', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (76, '操作发货', 33, 1, 0, 0, '/admin/order.index/send', '@admin@order@index@send', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (77, '店铺设置', 36, 1, 1, 0, '/admin/shop.mall/index', '@admin@shop@mall@index', 'fa-store', 0);
INSERT INTO `bs_admin_menu` VALUES (78, '上传日志', 48, 1, 1, 0, '/admin/log.index/upload_log', '@admin@log@index@upload_log', 'fa-print', 0);
INSERT INTO `bs_admin_menu` VALUES (79, '删除日志', 78, 1, 0, 0, '/admin/log.index/upload_log_del', '@admin@log@index@upload_log_del', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (80, '删除日志', 49, 1, 0, 0, '/admin/log.index/error_log_del', '@admin@log@index@error_log_del', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (81, '操作配置', 40, 1, 0, 0, '/admin/shop.setting/config_action', '@admin@shop@setting@config_action', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (82, '操作设置', 77, 1, 0, 0, '/admin/shop.mall/mall_action', '@admin@shop@mall@mall_action', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (83, '操作表单', 42, 1, 0, 0, '/admin/user.index/form', '@admin@user@index@form', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (84, '操作用户', 42, 1, 0, 0, '/admin/user.index/edit_user', '@admin@user@index@edit_user', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (85, '用户充值', 42, 1, 0, 0, '/admin/user.index/action_recharge', '@admin@user@index@action_recharge', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (86, '其它功能', 0, 1, 0, 0, '/admin/index/index', '@admin@index@index', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (87, '上传图片', 86, 1, 0, 0, '/admin/upload/image', '@admin@upload@image', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (88, '后台首页', 86, 1, 0, 0, '/admin/index/index', '@admin@index@index', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (89, '权限操作', 24, 1, 0, 0, '/admin/auth.auser/role', '@admin@auth@auser@role', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (90, '退款操作', 33, 1, 0, 0, '/admin/order.index/refund', '@admin@order@index@refund', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (91, '定时任务', 55, 1, 1, 0, '/admin/system.tasks/index', '@admin@system@tasks@index', 'fa-flask', 6);
INSERT INTO `bs_admin_menu` VALUES (92, '操作任务', 91, 1, 0, 0, '/admin/system.tasks/tasks_action', '@admin@system@tasks@tasks_action', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (93, '操作表单', 91, 1, 0, 0, '/admin/system.tasks/form', '@admin@system@tasks@form', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (94, '评价管理', 1, 1, 1, 0, '/admin/goods.index/comment', '@admin@goods@index@comment', 'fa-comment-dots', 0);
INSERT INTO `bs_admin_menu` VALUES (95, '操作评价', 94, 1, 0, 0, '/admin/goods.index/comment', '@admin@goods@index@comment', 'fa-comment-dots', 0);
INSERT INTO `bs_admin_menu` VALUES (96, '后台首页2', 86, 1, 0, 0, '/admin/index/index_iframe', '@admin@index@index_iframe', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (97, '确认提货', 33, 1, 0, 0, '/admin/order.index/action_tihuo', '@admin@order@index@action_tihuo', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (98, '虚拟商品发货', 33, 1, 0, 0, '/admin/order.index/send_virtual', '@admin@order@index@send_virtual', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (99, '缓存配置', 55, 1, 1, 0, '/admin/system.index/cache_set', '@admin@system@index@cache_set', 'fa-stopwatch', -1);
INSERT INTO `bs_admin_menu` VALUES (100, '重置OPCACHE缓存', 99, 1, 0, 0, '/admin/system.index/del_cache_opcache', '@admin@system@index@del_cache_opcache', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (101, '重置数据缓存', 99, 1, 0, 0, '/admin/system.index/del_cache_data', '@admin@system@index@del_cache_data', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (102, '清理日志文件', 99, 1, 0, 0, '/admin/system.index/del_cache_log', '@admin@system@index@del_cache_log', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (103, '清理模板文件', 99, 1, 0, 0, '/admin/system.index/del_cache_tpl', '@admin@system@index@del_cache_tpl', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (104, 'IP黑名单', 55, 1, 1, 1, '/admin/system.index/ip_blacklist', '@admin@system@index@ip_blacklist', 'fa-user-lock', -1);
INSERT INTO `bs_admin_menu` VALUES (105, 'IP黑名单操作', 104, 1, 0, 0, '/admin/system.index/ip_blacklist_action', '@admin@system@index@ip_blacklist_action', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (106, '安全配置', 55, 1, 1, 1, '/admin/system.index/safe', '@admin@system@index@safe', 'fa-shield-alt', -1);
INSERT INTO `bs_admin_menu` VALUES (107, '配置操作', 106, 1, 0, 0, '/admin/system.index/safe_action', '@admin@system@index@safe_action', 'fa-shield-alt', 0);
INSERT INTO `bs_admin_menu` VALUES (108, '登录记录', 23, 1, 0, 0, '/admin/auth.auser/login_log', '@admin@auth@auser@login_log', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (109, '登录记录', 41, 1, 1, 0, '/admin/user.index/login_log', '@admin@user@index@login_log', 'fa-clipboard-list', 0);
INSERT INTO `bs_admin_menu` VALUES (110, 'iframe默认页面', 86, 1, 0, 0, '/admin/index/default_index', '@admin@index@default_index', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (111, '应用中心', 0, 1, 1, 1, '/admin/extend.index/index', '@admin@extend@index@index', 'fa-cubes', 0);
INSERT INTO `bs_admin_menu` VALUES (112, '应用列表', 111, 1, 1, 0, '/admin/extend.index/index', '@admin@extend@index@index', 'fa-cubes', 0);
INSERT INTO `bs_admin_menu` VALUES (113, '应用管理', 111, 1, 1, 0, '/admin/extend.index/manager', '@admin@extend@index@manager', 'fa-cubes', 0);
INSERT INTO `bs_admin_menu` VALUES (114, '上传应用', 113, 1, 0, 0, '/admin/extend.index/upload_app', '@admin@extend@index@upload_app', 'fa-cubes', 0);
INSERT INTO `bs_admin_menu` VALUES (115, '编辑应用信息', 113, 1, 0, 0, '/admin/extend.index/edit_app', '@admin@extend@index@edit_app', 'fa-cubes', 0);
INSERT INTO `bs_admin_menu` VALUES (116, '启用禁用操作', 113, 1, 0, 0, '/admin/extend.index/set_status', '@admin@extend@index@set_status', 'fa-cubes', 0);
INSERT INTO `bs_admin_menu` VALUES (118, '系统文章', 55, 1, 1, 0, '/admin/system.article/index', '@admin@system@article@index', 'fa-newspaper', -2);
INSERT INTO `bs_admin_menu` VALUES (119, '文章操作', 118, 1, 0, 0, '/admin/system.article/action', '@admin@system@article@action', 'fa-newspaper', 0);
INSERT INTO `bs_admin_menu` VALUES (120, '快捷改状态', 118, 1, 0, 0, '/admin/system.article/action_status', '@admin@system@article@action_status', 'fa-newspaper', 0);
INSERT INTO `bs_admin_menu` VALUES (121, '操作表单', 118, 1, 0, 0, '/admin/system.article/form', '@admin@system@article@form', 'fa-newspaper', 0);
INSERT INTO `bs_admin_menu` VALUES (122, '其他相关', 0, 1, 1, 0, '/admin/other.index/feedback', '@admin@other@index@feedback', 'fa-network-wired', -1);
INSERT INTO `bs_admin_menu` VALUES (123, '留言反馈', 122, 1, 1, 0, '/admin/other.index/feedback', '@admin@other@index@feedback', 'fa-comment-medical', 0);
INSERT INTO `bs_admin_menu` VALUES (124, '操作反馈', 123, 1, 0, 0, '/admin/other.index/feedback_action', '@admin@other@index@feedback_action', 'fa-comment-medical', 0);
INSERT INTO `bs_admin_menu` VALUES (125, '上传配置', 55, 1, 0, 0, '/admin/system.index/upload', '@admin@system@index@upload', 'fa-upload', 0);
INSERT INTO `bs_admin_menu` VALUES (126, '操作配置', 125, 1, 0, 0, '/admin/system.index/upload_action', '@admin@system@index@upload_action', 'fa-upload', 0);
INSERT INTO `bs_admin_menu` VALUES (127, '更新应用', 113, 1, 0, 0, '/admin/extend.index/update_app', '@admin@extend@index@update_app', 'fa-cubes', 0);
INSERT INTO `bs_admin_menu` VALUES (128, '更新应用设置', 113, 1, 0, 0, '/admin/extend.index/update_plugin_setting', '@admin@extend@index@update_plugin_setting', 'fa-cubes', 0);
INSERT INTO `bs_admin_menu` VALUES (129, '修改信息表单', 113, 1, 0, 0, '/admin/extend.index/form', '@admin@extend@index@form', 'fa-cubes', 0);
INSERT INTO `bs_admin_menu` VALUES (130, '应用设置表单', 113, 1, 0, 0, '/admin/extend.index/setting', '@admin@extend@index@setting', 'fa-cubes', 0);
INSERT INTO `bs_admin_menu` VALUES (131, '打包下载', 113, 1, 0, 0, '/admin/extend.index/pack', '@admin@extend@index@pack', 'fa-cubes', 0);
INSERT INTO `bs_admin_menu` VALUES (132, '卸载应用', 113, 1, 0, 0, '/admin/extend.index/remove', '@admin@extend@index@remove', 'fa-cubes', 0);
INSERT INTO `bs_admin_menu` VALUES (133, '创建应用操作', 113, 1, 0, 0, '/admin/extend.index/create_app', '@admin@extend@index@create_app', 'fa-cubes', 0);
INSERT INTO `bs_admin_menu` VALUES (134, '配置页面', 113, 1, 0, 0, '/admin/extend.index/setting', '@admin@extend@index@setting', 'fa-cubes', 0);
INSERT INTO `bs_admin_menu` VALUES (135, '配置更新操作', 113, 1, 0, 0, '/admin/extend.index/setting_update', '@admin@extend@index@setting_update', 'fa-cubes', 0);
INSERT INTO `bs_admin_menu` VALUES (136, '消息中心', 0, 1, 0, 0, '/admin/order.index/msg', '@admin@order@index@msg', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (137, '操作消息', 136, 1, 0, 0, '/admin/order.index/msg_action', '@admin@order@index@msg_action', 'fa-cog', 0);
INSERT INTO `bs_admin_menu` VALUES (138, '消息统计', 136, 1, 0, 0, '/admin/order.index/msg_count', '@admin@order@index@msg_count', 'fa-cog', 0);
INSERT INTO `bs_admin_menu`(`id`, `name`, `fid`, `status`, `type`, `is_new`, `url`, `qx_str`, `class_name`, `sort`) VALUES (139, '物流相关', 55, 1, 1, 0, '/admin/system.index/express', '@admin@system@index@express', 'fa-shipping-fast', -1);
INSERT INTO `bs_admin_menu`(`id`, `name`, `fid`, `status`, `type`, `is_new`, `url`, `qx_str`, `class_name`, `sort`) VALUES (140, '操作物流配置', 139, 1, 0, 0, '/admin/system.index/express_action', '@admin@system@index@express_action', 'fa-shipping-fast', 0);
INSERT INTO `bs_admin_menu`(`id`, `name`, `fid`, `status`, `type`, `is_new`, `url`, `qx_str`, `class_name`, `sort`) VALUES (141, '微信配置', 55, 1, 1, 0, '/admin/system.index/wechat', '@admin@system@index@wechat', 'fa-comment-dots', 0);
INSERT INTO `bs_admin_menu`(`id`, `name`, `fid`, `status`, `type`, `is_new`, `url`, `qx_str`, `class_name`, `sort`) VALUES (142, '微信配置操作', 141, 1, 0, 0, '/admin/system.index/wechat_action', '@admin@system@index@wechat_action', 'fa-weixin', 0);

-- ----------------------------
-- Table structure for bs_admin_msg
-- ----------------------------
DROP TABLE IF EXISTS `bs_admin_msg`;
CREATE TABLE `bs_admin_msg`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `add_time` int(10) NULL DEFAULT 0,
  `msg_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '自定义消息类型，order-订单类型，feedback-留言反馈，kefu-客服消息',
  `read_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '阅读时间',
  `is_favorite` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否已收藏',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '后台管理的消息' ROW_FORMAT = Dynamic;


-- ----------------------------
-- Table structure for bs_admin_role
-- ----------------------------
DROP TABLE IF EXISTS `bs_admin_role`;
CREATE TABLE `bs_admin_role`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '角色编号',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '角色名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_admin_role
-- ----------------------------
INSERT INTO `bs_admin_role` VALUES (3, '财务管理');
INSERT INTO `bs_admin_role` VALUES (4, '商品管理');
INSERT INTO `bs_admin_role` VALUES (5, '基本体验');
INSERT INTO `bs_admin_role` VALUES (6, '超级体验（内部）');

-- ----------------------------
-- Table structure for bs_admin_role_auth
-- ----------------------------
DROP TABLE IF EXISTS `bs_admin_role_auth`;
CREATE TABLE `bs_admin_role_auth`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_id` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '角色编号',
  `menu_id` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '菜单编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1492 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_admin_role_auth
-- ----------------------------
INSERT INTO `bs_admin_role_auth` VALUES (80, 4, 1);
INSERT INTO `bs_admin_role_auth` VALUES (81, 4, 8);
INSERT INTO `bs_admin_role_auth` VALUES (82, 4, 22);
INSERT INTO `bs_admin_role_auth` VALUES (83, 4, 21);
INSERT INTO `bs_admin_role_auth` VALUES (84, 4, 7);
INSERT INTO `bs_admin_role_auth` VALUES (85, 4, 4);
INSERT INTO `bs_admin_role_auth` VALUES (86, 4, 3);
INSERT INTO `bs_admin_role_auth` VALUES (87, 3, 44);
INSERT INTO `bs_admin_role_auth` VALUES (88, 3, 47);
INSERT INTO `bs_admin_role_auth` VALUES (89, 3, 46);
INSERT INTO `bs_admin_role_auth` VALUES (1320, 6, 136);
INSERT INTO `bs_admin_role_auth` VALUES (1321, 6, 138);
INSERT INTO `bs_admin_role_auth` VALUES (1322, 6, 137);
INSERT INTO `bs_admin_role_auth` VALUES (1323, 6, 122);
INSERT INTO `bs_admin_role_auth` VALUES (1324, 6, 123);
INSERT INTO `bs_admin_role_auth` VALUES (1325, 6, 124);
INSERT INTO `bs_admin_role_auth` VALUES (1326, 6, 111);
INSERT INTO `bs_admin_role_auth` VALUES (1327, 6, 113);
INSERT INTO `bs_admin_role_auth` VALUES (1328, 6, 135);
INSERT INTO `bs_admin_role_auth` VALUES (1329, 6, 134);
INSERT INTO `bs_admin_role_auth` VALUES (1330, 6, 133);
INSERT INTO `bs_admin_role_auth` VALUES (1331, 6, 132);
INSERT INTO `bs_admin_role_auth` VALUES (1332, 6, 131);
INSERT INTO `bs_admin_role_auth` VALUES (1333, 6, 130);
INSERT INTO `bs_admin_role_auth` VALUES (1334, 6, 129);
INSERT INTO `bs_admin_role_auth` VALUES (1335, 6, 128);
INSERT INTO `bs_admin_role_auth` VALUES (1336, 6, 127);
INSERT INTO `bs_admin_role_auth` VALUES (1337, 6, 116);
INSERT INTO `bs_admin_role_auth` VALUES (1338, 6, 115);
INSERT INTO `bs_admin_role_auth` VALUES (1339, 6, 114);
INSERT INTO `bs_admin_role_auth` VALUES (1340, 6, 112);
INSERT INTO `bs_admin_role_auth` VALUES (1341, 6, 86);
INSERT INTO `bs_admin_role_auth` VALUES (1342, 6, 110);
INSERT INTO `bs_admin_role_auth` VALUES (1343, 6, 96);
INSERT INTO `bs_admin_role_auth` VALUES (1344, 6, 88);
INSERT INTO `bs_admin_role_auth` VALUES (1345, 6, 87);
INSERT INTO `bs_admin_role_auth` VALUES (1346, 6, 55);
INSERT INTO `bs_admin_role_auth` VALUES (1347, 6, 125);
INSERT INTO `bs_admin_role_auth` VALUES (1348, 6, 126);
INSERT INTO `bs_admin_role_auth` VALUES (1349, 6, 118);
INSERT INTO `bs_admin_role_auth` VALUES (1350, 6, 121);
INSERT INTO `bs_admin_role_auth` VALUES (1351, 6, 120);
INSERT INTO `bs_admin_role_auth` VALUES (1352, 6, 119);
INSERT INTO `bs_admin_role_auth` VALUES (1353, 6, 106);
INSERT INTO `bs_admin_role_auth` VALUES (1354, 6, 107);
INSERT INTO `bs_admin_role_auth` VALUES (1355, 6, 104);
INSERT INTO `bs_admin_role_auth` VALUES (1356, 6, 105);
INSERT INTO `bs_admin_role_auth` VALUES (1357, 6, 99);
INSERT INTO `bs_admin_role_auth` VALUES (1358, 6, 103);
INSERT INTO `bs_admin_role_auth` VALUES (1359, 6, 102);
INSERT INTO `bs_admin_role_auth` VALUES (1360, 6, 101);
INSERT INTO `bs_admin_role_auth` VALUES (1361, 6, 100);
INSERT INTO `bs_admin_role_auth` VALUES (1362, 6, 91);
INSERT INTO `bs_admin_role_auth` VALUES (1363, 6, 93);
INSERT INTO `bs_admin_role_auth` VALUES (1364, 6, 92);
INSERT INTO `bs_admin_role_auth` VALUES (1365, 6, 67);
INSERT INTO `bs_admin_role_auth` VALUES (1366, 6, 68);
INSERT INTO `bs_admin_role_auth` VALUES (1367, 6, 58);
INSERT INTO `bs_admin_role_auth` VALUES (1368, 6, 64);
INSERT INTO `bs_admin_role_auth` VALUES (1369, 6, 57);
INSERT INTO `bs_admin_role_auth` VALUES (1370, 6, 65);
INSERT INTO `bs_admin_role_auth` VALUES (1371, 6, 56);
INSERT INTO `bs_admin_role_auth` VALUES (1372, 6, 66);
INSERT INTO `bs_admin_role_auth` VALUES (1373, 6, 48);
INSERT INTO `bs_admin_role_auth` VALUES (1374, 6, 78);
INSERT INTO `bs_admin_role_auth` VALUES (1375, 6, 79);
INSERT INTO `bs_admin_role_auth` VALUES (1376, 6, 52);
INSERT INTO `bs_admin_role_auth` VALUES (1377, 6, 50);
INSERT INTO `bs_admin_role_auth` VALUES (1378, 6, 49);
INSERT INTO `bs_admin_role_auth` VALUES (1379, 6, 80);
INSERT INTO `bs_admin_role_auth` VALUES (1380, 6, 44);
INSERT INTO `bs_admin_role_auth` VALUES (1381, 6, 47);
INSERT INTO `bs_admin_role_auth` VALUES (1382, 6, 46);
INSERT INTO `bs_admin_role_auth` VALUES (1383, 6, 41);
INSERT INTO `bs_admin_role_auth` VALUES (1384, 6, 109);
INSERT INTO `bs_admin_role_auth` VALUES (1385, 6, 42);
INSERT INTO `bs_admin_role_auth` VALUES (1386, 6, 85);
INSERT INTO `bs_admin_role_auth` VALUES (1387, 6, 84);
INSERT INTO `bs_admin_role_auth` VALUES (1388, 6, 83);
INSERT INTO `bs_admin_role_auth` VALUES (1389, 6, 60);
INSERT INTO `bs_admin_role_auth` VALUES (1390, 6, 59);
INSERT INTO `bs_admin_role_auth` VALUES (1391, 6, 36);
INSERT INTO `bs_admin_role_auth` VALUES (1392, 6, 77);
INSERT INTO `bs_admin_role_auth` VALUES (1393, 6, 82);
INSERT INTO `bs_admin_role_auth` VALUES (1394, 6, 40);
INSERT INTO `bs_admin_role_auth` VALUES (1395, 6, 81);
INSERT INTO `bs_admin_role_auth` VALUES (1396, 6, 39);
INSERT INTO `bs_admin_role_auth` VALUES (1397, 6, 63);
INSERT INTO `bs_admin_role_auth` VALUES (1398, 6, 62);
INSERT INTO `bs_admin_role_auth` VALUES (1399, 6, 61);
INSERT INTO `bs_admin_role_auth` VALUES (1400, 6, 38);
INSERT INTO `bs_admin_role_auth` VALUES (1401, 6, 71);
INSERT INTO `bs_admin_role_auth` VALUES (1402, 6, 70);
INSERT INTO `bs_admin_role_auth` VALUES (1403, 6, 69);
INSERT INTO `bs_admin_role_auth` VALUES (1404, 6, 37);
INSERT INTO `bs_admin_role_auth` VALUES (1405, 6, 74);
INSERT INTO `bs_admin_role_auth` VALUES (1406, 6, 73);
INSERT INTO `bs_admin_role_auth` VALUES (1407, 6, 72);
INSERT INTO `bs_admin_role_auth` VALUES (1408, 6, 32);
INSERT INTO `bs_admin_role_auth` VALUES (1409, 6, 33);
INSERT INTO `bs_admin_role_auth` VALUES (1410, 6, 98);
INSERT INTO `bs_admin_role_auth` VALUES (1411, 6, 97);
INSERT INTO `bs_admin_role_auth` VALUES (1412, 6, 90);
INSERT INTO `bs_admin_role_auth` VALUES (1413, 6, 76);
INSERT INTO `bs_admin_role_auth` VALUES (1414, 6, 75);
INSERT INTO `bs_admin_role_auth` VALUES (1415, 6, 2);
INSERT INTO `bs_admin_role_auth` VALUES (1416, 6, 24);
INSERT INTO `bs_admin_role_auth` VALUES (1417, 6, 89);
INSERT INTO `bs_admin_role_auth` VALUES (1418, 6, 29);
INSERT INTO `bs_admin_role_auth` VALUES (1419, 6, 28);
INSERT INTO `bs_admin_role_auth` VALUES (1420, 6, 25);
INSERT INTO `bs_admin_role_auth` VALUES (1421, 6, 23);
INSERT INTO `bs_admin_role_auth` VALUES (1422, 6, 108);
INSERT INTO `bs_admin_role_auth` VALUES (1423, 6, 27);
INSERT INTO `bs_admin_role_auth` VALUES (1424, 6, 12);
INSERT INTO `bs_admin_role_auth` VALUES (1425, 6, 9);
INSERT INTO `bs_admin_role_auth` VALUES (1426, 6, 30);
INSERT INTO `bs_admin_role_auth` VALUES (1427, 6, 11);
INSERT INTO `bs_admin_role_auth` VALUES (1428, 6, 1);
INSERT INTO `bs_admin_role_auth` VALUES (1429, 6, 94);
INSERT INTO `bs_admin_role_auth` VALUES (1430, 6, 95);
INSERT INTO `bs_admin_role_auth` VALUES (1431, 6, 8);
INSERT INTO `bs_admin_role_auth` VALUES (1432, 6, 22);
INSERT INTO `bs_admin_role_auth` VALUES (1433, 6, 21);
INSERT INTO `bs_admin_role_auth` VALUES (1434, 6, 7);
INSERT INTO `bs_admin_role_auth` VALUES (1435, 6, 4);
INSERT INTO `bs_admin_role_auth` VALUES (1436, 6, 3);
INSERT INTO `bs_admin_role_auth` VALUES (1437, 5, 136);
INSERT INTO `bs_admin_role_auth` VALUES (1438, 5, 138);
INSERT INTO `bs_admin_role_auth` VALUES (1439, 5, 122);
INSERT INTO `bs_admin_role_auth` VALUES (1440, 5, 123);
INSERT INTO `bs_admin_role_auth` VALUES (1441, 5, 111);
INSERT INTO `bs_admin_role_auth` VALUES (1442, 5, 113);
INSERT INTO `bs_admin_role_auth` VALUES (1443, 5, 134);
INSERT INTO `bs_admin_role_auth` VALUES (1444, 5, 112);
INSERT INTO `bs_admin_role_auth` VALUES (1445, 5, 86);
INSERT INTO `bs_admin_role_auth` VALUES (1446, 5, 110);
INSERT INTO `bs_admin_role_auth` VALUES (1447, 5, 96);
INSERT INTO `bs_admin_role_auth` VALUES (1448, 5, 88);
INSERT INTO `bs_admin_role_auth` VALUES (1449, 5, 55);
INSERT INTO `bs_admin_role_auth` VALUES (1450, 5, 118);
INSERT INTO `bs_admin_role_auth` VALUES (1451, 5, 121);
INSERT INTO `bs_admin_role_auth` VALUES (1452, 5, 106);
INSERT INTO `bs_admin_role_auth` VALUES (1453, 5, 104);
INSERT INTO `bs_admin_role_auth` VALUES (1454, 5, 99);
INSERT INTO `bs_admin_role_auth` VALUES (1455, 5, 91);
INSERT INTO `bs_admin_role_auth` VALUES (1456, 5, 67);
INSERT INTO `bs_admin_role_auth` VALUES (1457, 5, 58);
INSERT INTO `bs_admin_role_auth` VALUES (1458, 5, 78);
INSERT INTO `bs_admin_role_auth` VALUES (1459, 5, 50);
INSERT INTO `bs_admin_role_auth` VALUES (1460, 5, 44);
INSERT INTO `bs_admin_role_auth` VALUES (1461, 5, 47);
INSERT INTO `bs_admin_role_auth` VALUES (1462, 5, 46);
INSERT INTO `bs_admin_role_auth` VALUES (1463, 5, 41);
INSERT INTO `bs_admin_role_auth` VALUES (1464, 5, 42);
INSERT INTO `bs_admin_role_auth` VALUES (1465, 5, 83);
INSERT INTO `bs_admin_role_auth` VALUES (1466, 5, 77);
INSERT INTO `bs_admin_role_auth` VALUES (1467, 5, 40);
INSERT INTO `bs_admin_role_auth` VALUES (1468, 5, 39);
INSERT INTO `bs_admin_role_auth` VALUES (1469, 5, 63);
INSERT INTO `bs_admin_role_auth` VALUES (1470, 5, 61);
INSERT INTO `bs_admin_role_auth` VALUES (1471, 5, 38);
INSERT INTO `bs_admin_role_auth` VALUES (1472, 5, 71);
INSERT INTO `bs_admin_role_auth` VALUES (1473, 5, 37);
INSERT INTO `bs_admin_role_auth` VALUES (1474, 5, 72);
INSERT INTO `bs_admin_role_auth` VALUES (1475, 5, 32);
INSERT INTO `bs_admin_role_auth` VALUES (1476, 5, 33);
INSERT INTO `bs_admin_role_auth` VALUES (1477, 5, 75);
INSERT INTO `bs_admin_role_auth` VALUES (1478, 5, 2);
INSERT INTO `bs_admin_role_auth` VALUES (1479, 5, 24);
INSERT INTO `bs_admin_role_auth` VALUES (1480, 5, 29);
INSERT INTO `bs_admin_role_auth` VALUES (1481, 5, 23);
INSERT INTO `bs_admin_role_auth` VALUES (1482, 5, 27);
INSERT INTO `bs_admin_role_auth` VALUES (1483, 5, 9);
INSERT INTO `bs_admin_role_auth` VALUES (1484, 5, 30);
INSERT INTO `bs_admin_role_auth` VALUES (1485, 5, 1);
INSERT INTO `bs_admin_role_auth` VALUES (1486, 5, 94);
INSERT INTO `bs_admin_role_auth` VALUES (1487, 5, 8);
INSERT INTO `bs_admin_role_auth` VALUES (1488, 5, 22);
INSERT INTO `bs_admin_role_auth` VALUES (1489, 5, 7);
INSERT INTO `bs_admin_role_auth` VALUES (1490, 5, 4);
INSERT INTO `bs_admin_role_auth` VALUES (1491, 5, 3);

-- ----------------------------
-- Table structure for bs_article
-- ----------------------------
DROP TABLE IF EXISTS `bs_article`;
CREATE TABLE `bs_article`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文章标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '文章内容',
  `add_time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `up_time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1-展示中，0-已下线',
  `count_view` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '浏览量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_article
-- ----------------------------
INSERT INTO `bs_article` VALUES (4, '欢迎体验bs_shop购物商城', '&lt;p&gt;&lt;b&gt;需要定制联系微信：wei1-top&lt;/b&gt;&lt;/p&gt;', 1639145389, 1639145406, 1, 2);
INSERT INTO `bs_article` VALUES (5, '新增游客登录，登录赠送100体验余额', '&lt;p&gt;如题，大抵就是这样，欢迎测试。&lt;/p&gt;', 1640849011, 1640849011, 1, 0);

-- ----------------------------
-- Table structure for bs_article_sys
-- ----------------------------
DROP TABLE IF EXISTS `bs_article_sys`;
CREATE TABLE `bs_article_sys`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文章标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '文章内容',
  `add_time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `up_time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1-展示中，0-已下线',
  `count_view` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '浏览量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统文章内容' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_article_sys
-- ----------------------------
INSERT INTO `bs_article_sys` VALUES (1, '注册协议', '&lt;p&gt;BS商城用户注册协议本协议是您与BS商城网站（简称;本站;）所有者（以下简称为:BS商城）之间就BS商城网站服务等相关事宜所订立的契约，请您仔细阅读本注册协议，您点击;同意并继续;按钮后，本协议即构成对双方有约束力的法律文件。&lt;/p&gt;\n&lt;p&gt;第1条 本站服务条款的确认和接纳&lt;/p&gt;\n&lt;p&gt;\n1.1本站的各项电子服务的所有权和运作权归BS商城所有。用户同意所有注册协议条款并完成注册程序，才能成为本站的正式用户。用户确认：本协议条款是处理双方权利义务的契约，始终有效，法律另有强制性规定或双方另有特别约定的，依其规定。&lt;br&gt;1.2用户点击同意本协议的，即视为用户确认自己具有享受本站服务、下单购物等相应的权利能力和行为能力，能够独立承担法律责任。&lt;br&gt;1.3如果您在18周岁以下，您只能在父母或监护人的监护参与下才能使用本站。&lt;br&gt;1.4BS商城保留在中华人民共和国大陆地区法施行之法律允许的范围内独自决定拒绝服务、关闭用户账户、清除或编辑内容或取消订单的权利。\n&lt;/p&gt;\n&lt;p&gt;第2条 本站服务&lt;/p&gt;\n2.1BS商城通过互联网依法为用户提供互联网信息等服务，用户在完全同意本协议及本站规定的情况下，方有权使用本站的相关服务。&lt;br&gt;2.2用户必须自行准备如下设备和承担如下开支：（1）上网设备，包括并不限于电脑或者其他上网终端、调制解调器及其他必备的上网装置；（2）上网开支，包括并不限于网络接入费、上网设备租用费、手机流量费等。\n&lt;p&gt;第3条 用户信息&lt;/p&gt;\n3.1用户应自行诚信向本站提供注册资料，用户同意其提供的注册资料真实、准确、完整、合法有效，用户注册资料如有变动的，应及时更新其注册资料。如果用户提供的注册资料不合法、不真实、不准确、不详尽的，用户需承担因此引起的相应责任及后果，并且BS商城保留终止用户使用BS商城各项服务的权利。&lt;br&gt;3.2用户在本站进行浏览、下单购物等活动时，涉及用户真实姓名/名称、通信地址、联系电话、电子邮箱等隐私信息的，本站将予以严格保密，除非得到用户的授权或法律另有规定，本站不会向外界披露用户隐私信息。&lt;br&gt;3.3用户注册成功后，将产生用户名和密码等账户信息，您可以根据本站规定改变您的密码。用户应谨慎合理的保存、使用其用户名和密码。用户若发现任何非法使用用户账号或存在安全漏洞的情况，请立即通知本站并向公安机关报案。&lt;br&gt;3.4用户同意，BS商城拥有通过邮件、短信电话等形式，向在本站注册、购物用户、收货人发送订单信息、促销活动等告知信息的权利。&lt;br&gt;3.5用户不得将在本站注册获得的账户借给他人使用，否则用户应承担由此产生的全部责任，并与实际使用人承担连带责任。&lt;br&gt;3.6用户同意，BS商城有权使用用户的注册信息、用户名、密码等信息，登录进入用户的注册账户，进行证据保全，包括但不限于公证、见证等。\n&lt;p&gt;第4条 用户依法言行义务&lt;/p&gt;\n本协议依据国家相关法律法规规章制定，用户同意严格遵守以下义务：&lt;br&gt;\n（1）不得传输或发表：煽动抗拒、破坏宪法和法律、行政法规实施的言论，煽动颠覆国家政权，推翻社会主义制度的言论，煽动分裂国家、破坏国家统一的的言论，煽动民族仇恨、民族歧视、破坏民族团结的言论；&lt;br&gt;\n（2）从中国大陆向境外传输资料信息时必须符合中国有关法规；&lt;br&gt;\n（3）不得利用本站从事洗钱、窃取商业秘密、窃取个人信息等违法犯罪活动；&lt;br&gt;\n（4）不得干扰本站的正常运转，不得侵入本站及国家计算机信息系统；&lt;br&gt;\n（5）不得传输或发表任何违法犯罪的、骚扰性的、中伤他人的、辱骂性的、恐吓性的、伤害性的、庸俗的，淫秽的、不文明的等信息资料；&lt;br&gt;\n（6）不得传输或发表损害国家社会公共利益和涉及国家安全的信息资料或言论；&lt;br&gt;\n（7）不得教唆他人从事本条所禁止的行为；&lt;br&gt;\n（8）不得利用在本站注册的账户进行牟利性经营活动；&lt;br&gt;\n（9）不得发布任何侵犯他人著作权、商标权等知识产权或合法权利的内容；&lt;br&gt;\n用户应不时关注并遵守本站不时公布或修改的各类合法规则规定。&lt;br&gt;\n本站保有删除站内各类不符合法律政策或不真实的信息内容而无须通知用户的权利。&lt;br&gt;\n若用户未遵守以上规定的，本站有权作出独立判断并采取暂停或关闭用户帐号等措施。用户须对自己在网上的言论和行为承担法律责任。\n&lt;p&gt;第5条 商品信息&lt;/p&gt;\n本站上的商品价格、数量、是否有货等商品信息随时都有可能发生变动，本站不作特别通知。由于网站上商品信息的数量极其庞大，虽然本站会尽最大努力保证您所浏览商品信息的准确性，但由于众所周知的互联网技术因素等客观原因存在，本站网页显示的信息可能会有一定的滞后性或差错，对此情形您知悉并理解；BS商城欢迎纠错，并会视情况给予纠错者一定的奖励。为表述便利，商品和服务简称为;商品;或;货物;。\n&lt;p&gt;第6条 订单&lt;/p&gt;\n6.1在您下订单时，请您仔细确认所购商品的名称、价格、数量、型号、规格、尺寸、联系地址、电话、收货人等信息。收货人与用户本人不一致的，收货人的行为和意思表示视为用户的行为和意思表示，用户应对收货人的行为及意思表示的法律后果承担连带责任。&lt;br&gt;\n6.2除法律另有强制性规定外，双方约定如下：本站上销售方展示的商品和价格等信息仅仅是交易信息的发布，您下单时须填写您希望购买的商品数量、价款及支付方式、收货人、联系方式、收货地址等内容；系统生成的订单信息是计算机信息系统根据您填写的内容自动生成的数据，仅是您向销售方发出的交易诉求；销售方收到您的订单信息后，只有在销售方将您在订单中订购的商品从仓库实际直接向您发出时（ 以商品出库为标志），方视为您与销售方之间就实际直接向您发出的商品建立了交易关系；如果您在一份订单里订购了多种商品并且销售方只给您发出了部分商品时，您与销售方之间仅就实际直接向您发出的商品建立了交易关系；只有在销售方实际直接向您发出了订单中订购的其他商品时，您和销售方之间就订单中该其他已实际直接向您发出的商品才成立交易关系。您可以随时登录您在本站注册的账户，查询您的订单状态。&lt;br&gt;\n6.3由于市场变化及各种以合理商业努力难以控制的因素的影响，本站无法保证您提交的订单信息中希望购买的商品都会有货；如您拟购买的商品，发生缺货，您有权取消订单。\n&lt;p&gt;第7条 配送&lt;/p&gt;\n7.1销售方将会把商品（货物）送到您所指定的收货地址，所有在本站上列出的送货时间为参考时间，参考时间的计算是根据库存状况、正常的处理过程和送货时间、送货地点的基础上估计得出的。&lt;br&gt;\n7.2因如下情况造成订单延迟或无法配送等，销售方不承担延迟配送的责任：&lt;br&gt;\n（1）用户提供的信息错误、地址不详细等原因导致的；&lt;br&gt;\n（2）货物送达后无人签收，导致无法配送或延迟配送的；&lt;br&gt;\n（3）情势变更因素导致的；&lt;br&gt;\n（4）不可抗力因素导致的，例如：自然灾害、交通戒严、突发战争等。\n&lt;p&gt;第8条 所有权及知识产权条款&lt;/p&gt;\n8.1用户一旦接受本协议，即表明该用户主动将其在任何时间段在本站发表的任何形式的信息内容（包括但不限于客户评价、客户咨询、各类话题文章等信息内容）的财产性权利等任何可转让的权利，如著作权财产权（包括并不限于：复制权、发行权、出租权、展览权、表演权、放映权、广播权、信息网络传播权、摄制权、改编权、翻译权、汇编权以及应当由著作权人享有的其他可转让权利），全部独家且不可撤销地转让给BS商城所有，用户同意BS商城有权就任何主体侵权而单独提起诉讼。&lt;br&gt;\n8.2本协议已经构成《中华人民共和国著作权法》第二十五条（条文序号依照2011年版著作权法确定）及相关法律规定的著作财产权等权利转让书面协议，其效力及于用户在BS商城网站上发布的任何受著作权法保护的作品内容，无论该等内容形成于本协议订立前还是本协议订立后。&lt;br&gt;\n8.3用户同意并已充分了解本协议的条款，承诺不将已发表于本站的信息，以任何形式发布或授权其它主体以任何方式使用（包括但不限于在各类网站、媒体上使用）。&lt;br&gt;\n8.4BS商城是本站的制作者,拥有此网站内容及资源的著作权等合法权利,受国家法律保护,有权不时地对本协议及本站的内容进行修改，并在本站张贴，无须另行通知用户。在法律允许的最大限度范围内，小V商城对本协议及本站内容拥有解释权。&lt;br&gt;\n8.5除法律另有强制性规定外，未经BS商城明确的特别书面许可,任何单位或个人不得以任何方式非法地全部或部分复制、转载、引用、链接、抓取或以其他方式使用本站的信息内容，否则，BS商城有权追究其法律责任。&lt;br&gt;\n8.6本站所刊登的资料信息（诸如文字、图表、标识、按钮图标、图像、声音文件片段、数字下载、数据编辑和软件），均是BS商城或其内容提供者的财产，受中国和国际版权法的保护。本站上所有内容的汇编是BS商城的排他财产，受中国和国际版权法的保护。本站上所有软件都是小V商城或其关联公司或其软件供应商的财产，受中国和国际版权法的保护。\n&lt;p&gt;第9条 责任限制及不承诺担保&lt;/p&gt;\n除非另有明确的书面说明,本站及其所包含的或以其它方式通过本站提供给您的全部信息、内容、材料、产品（包括软件）和服务，均是在;按现状;和;按现有;的基础上提供的。&lt;br&gt;\n除非另有明确的书面说明,BS商城不对本站的运营及其包含在本网站上的信息、内容、材料、产品（包括软件）或服务作任何形式的、明示或默示的声明或担保（根据中华人民共和国法律另有规定的以外）。&lt;br&gt;BS商城不担保本站所包含的或以其它方式通过本站提供给您的全部信息、内容、材料、产品（包括软件）和服务、其服务器或从本站发出的电子信件、信息没有病毒或其他有害成分。&lt;br&gt;\n如因不可抗力或其它本站无法控制的原因使本站销售系统崩溃或无法正常使用导致网上交易无法完成或丢失有关的信息、记录等，BS商城会合理地尽力协助处理善后事宜。\n&lt;p&gt;第10条 协议更新及用户关注义务&lt;/p&gt;\n根据国家法律法规变化及网站运营需要，BS商城有权对本协议条款不时地进行修改，修改后的协议一旦被张贴在本站上即生效，并代替原来的协议。用户可随时登录查阅最新协议； 用户有义务不时关注并阅读最新版的协议及网站公告。如用户不同意更新后的协议，可以且应立即停止接受BS商城网站依据本协议提供的服务；如用户继续使用本网站提供的服务的，即视为同意更新后的协议。BS商城建议您在使用本站之前阅读本协议及本站的公告。 如果本协议中任何一条被视为废止、无效或因任何理由不可执行，该条应视为可分的且并不影响任何其余条款的有效性和可执行性。\n&lt;p&gt;第11条 法律管辖和适用&lt;/p&gt;\n本协议的订立、执行和解释及争议的解决均应适用在中华人民共和国大陆地区适用之有效法律（但不包括其冲突法规则）。 如发生本协议与适用之法律相抵触时，则这些条款将完全按法律规定重新解释，而其它有效条款继续有效。 如缔约方就本协议内容或其执行发生任何争议，双方应尽力友好协商解决；协商不成时，任何一方均可向有管辖权的中华人民共和国大陆地区法院提起诉讼。\n&lt;p&gt;第12条 其他&lt;/p&gt;\n12.1BS商城网站所有者是指在政府部门依法许可或备案的BS商城网站经营主体。&lt;br&gt;\n12.2BS商城尊重用户和消费者的合法权利，本协议及本网站上发布的各类规则、声明等其他内容，均是为了更好的、更加便利的为用户和消费者提供服务。本站欢迎用户和社会各界提出意见和建议，BS商城将虚心接受并适时修改本协议及本站上的各类规则。&lt;br&gt;\n12.3本协议内容中以黑体、加粗、下划线、斜体等方式显著标识的条款，请用户着重阅读。&lt;br&gt;\n12.4您点击本协议下方的;同意并继续;按钮即视为您完全接受本协议，在点击之前请您再次确认已知悉并完全理解本协议的全部内容。', 1639145389, 1640849792, 1, 0);

-- ----------------------------
-- Table structure for bs_banner
-- ----------------------------
DROP TABLE IF EXISTS `bs_banner`;
CREATE TABLE `bs_banner`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '-1-已下线，0-正常',
  `url` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '链接',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图片',
  `s_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '开始展示时间',
  `e_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '结束时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_banner
-- ----------------------------
INSERT INTO `bs_banner` VALUES (3, 'abc', 0, '/mall/order/all_orders.html', '/static/mall/upload/ban3.jpg', 1634822944, 1667478091);
INSERT INTO `bs_banner` VALUES (4, '测试', 0, '/mall/user/index.html', '/static/mall/upload/ban4.jpg', 1634822944, 1667478091);

-- ----------------------------
-- Table structure for bs_cart
-- ----------------------------
DROP TABLE IF EXISTS `bs_cart`;
CREATE TABLE `bs_cart`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `goods_id` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `uid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `count` int(4) UNSIGNED NOT NULL DEFAULT 0,
  `add_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '新增时间',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0-未选中，1-已选中',
  `abc` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'ces',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 72 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_cart
-- ----------------------------

-- ----------------------------
-- Table structure for bs_common_user
-- ----------------------------
DROP TABLE IF EXISTS `bs_common_user`;
CREATE TABLE `bs_common_user`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `account` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '登录账号',
  `uid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户唯一标识',
  `pwd` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `salt` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '密码盐值',
  `add_time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `up_time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1-限制登录，0-正常',
  `pwd_err_count` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '密码错误次数',
  `loginCount` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户备注',
  `nickname` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户昵称',
   `openid_wx` varchar(50) DEFAULT '' COMMENT '微信公众号openid',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_common_user
-- ----------------------------
INSERT INTO `bs_common_user` VALUES (7, 'demo', 'bs91ca7180113e01fde28a157bb75bb78c', '49a898f1598aea441047af614e05be9c', 'uVV3xxQ136', 1637426446, 1638688210, 0, 0, 16, '测试', '','');

-- ----------------------------
-- Table structure for bs_common_user_address
-- ----------------------------
DROP TABLE IF EXISTS `bs_common_user_address`;
CREATE TABLE `bs_common_user_address`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `province` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `city` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `area` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `town` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '详细地址',
  `is_default` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1-默认地址',
  `mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '收货人号码',
  `username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '收货人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 57603 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_common_user_address
-- ----------------------------
INSERT INTO `bs_common_user_address` VALUES (2, 'bs76eb38dc7a8550b10d506b157e17d50f', '湖南省', '衡阳市', '珠晖区', '', '未知楼x2号', 0, '135000000001', '小唯');
INSERT INTO `bs_common_user_address` VALUES (3, 'bs76eb38dc7a8550b10d506b157e17d50f', '广东省', '广州市', '白云区', '白云街道', '未知楼3号', 0, '135000000001', '小唯');
INSERT INTO `bs_common_user_address` VALUES (5, 'bs76eb38dc7a8550b10d506b157e17d50f', '广东省', '广州市', '白云区', '', '未知楼33号', 1, '135000000007', '小唯');
INSERT INTO `bs_common_user_address` VALUES (6, 'bs76eb38dc7a8550b10d506b157e17d50f', '广东省', '广州市', '白云区', '', '未知楼444号', 0, '135000000006', '小唯');
INSERT INTO `bs_common_user_address` VALUES (7, 'bs76eb38dc7a8550b10d506b157e17d50f', '广东省', '广州市', '白云区', '白云街道', '未知楼x34x号', 0, '135000000001', '小唯');
INSERT INTO `bs_common_user_address` VALUES (10, 'bse146d44f7c8ef0e3cd10b5a910843998', '北京', '北京市', '东城区', '', 'asdfadsfsdf', 1, '13444444444', 'youx');
INSERT INTO `bs_common_user_address` VALUES (11, 'bs91ca7180113e01fde28a157bb75bb78c', '吉林省', '长春市', '南关区', '', '大街250号', 1, '13533333333', '测试');
INSERT INTO `bs_common_user_address` VALUES (12, 'bs2418024c93528c76143bff418bb4f5a0', '河北省', '石家庄市', '长安区', '', '长安大街333号', 1, '14588639276', '小山');
INSERT INTO `bs_common_user_address` VALUES (57594, 'bse005ba91a7deb45e748bd81448214668', '北京', '北京市', '东城区', '', '查询欧大哥我服务费', 1, '13500000001', '查不出');
INSERT INTO `bs_common_user_address` VALUES (57595, 'bs0d1cb982dd3c84107876c1be761a5b01', '黑龙江省', '哈尔滨市', '道里区', '', '自我我我我我', 1, '13636363462', '普洛斯');
INSERT INTO `bs_common_user_address` VALUES (57596, 'bs9248580af90f8b106b2fef151b4c529f', '吉林省', '长春市', '南关区', '', '测试一下', 1, '16866996525', '小龙');
INSERT INTO `bs_common_user_address` VALUES (57597, 'bsac6d70ffe0b1a03c7745b9eaf305b8a1', '吉林省', '长春市', '南关区', '', '来咯结茧了', 0, '12525252524', '测试');
INSERT INTO `bs_common_user_address` VALUES (57598, 'bsfa1adb77b9c0d47880795f2348aac1f4', '内蒙古自治区', '呼和浩特市', '新城区', '', '新城区大连街58号', 1, '16363636363', '小孔');
INSERT INTO `bs_common_user_address` VALUES (57599, 'bs20f327bdfc33324b1c0e78f3e11ef096', '内蒙古自治区', '呼和浩特市', '新城区', '', '大草原帐篷99号', 1, '13454334567', '小李');
INSERT INTO `bs_common_user_address` VALUES (57600, 'bsd6f11d4c7418fe724a5f4cfa9e6f201d', '北京', '北京市', '东城区', '', '12321313123', 0, '123232313', '123123');
INSERT INTO `bs_common_user_address` VALUES (57601, 'bs720c81919496824952fc953d128e752c', '北京', '北京市', '东城区', '', '123123', 0, '12313', '123');
INSERT INTO `bs_common_user_address` VALUES (57602, 'bs720c81919496824952fc953d128e752c', '北京', '北京市', '东城区', '', '123123', 0, '12313', '123');

-- ----------------------------
-- Table structure for bs_common_user_credit_log
-- ----------------------------
DROP TABLE IF EXISTS `bs_common_user_credit_log`;
CREATE TABLE `bs_common_user_credit_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `add_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '操作时间',
  `remark` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '交易说明',
  `before_num` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '交易前',
  `num` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '交易量',
  `after_num` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '交易后',
  `type` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '账户类型：1-购买商品，2-充值记录，3-提现记录',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uid_type`(`uid`, `type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 156 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户余额交易流水表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_common_user_credit_log
-- ----------------------------

-- ----------------------------
-- Table structure for bs_common_user_credits
-- ----------------------------
DROP TABLE IF EXISTS `bs_common_user_credits`;
CREATE TABLE `bs_common_user_credits`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `credit` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '余额',
  `point` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '积分',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 40 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户账户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_common_user_credits
-- ----------------------------

-- ----------------------------
-- Table structure for bs_common_user_login_log
-- ----------------------------
DROP TABLE IF EXISTS `bs_common_user_login_log`;
CREATE TABLE `bs_common_user_login_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `add_time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 78 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_common_user_login_log
-- ----------------------------

-- ----------------------------
-- Table structure for bs_common_user_msg
-- ----------------------------
DROP TABLE IF EXISTS `bs_common_user_msg`;
CREATE TABLE `bs_common_user_msg`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户标识uid',
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '消息标题',
  `content` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '消息内容',
  `type` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0-普通消息，1-系统通知',
  `read_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '查看时间',
  `add_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发送时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户消息记录' ROW_FORMAT = Dynamic;


-- ----------------------------
-- Table structure for bs_common_user_point_log
-- ----------------------------
DROP TABLE IF EXISTS `bs_common_user_point_log`;
CREATE TABLE `bs_common_user_point_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `add_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '操作时间',
  `remark` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '交易说明',
  `before_num` int(10) NOT NULL DEFAULT 0 COMMENT '交易前',
  `num` int(10) NOT NULL DEFAULT 0 COMMENT '交易量',
  `after_num` int(10) NOT NULL DEFAULT 0 COMMENT '交易后',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uid_type`(`uid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 69 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户积分流水表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bs_config
-- ----------------------------
DROP TABLE IF EXISTS `bs_config`;
CREATE TABLE `bs_config`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '配置标识',
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '配置内容',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_config
-- ----------------------------

-- ----------------------------
-- Table structure for bs_error_log
-- ----------------------------
DROP TABLE IF EXISTS `bs_error_log`;
CREATE TABLE `bs_error_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `add_time` int(10) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 982 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '异常日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_error_log
-- ----------------------------

-- ----------------------------
-- Table structure for bs_feedback
-- ----------------------------
DROP TABLE IF EXISTS `bs_feedback`;
CREATE TABLE `bs_feedback`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '内容',
  `category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '类型，如“反馈”、“留言”',
  `add_time` int(10) NULL DEFAULT 0,
  `up_time` int(10) NULL DEFAULT 0,
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '0-待处理，1-已处理',
  `imgs` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '图片，多张用逗号分开',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '留言反馈' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bs_goods
-- ----------------------------
DROP TABLE IF EXISTS `bs_goods`;
CREATE TABLE `bs_goods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(120) NOT NULL DEFAULT '' COMMENT '标题',
  `goods_desc` varchar(255) NOT NULL DEFAULT '' COMMENT '简单描述',
  `thumb` varchar(255) NOT NULL DEFAULT '' COMMENT '封面图',
  `market_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '市场价',
  `price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '销售价',
  `stock` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '库存',
  `stock_locked` int(10) NOT NULL DEFAULT '0' COMMENT '锁库数量',
  `sale` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '销量',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0-仓库中，1-已上架',
  `banners` varchar(2000) NOT NULL DEFAULT '' COMMENT '轮播图列表',
  `content` text COMMENT '详情',
  `is_top` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否为推荐商品，1-已推荐',
  `category_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '分类编号',
  `store_num` varchar(20) NOT NULL DEFAULT '' COMMENT '店铺唯一标识',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;
-- ----------------------------
-- Records of bs_goods
-- ----------------------------
INSERT INTO `bs_goods` VALUES (1, '植物香氛染发剂自己在家染发膏植物天然品牌2021流行色学生黑茶色', '植物香氛染发剂自己在家染发膏植物天然品牌2021流行色学生黑茶色', 'https://img.pddpic.com/gaudit-image/2021-11-03/e23d005f899354d23cbcd298a097a609.jpeg', 53.80, 0.01, 100, 0, 0, 1637489181, 1, '[\"https:\\/\\/img.pddpic.com\\/mms-material-img\\/2021-11-03\\/f696a378-5f9a-4518-873f-47f0617b08a5.jpeg.a.jpeg\",\"https:\\/\\/img.pddpic.com\\/gaudit-image\\/2021-11-03\\/e23d005f899354d23cbcd298a097a609.jpeg\"]', '&lt;img style=&quot;max-width: 100%&quot; src=&quot;https://img.pddpic.com/mms-material-img/2021-11-03/f696a378-5f9a-4518-873f-47f0617b08a5.jpeg.a.jpeg&quot;/&gt;&lt;img style=&quot;max-width: 100%&quot; src=&quot;https://img.pddpic.com/gaudit-image/2021-11-03/e23d005f899354d23cbcd298a097a609.jpeg&quot;/&gt;', 0, 5, '123456');
INSERT INTO `bs_goods` VALUES (2, '孕妇可用染发剂膏纯自己在家染天然植物不沾头皮不沾手2021流行色', '孕妇可用染发剂膏纯自己在家染天然植物不沾头皮不沾手2021流行色', 'https://t00img.yangkeduo.com/goods/images/2021-04-04/8a237ee32fb1a4001062f6bb6c34b3c8.jpeg', 65.80, 0.01, 100, 0, 0, 1637489181, 1, '[\"https://img.pddpic.com/mms-material-img/2021-04-04/af55f1e1-6f93-4e47-92b0-666a35ccc338.jpeg.a.jpeg\",\"https://t00img.yangkeduo.com/goods/images/2021-04-04/8a237ee32fb1a4001062f6bb6c34b3c8.jpeg\"]', '&lt;img style=&quot;max-width: 100%&quot; src=&quot;https://img.pddpic.com/mms-material-img/2021-04-04/af55f1e1-6f93-4e47-92b0-666a35ccc338.jpeg.a.jpeg&quot;/&gt;&lt;img style=&quot;max-width: 100%&quot; src=&quot;https://t00img.yangkeduo.com/goods/images/2021-04-04/8a237ee32fb1a4001062f6bb6c34b3c8.jpeg&quot;/&gt;', 1, 0, '123456');
INSERT INTO `bs_goods` VALUES (3, '买一送一/染发膏剂自己在家染学生2021流行色天然植物品牌黑茶色', '买一送一/染发膏剂自己在家染学生2021流行色天然植物品牌黑茶色', 'https://img.pddpic.com/gaudit-image/2021-11-03/b3dd7bde3f9bd397c32ecbc18fce0794.jpeg', 59.90, 0.01, 100, 0, 0, 1637489181, 1, '[\"https://img.pddpic.com/mms-material-img/2021-09-24/78f2cfb7-30ca-4245-8e4b-8169a133961c.jpeg.a.jpeg\",\"https://img.pddpic.com/gaudit-image/2021-11-03/b3dd7bde3f9bd397c32ecbc18fce0794.jpeg\"]', '&lt;img style=&quot;max-width: 100%&quot; src=&quot;https://img.pddpic.com/mms-material-img/2021-09-24/78f2cfb7-30ca-4245-8e4b-8169a133961c.jpeg.a.jpeg&quot;/&gt;&lt;img style=&quot;max-width: 100%&quot; src=&quot;https://img.pddpic.com/gaudit-image/2021-11-03/b3dd7bde3f9bd397c32ecbc18fce0794.jpeg&quot;/&gt;', 1, 0, '123456');
INSERT INTO `bs_goods` VALUES (4, '蒙倩染发膏剂自己在家染2021流行黑色天然植物品牌女男式200ml', '蒙倩染发膏剂自己在家染2021流行黑色天然植物品牌女男式200ml', 'https://img.pddpic.com/gaudit-image/2021-11-10/94ffc30601be4d09a278ce772c9e34af.jpeg', 29.90, 0.01, 100, 0, 1, 1637489181, 1, '[\"https://img.pddpic.com/mms-material-img/2021-11-10/36b2242e-f981-4ef5-91df-d7fc008d16af.jpeg.a.jpeg\",\"https://img.pddpic.com/gaudit-image/2021-11-10/94ffc30601be4d09a278ce772c9e34af.jpeg\"]', '&lt;img style=&quot;max-width: 100%&quot; src=&quot;https://img.pddpic.com/mms-material-img/2021-11-10/36b2242e-f981-4ef5-91df-d7fc008d16af.jpeg.a.jpeg&quot;/&gt;&lt;img style=&quot;max-width: 100%&quot; src=&quot;https://img.pddpic.com/gaudit-image/2021-11-10/94ffc30601be4d09a278ce772c9e34af.jpeg&quot;/&gt;', 1, 0, '123456');
INSERT INTO `bs_goods` VALUES (5, '南极人3双装女童连裤袜春夏款儿童打底裤白色六一表演练功舞蹈袜', '南极人3双装女童连裤袜春夏款儿童打底裤白色六一表演练功舞蹈袜', 'https://t00img.yangkeduo.com/goods/images/2021-02-03/b0fce2aec3f69b79cecb3985e49e09f6.jpeg', 19.90, 0.01, 100, 0, 0, 1637489181, 1, '[\"https://t00img.yangkeduo.com/goods/images/2019-05-08/498da6e7-937a-4de1-bec8-12292439e6b8.jpg\",\"https://t00img.yangkeduo.com/goods/images/2021-02-03/b0fce2aec3f69b79cecb3985e49e09f6.jpeg\"]', '&lt;img style=&quot;max-width: 100%&quot; src=&quot;https://t00img.yangkeduo.com/goods/images/2019-05-08/498da6e7-937a-4de1-bec8-12292439e6b8.jpg&quot;/&gt;&lt;img style=&quot;max-width: 100%&quot; src=&quot;https://t00img.yangkeduo.com/goods/images/2021-02-03/b0fce2aec3f69b79cecb3985e49e09f6.jpeg&quot;/&gt;', 1, 0, '123456');
INSERT INTO `bs_goods` VALUES (6, '花花公子男士内裤男平角裤衩纯棉男生加大码胖子肥佬宽松四角裤头', '花花公子男士内裤男平角裤衩纯棉男生加大码胖子肥佬宽松四角裤头', 'https://t00img.yangkeduo.com/goods/images/2020-11-21/ad4fc2baaa652435ef68655f5b8ecf7b.jpeg', 49.00, 0.01, 100, 0, 0, 1637489181, 1, '[\"https://img.pddpic.com/mms-material-img/2020-11-21/946789cc-4ce4-48a9-b016-11c709292faa.jpeg\",\"https://t00img.yangkeduo.com/goods/images/2020-11-21/ad4fc2baaa652435ef68655f5b8ecf7b.jpeg\"]', '&lt;img style=&quot;max-width: 100%&quot; src=&quot;https://img.pddpic.com/mms-material-img/2020-11-21/946789cc-4ce4-48a9-b016-11c709292faa.jpeg&quot;/&gt;&lt;img style=&quot;max-width: 100%&quot; src=&quot;https://t00img.yangkeduo.com/goods/images/2020-11-21/ad4fc2baaa652435ef68655f5b8ecf7b.jpeg&quot;/&gt;', 1, 0, '123456');
INSERT INTO `bs_goods` VALUES (7, '除杀蟑螂药一窝端灭蟑螂神器室内去蟑螂贴厨房强效家用无毒蟑螂屋', '除杀蟑螂药一窝端灭蟑螂神器室内去蟑螂贴厨房强效家用无毒蟑螂屋', 'https://t00img.yangkeduo.com/goods/images/2019-08-21/cfbb5dd8e42bbf485fe3a0e33b816a43.jpeg', 18.80, 0.01, 100, 0, 0, 1637489181, 1, '[\"https://t00img.yangkeduo.com/goods/images/2019-08-21/22c8e097-6217-43be-81ec-d6bb140b18cc.jpg\",\"https://t00img.yangkeduo.com/goods/images/2019-08-21/cfbb5dd8e42bbf485fe3a0e33b816a43.jpeg\"]', '&lt;img style=&quot;max-width: 100%&quot; src=&quot;https://t00img.yangkeduo.com/goods/images/2019-08-21/22c8e097-6217-43be-81ec-d6bb140b18cc.jpg&quot;/&gt;&lt;img style=&quot;max-width: 100%&quot; src=&quot;https://t00img.yangkeduo.com/goods/images/2019-08-21/cfbb5dd8e42bbf485fe3a0e33b816a43.jpeg&quot;/&gt;', 1, 3, '123456');
INSERT INTO `bs_goods` VALUES (8, '南极人洗衣机杀菌泡腾片全自动滚筒洗衣机去污神器清洗剂除螨家用', '南极人洗衣机杀菌泡腾片全自动滚筒洗衣机去污神器清洗剂除螨家用', 'https://t00img.yangkeduo.com/goods/images/2020-05-07/ddc5b751ad0053c629b8e73e07ca81fd.jpeg', 9.90, 0.01, 100, 0, 0, 1637489181, 1, '[\"https://t00img.yangkeduo.com/goods/images/2020-04-17/216ae0d7-7817-4ec4-aa24-97faf8415dd5.jpg\",\"https://t00img.yangkeduo.com/goods/images/2020-05-07/ddc5b751ad0053c629b8e73e07ca81fd.jpeg\"]', '&lt;img style=&quot;max-width: 100%&quot; src=&quot;https://t00img.yangkeduo.com/goods/images/2020-04-17/216ae0d7-7817-4ec4-aa24-97faf8415dd5.jpg&quot;/&gt;&lt;img style=&quot;max-width: 100%&quot; src=&quot;https://t00img.yangkeduo.com/goods/images/2020-05-07/ddc5b751ad0053c629b8e73e07ca81fd.jpeg&quot;/&gt;', 1, 3, '123456');
INSERT INTO `bs_goods` VALUES (9, '收纳袋子真空压缩袋装被子衣物宿舍必备厚衣服收纳袋装被子的袋子', '收纳袋子真空压缩袋装被子衣物宿舍必备厚衣服收纳袋装被子的袋子', 'https://t00img.yangkeduo.com/goods/images/2020-10-06/b562ea42f5148aa533734773d1e8e78f.jpeg', 6.18, 0.01, 100, 0, 0, 1637489181, 1, '[\"https://img.pddpic.com/mms-material-img/2020-10-06/7cf1ae93-42b1-4758-a52c-a322d660dce3.jpeg.a.jpeg\",\"https://t00img.yangkeduo.com/goods/images/2020-10-06/b562ea42f5148aa533734773d1e8e78f.jpeg\"]', '&lt;img style=&quot;max-width: 100%&quot; src=&quot;https://img.pddpic.com/mms-material-img/2020-10-06/7cf1ae93-42b1-4758-a52c-a322d660dce3.jpeg.a.jpeg&quot;/&gt;&lt;img style=&quot;max-width: 100%&quot; src=&quot;https://t00img.yangkeduo.com/goods/images/2020-10-06/b562ea42f5148aa533734773d1e8e78f.jpeg&quot;/&gt;', 1, 3, '123456');
INSERT INTO `bs_goods` VALUES (10, '公牛开关插座面板正品家用86型墙壁16a三孔带USB五孔暗装开关插座', '公牛开关插座面板正品家用86型墙壁16a三孔带USB五孔暗装开关插座', 'https://img.pddpic.com/gaudit-image/2021-10-15/49315426b8ed77039652edc30a5a34fb.jpeg', 6.70, 0.01, 100, 0, 0, 1637489181, 1, '[\"https://img.pddpic.com/mms-material-img/2021-10-15/54c81574-ad7d-459a-a605-24e9db359dee.jpeg\",\"https://img.pddpic.com/gaudit-image/2021-10-15/49315426b8ed77039652edc30a5a34fb.jpeg\"]', '&lt;img style=&quot;max-width: 100%&quot; src=&quot;https://img.pddpic.com/mms-material-img/2021-10-15/54c81574-ad7d-459a-a605-24e9db359dee.jpeg&quot;/&gt;&lt;img style=&quot;max-width: 100%&quot; src=&quot;https://img.pddpic.com/gaudit-image/2021-10-15/49315426b8ed77039652edc30a5a34fb.jpeg&quot;/&gt;', 1, 3, '123456');

-- ----------------------------
-- Table structure for bs_goods_category
-- ----------------------------
DROP TABLE IF EXISTS `bs_goods_category`;
CREATE TABLE `bs_goods_category`  (
  `category_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `parent_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上级编号',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0-禁用，1-已启用',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`category_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_goods_category
-- ----------------------------
INSERT INTO `bs_goods_category` VALUES (1, '日常百货', 0, 1, '/static/mall/upload/pro3.jpg');
INSERT INTO `bs_goods_category` VALUES (2, '服装礼饰', 0, 1, '/static/mall/upload/pro3.jpg');
INSERT INTO `bs_goods_category` VALUES (3, '酒水饮品', 1, 1, '/static/mall/upload/pro3.jpg');
INSERT INTO `bs_goods_category` VALUES (4, '纸巾牙刷', 1, 1, '/static/mall/upload/pro3.jpg');
INSERT INTO `bs_goods_category` VALUES (5, '男装', 2, 1, '/static/mall/upload/pro3.jpg');
INSERT INTO `bs_goods_category` VALUES (6, '女装', 2, 1, '/static/mall/upload/pro3.jpg');
INSERT INTO `bs_goods_category` VALUES (7, '上衣', 2, 1, '/static/mall/upload/pro3.jpg');
INSERT INTO `bs_goods_category` VALUES (8, '油品粮食', 0, 1, '/static/mall/upload/pro3.jpg');
INSERT INTO `bs_goods_category` VALUES (9, '大米', 8, 1, '/static/mall/upload/pro3.jpg');
INSERT INTO `bs_goods_category` VALUES (10, '面条', 8, 1, '/static/mall/upload/pro3.jpg');
INSERT INTO `bs_goods_category` VALUES (11, '螺蛳粉', 8, 1, '/static/mall/upload/pro3.jpg');
INSERT INTO `bs_goods_category` VALUES (13, '未分组', 1, 1, '/static/mall/upload/pro3.jpg');

-- ----------------------------
-- Table structure for bs_goods_comment
-- ----------------------------
DROP TABLE IF EXISTS `bs_goods_comment`;
CREATE TABLE `bs_goods_comment`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `order_goods_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '订单商品ID',
  `goods_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商品ID',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '评价内容',
  `star` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '星星数量',
  `add_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '评价时间',
  `imgs` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图片，最多3张',
  `is_hide_user` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否匿名',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0-待审核，1-已通过（可以显示）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_goods_id_oid`(`goods_id`, `order_goods_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品评价' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_goods_comment
-- ----------------------------
INSERT INTO `bs_goods_comment` VALUES (1, 'bs91ca7180113e01fde28a157bb75bb78c', 91, 982, '速度好快啊，太好了，超赞的', 5, 1640139572, 'https://img.pddpic.com/gaudit-image/2021-09-09/123ea260eb8d7c8001fe98e2413073a5.jpeg', 1, 1);
INSERT INTO `bs_goods_comment` VALUES (2, 'bs91ca7180113e01fde28a157bb75bb78c', 92, 982, '很方便，我下单后经过直接取货就行了，满意。', 5, 1640144002, 'https://img.pddpic.com/gaudit-image/2021-09-09/123ea260eb8d7c8001fe98e2413073a5.jpeg', 1, 1);
INSERT INTO `bs_goods_comment` VALUES (3, 'bs91ca7180113e01fde28a157bb75bb78c', 88, 53, '***，这个***，真的不懒啊哦', 4, 1640851612, 'https://img.pddpic.com/gaudit-image/2021-09-09/123ea260eb8d7c8001fe98e2413073a5.jpeg', 1, 0);
INSERT INTO `bs_goods_comment` VALUES (4, 'bs91ca7180113e01fde28a157bb75bb78c', 87, 53, '使用体验真的不错，这个感觉就特别舒服***就是这一个', 4, 1640852280, '', 1, 1);
INSERT INTO `bs_goods_comment` VALUES (5, 'bsfa1adb77b9c0d47880795f2348aac1f4', 14732, 1002, '收到货了，真心不错', 5, 1641874319, '', 1, 1);

-- ----------------------------
-- Table structure for bs_goods_favorite
-- ----------------------------
DROP TABLE IF EXISTS `bs_goods_favorite`;
CREATE TABLE `bs_goods_favorite`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `goods_id` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `uid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '收藏用户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bs_navs
-- ----------------------------
DROP TABLE IF EXISTS `bs_navs`;
CREATE TABLE `bs_navs`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '-1-已下线，0-正常',
  `url` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '链接',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图片',
  `s_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '开始展示时间',
  `e_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '结束时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_navs
-- ----------------------------
INSERT INTO `bs_navs` VALUES (1, '超级红包', 0, 'http://blog.wei1.top', '/static/mall/images/icon-link1.png', 1634822944, 1667478091);
INSERT INTO `bs_navs` VALUES (2, '酒水饮料', 0, '/mall/goods/pro_list.html?category_id=3', '/static/mall/images/icon-link2.png', 1634822944, 1667478091);
INSERT INTO `bs_navs` VALUES (3, '我的订单', 0, '/mall/order/all_orders.html', '/static/mall/images/icon-link3.png', 1634822944, 1667478091);
INSERT INTO `bs_navs` VALUES (4, '个人主页', 0, '/mall/user/index.html', '/static/mall/images/icon-link4.png', 1634822944, 1667478091);

-- ----------------------------
-- Table structure for bs_order
-- ----------------------------
DROP TABLE IF EXISTS `bs_order`;
CREATE TABLE `bs_order`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_sn` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '订单编号',
  `uid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户标识',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '-1-已取消，0-待支付，1-已支付，2-待收货，3-已完，-2-已退款',
  `price` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '订单金额',
  `pay_price` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '实付金额',
  `add_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `up_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `send_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发货时间',
  `pay_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '支付时间',
  `pay_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'wechat-微信，alipay-支付宝，credit-余额',
  `trans_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '交易号',
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '地址信息',
  `cancel_pay_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '超时支付截止时间',
  `store_num` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '门店编号',
  `is_del` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1-用户自己删除',
  `pay_openid` varchar(34) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '微信支付openid',
  `express_com` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '物流公司代码',
  `express_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '物流编号',
  `refund_total` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '累计退款',
  `receive_time` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '确认收货时间',
  `order_type` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '订单类型，0-销售，1-展示，2-自提，3-虚拟，4-自提+销售',
  `code_tihuo` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '提货码，针对自提类型会生成',
  `content_virtual` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '虚拟商品发货信息',
  `tihuo_address` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '提货地址',
  `ip_address` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '下单IP地址',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE,
  INDEX `order_sn`(`order_sn`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14771 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_order
-- ----------------------------

-- ----------------------------
-- Table structure for bs_order_goods
-- ----------------------------
DROP TABLE IF EXISTS `bs_order_goods`;
CREATE TABLE `bs_order_goods`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_sn` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '订单编号',
  `goods_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商品编号',
  `thumb` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品缩略图',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品标题',
  `price` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '商品单价',
  `count` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '购买数量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14740 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单商品' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_order_goods
-- ----------------------------

-- ----------------------------
-- Table structure for bs_order_recharge
-- ----------------------------
DROP TABLE IF EXISTS `bs_order_recharge`;
CREATE TABLE `bs_order_recharge`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_sn` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '订单编号',
  `uid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `pay_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'wechat-微信，alipay-支付宝',
  `add_time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `up_time` int(10) UNSIGNED NULL DEFAULT 0,
  `price` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '提交金额',
  `pay_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '实付金额',
  `pay_time` int(10) NOT NULL DEFAULT 0 COMMENT '支付时间',
  `trans_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '交易号',
  `pay_openid` varchar(34) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '支付openid',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '-1-已取消，0-待支付，1-已支付，2-待收货，3-已完，-2-已退款',
  `cancel_pay_time` int(10) NOT NULL DEFAULT 0 COMMENT '截止支付时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户充值订单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bs_order_refund_apply_log
-- ----------------------------
DROP TABLE IF EXISTS `bs_order_refund_apply_log`;
CREATE TABLE `bs_order_refund_apply_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `order_sn` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `apply_money` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `apply_type` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1-仅退款，2-退货退款，3-仅退货',
  `apply_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '申请原因',
  `refuse_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '驳回原因',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0-待处理，1-已通过，-1-已驳回',
  `refund_type` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1-原路退回，2-无需退款，3-手动转账',
  `add_time` int(10) UNSIGNED NULL DEFAULT 0,
  `up_time` int(10) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单售后申请' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bs_plugins
-- ----------------------------
DROP TABLE IF EXISTS `bs_plugins`;
CREATE TABLE `bs_plugins`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `plugin_tag` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '插件标识',
  `plugin_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '插件数据，主要保存json格式的配置信息',
  `disable` tinyint(1) UNSIGNED NULL DEFAULT 1 COMMENT '1已禁用，0启用',
  `add_time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `up_time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 135 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_plugins
-- ----------------------------

-- ----------------------------
-- Table structure for bs_plugins_category
-- ----------------------------
DROP TABLE IF EXISTS `bs_plugins_category`;
CREATE TABLE `bs_plugins_category`  (
  `category_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `parent_id` int(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`category_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_plugins_category
-- ----------------------------
INSERT INTO `bs_plugins_category` VALUES (6, '功能', 0);
INSERT INTO `bs_plugins_category` VALUES (7, '商城', 0);
INSERT INTO `bs_plugins_category` VALUES (8, '支付', 0);
INSERT INTO `bs_plugins_category` VALUES (9, '接口', 0);
INSERT INTO `bs_plugins_category` VALUES (10, '其他', 0);

-- ----------------------------
-- Table structure for bs_stores
-- ----------------------------
DROP TABLE IF EXISTS `bs_stores`;
CREATE TABLE `bs_stores`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `store_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '店铺名称',
  `store_num` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '店铺唯一标识',
  `add_time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `up_time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1-营业中，-1-已停业',
  `is_check` tinyint(1) NOT NULL DEFAULT 0 COMMENT '后台审核状态，1-已通过，-1-已下线',
  `store_logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '店铺logo',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_stores
-- ----------------------------
INSERT INTO `bs_stores` VALUES (1, '小唯店铺', '123456', 0, 1639146628, 1, 1, 'https://demo.bs.shop.wei1.top/upload/bs_mall/239730b1a497267bf23e5b28a779d560.jpg');

-- ----------------------------
-- Table structure for bs_timer_tasks
-- ----------------------------
DROP TABLE IF EXISTS `bs_timer_tasks`;
CREATE TABLE `bs_timer_tasks`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `do_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '任务类型，url-访问url',
  `add_time` int(10) NULL DEFAULT 0,
  `up_time` int(10) NULL DEFAULT 0,
  `content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '对应执行的内容',
  `time_set` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '时间设置',
  `ext_data` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '其他扩展内容',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0-未开启，1-已开启',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '定时任务' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_timer_tasks
-- ----------------------------
INSERT INTO `bs_timer_tasks` VALUES (2, '订单-支付超时自动关闭', 'url', 1640314254, 1640315301, 'http://g.abc.top/api/mall.order/auto_cancel', '', '', 1);
INSERT INTO `bs_timer_tasks` VALUES (3, '订单-自动确认收货', 'url', 1640318129, 1640318187, 'http://g.abc.top/api/mall.order/auto_receive', '', '', 1);

-- ----------------------------
-- Table structure for bs_upload_files_log
-- ----------------------------
DROP TABLE IF EXISTS `bs_upload_files_log`;
CREATE TABLE `bs_upload_files_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '',
  `size` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '文件大小，b',
  `type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '',
  `upload_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '上传方式，local-本地，oss-阿里云oss，qiniu-七牛云',
  `path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '保存路径',
  `add_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上传时间',
  `user_type` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '1-后台，2-用户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 110 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '文件上传记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_upload_files_log
-- ----------------------------

-- ----------------------------
-- Table structure for bs_verify_code_log
-- ----------------------------
DROP TABLE IF EXISTS `bs_verify_code_log`;
CREATE TABLE `bs_verify_code_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '账户，邮箱或者手机号',
  `code` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '验证码',
  `add_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发送时间',
  `type` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0-手机，1-邮箱',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '验证码发送记录' ROW_FORMAT = Dynamic;

-- 个推cid关联表
DROP TABLE IF EXISTS `bs_getui_cid`;
CREATE TABLE `bs_getui_cid` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) NOT NULL DEFAULT '' COMMENT '用户uid',
  `cid` varchar(50) NOT NULL DEFAULT '' COMMENT '个推（uni push）CID',
  `uid_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '用户类型，1-普通用户，2-商家，3-后台管理',
  `up_time` int(10) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='个推信息关联表';

-- 更新相关
ALTER TABLE `bs_goods`
ADD COLUMN `banner2detail` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否将banner同步到detail' AFTER `store_num`;

ALTER TABLE `bs_goods`
ADD COLUMN `is_del` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否在回收站' ;
DROP TABLE IF EXISTS `bs_version`;
CREATE TABLE `bs_version` (
  `app_version` int(10) DEFAULT '0' COMMENT 'app版本',
  `sql_version` int(10) DEFAULT '0' COMMENT 'sql结构版本',
  `file_version` int(10) DEFAULT '0' COMMENT '文件版本'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `bs_withdraw_log`;
CREATE TABLE `bs_withdraw_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) NOT NULL DEFAULT '',
  `uid_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '用户类型，1-普通用户，2-商家',
  `order_no` varchar(32) NOT NULL DEFAULT '' COMMENT '申请单号',
  `num` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '申请金额',
  `fee` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '手续费',
  `add_time` int(10) NOT NULL DEFAULT '0' COMMENT '申请时间',
  `up_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0-待审核，1-已通过，-1-已驳回',
  `fail_text` varchar(500) NOT NULL DEFAULT '' COMMENT '驳回原因',
  `username` varchar(32) NOT NULL DEFAULT '' COMMENT '真实姓名',
  `to_account` varchar(64) NOT NULL DEFAULT '' COMMENT '提现账户，如支付宝账号、手机号、银行卡号等',
  `to_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '提现方式：1-支付宝，2-微信，3-银行卡',
  `imgs` varchar(1000) DEFAULT '' COMMENT '转账凭证，由后台上传',
  PRIMARY KEY (`id`),
  KEY `idx_uid_type` (`uid`,`uid_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='提现申请记录';
SET FOREIGN_KEY_CHECKS = 1;
