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
) ENGINE = InnoDB AUTO_INCREMENT = 551 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员操作日志' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 124 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 145 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '后台管理菜单' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '后台管理的消息' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 97 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

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
  `openid_wx` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '微信公众号openid',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_uid_status`(`uid`, `status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 110 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 57625 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 246 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户余额交易流水表' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 106 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户账户表' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 175 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 113 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户消息记录' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 105 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户积分流水表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bs_config
-- ----------------------------
DROP TABLE IF EXISTS `bs_config`;
CREATE TABLE `bs_config`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '配置标识',
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '配置内容',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bs_error_log
-- ----------------------------
DROP TABLE IF EXISTS `bs_error_log`;
CREATE TABLE `bs_error_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `add_time` int(10) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1201 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '异常日志' ROW_FORMAT = Dynamic;

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
CREATE TABLE `bs_goods`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标题',
  `goods_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '简单描述',
  `thumb` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '封面图',
  `market_price` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '市场价',
  `price` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '销售价',
  `stock` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '库存',
  `stock_locked` int(10) NOT NULL DEFAULT 0 COMMENT '锁库数量',
  `sale` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '销量',
  `add_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '新增时间',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0-仓库中，1-已上架',
  `banners` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '轮播图列表',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '详情',
  `is_top` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否为推荐商品，1-已推荐',
  `category_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '分类编号',
  `store_num` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '店铺唯一标识',
  `banner2detail` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否将banner同步到detail',
  `is_del` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否在回收站',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1003 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

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
-- Table structure for bs_goods_favorite
-- ----------------------------
DROP TABLE IF EXISTS `bs_goods_favorite`;
CREATE TABLE `bs_goods_favorite`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `goods_id` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `uid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '收藏用户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 57 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 14831 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 14802 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单商品' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户充值订单' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单售后申请' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 136 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 111 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '文件上传记录' ROW_FORMAT = Dynamic;

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

-- ----------------------------
-- Table structure for bs_version
-- ----------------------------
DROP TABLE IF EXISTS `bs_version`;
CREATE TABLE `bs_version`  (
  `app_version` int(10) NULL DEFAULT 0 COMMENT 'app版本',
  `sql_version` int(10) NULL DEFAULT 0 COMMENT 'sql结构版本',
  `file_version` int(10) NULL DEFAULT 0 COMMENT '文件版本'
) ENGINE = MyISAM CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Fixed;

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
