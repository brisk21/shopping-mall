/*
 Navicat Premium Data Transfer

 Source Server         : 本地
 Source Server Type    : MySQL
 Source Server Version : 50726
 Source Host           : localhost:3306
 Source Schema         : bs_shop

 Target Server Type    : MySQL
 Target Server Version : 50726
 File Encoding         : 65001

 Date: 16/11/2021 21:35:12
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_article
-- ----------------------------
INSERT INTO `bs_article` VALUES (1, '这个是好商城，第一个开发的连续版本', '这是文章内容', 1634972484, 1634972484, 1, 0);
INSERT INTO `bs_article` VALUES (2, '写一个连续的就业班教程', '这是文章内容这是文章内容这是文章内容这是文章内容这是文章内容这是文章内容这是文章内容这是文章内容', 1634972484, 1634972484, 1, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_banner
-- ----------------------------
INSERT INTO `bs_banner` VALUES (1, '', 0, 'http://blog.wei1.top', '/static/mall/upload/ban1.jpg', 1634822944, 1667478091);
INSERT INTO `bs_banner` VALUES (2, '', 0, 'http://blog.wei1.top', '/static/mall/upload/ban2.jpg', 1634822944, 1667478091);
INSERT INTO `bs_banner` VALUES (3, '', 0, 'http://blog.wei1.top', '/static/mall/upload/ban3.jpg', 1634822944, 1667478091);
INSERT INTO `bs_banner` VALUES (4, '', 0, 'http://blog.wei1.top', '/static/mall/upload/ban4.jpg', 1634822944, 1667478091);

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
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_cart
-- ----------------------------
INSERT INTO `bs_cart` VALUES (1, 1, 'bs76eb38dc7a8550b10d506b157e17d50f', 7, 0, 0, '');
INSERT INTO `bs_cart` VALUES (2, 2, 'bs76eb38dc7a8550b10d506b157e17d50f', 1, 0, 0, '');
INSERT INTO `bs_cart` VALUES (3, 3, 'bs76eb38dc7a8550b10d506b157e17d50f', 2, 0, 0, '');
INSERT INTO `bs_cart` VALUES (5, 5, 'bs76eb38dc7a8550b10d506b157e17d50f', 11, 0, 0, '');
INSERT INTO `bs_cart` VALUES (6, 6, 'bs76eb38dc7a8550b10d506b157e17d50f', 4, 0, 0, '');
INSERT INTO `bs_cart` VALUES (7, 7, 'bs76eb38dc7a8550b10d506b157e17d50f', 3, 0, 0, '');
INSERT INTO `bs_cart` VALUES (10, 10, 'bs76eb38dc7a8550b10d506b157e17d50f', 5, 0, 0, '');
INSERT INTO `bs_cart` VALUES (11, 11, 'bs76eb38dc7a8550b10d506b157e17d50f', 7, 0, 0, '');
INSERT INTO `bs_cart` VALUES (12, 12, 'bs76eb38dc7a8550b10d506b157e17d50f', 26, 0, 0, '');
INSERT INTO `bs_cart` VALUES (15, 34, 'bs76eb38dc7a8550b10d506b157e17d50f', 2, 0, 0, '');
INSERT INTO `bs_cart` VALUES (16, 29, 'bs76eb38dc7a8550b10d506b157e17d50f', 5, 0, 1, '');
INSERT INTO `bs_cart` VALUES (17, 33, 'bs76eb38dc7a8550b10d506b157e17d50f', 3, 0, 1, '');
INSERT INTO `bs_cart` VALUES (18, 27, 'bs76eb38dc7a8550b10d506b157e17d50f', 1, 0, 1, '');

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
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_common_user
-- ----------------------------
INSERT INTO `bs_common_user` VALUES (1, '111111', 'bs733157b19192e324bfe233c24681405c', 'a0e65f4e970671082a5debd2fa215cf2', 'CMkmD1UzhK', 1634648764, 1634648764, 0, 0, 0);
INSERT INTO `bs_common_user` VALUES (2, '11111123', 'bsc2473f191fd7e7f3a968a79716918d95', '008d5e9044558fd373bc53fc8de06514', 'SUf6702717', 1634648802, 1634648802, 0, 0, 0);
INSERT INTO `bs_common_user` VALUES (3, '123', 'bsfe10d8261cd91c481836e719ae029523', '47ac84662499a3057a9599d8d3cc8b52', 'XiVeYyy2vt', 1634649110, 1634649110, 0, 0, 0);
INSERT INTO `bs_common_user` VALUES (4, '1233', 'bs76eb38dc7a8550b10d506b157e17d50f', '0110856c49ae7d6bca7a74b31abc4687', 'ArNKc81tz4', 1634649253, 1634742053, 0, 0, 4);
INSERT INTO `bs_common_user` VALUES (5, '123444', 'bsa40cacbacff185623046cdcdca12ca18', 'aa85e883a45d0215565ee0812860bfd4', 'rtJyhFc89C', 1634821627, 1634821627, 0, 0, 0);
INSERT INTO `bs_common_user` VALUES (6, '111112', 'bs8999e7a62f733fe434b7109f26358fd0', '400afe5b77f487c40457bcc34eb8cac5', 'xWwgtmgEZ4', 1634821668, 1634821668, 0, 0, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_common_user_address
-- ----------------------------
INSERT INTO `bs_common_user_address` VALUES (2, 'bs76eb38dc7a8550b10d506b157e17d50f', '湖南省', '衡阳市', '珠晖区', '', '未知楼x2号', 0, '135000000001', '小唯');
INSERT INTO `bs_common_user_address` VALUES (3, 'bs76eb38dc7a8550b10d506b157e17d50f', '广东省', '广州市', '白云区', '白云街道', '未知楼3号', 0, '135000000001', '小唯');
INSERT INTO `bs_common_user_address` VALUES (5, 'bs76eb38dc7a8550b10d506b157e17d50f', '广东省', '广州市', '白云区', '', '未知楼33号', 1, '135000000007', '小唯');
INSERT INTO `bs_common_user_address` VALUES (6, 'bs76eb38dc7a8550b10d506b157e17d50f', '广东省', '广州市', '白云区', '', '未知楼444号', 0, '135000000006', '小唯');
INSERT INTO `bs_common_user_address` VALUES (7, 'bs76eb38dc7a8550b10d506b157e17d50f', '广东省', '广州市', '白云区', '白云街道', '未知楼x34x号', 0, '135000000001', '小唯');

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
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_common_user_login_log
-- ----------------------------
INSERT INTO `bs_common_user_login_log` VALUES (1, 'bs76eb38dc7a8550b10d506b157e17d50f', 1634742560, '2130706433');
INSERT INTO `bs_common_user_login_log` VALUES (2, 'bs76eb38dc7a8550b10d506b157e17d50f', 1634742586, '2130706433');
INSERT INTO `bs_common_user_login_log` VALUES (3, 'bs76eb38dc7a8550b10d506b157e17d50f', 1634742807, '2130706433');
INSERT INTO `bs_common_user_login_log` VALUES (4, 'bs76eb38dc7a8550b10d506b157e17d50f', 1634743043, '2130706433');
INSERT INTO `bs_common_user_login_log` VALUES (5, 'bs76eb38dc7a8550b10d506b157e17d50f', 1634743082, '2130706433');
INSERT INTO `bs_common_user_login_log` VALUES (6, 'bs76eb38dc7a8550b10d506b157e17d50f', 1634743122, '2130706433');

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
  `stock_locked` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '锁库数量',
  `sale` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '销量',
  `add_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '新增时间',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0-仓库中，1-已上架',
  `banners` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '轮播图列表',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '详情',
  `is_top` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否为推荐商品，1-已推荐',
  `category_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '分类编号',
  `store_num` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '店铺唯一标识',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_goods
-- ----------------------------
INSERT INTO `bs_goods` VALUES (1, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2020-11-17/30d4f9f5d66468335f51eff17d4c82bf.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 1, 3, '123456');
INSERT INTO `bs_goods` VALUES (2, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://img.pddpic.com/mms-material-img/2021-07-18/bef8982b-75f7-47b5-92e2-063245d3dc17.jpeg.a.jpeg', 130.00, 39.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 0, 3, '123456');
INSERT INTO `bs_goods` VALUES (3, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://img.pddpic.com/gaudit-image/2021-11-04/20f227ac6613d1ae7ffe136611850151.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 1, 3, '123456');
INSERT INTO `bs_goods` VALUES (4, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2020-08-24/0f8198246047d5fdab62ce6976754c25.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 1, 3, '123456');
INSERT INTO `bs_goods` VALUES (5, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2021-07-01/95b2b6cb95ce6ebfee002441547825a6.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 1, 3, '123456');
INSERT INTO `bs_goods` VALUES (6, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2020-04-21/7e22ba845f908c4a497de1bdb7eda4aa.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 1, 3, '123456');
INSERT INTO `bs_goods` VALUES (7, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2020-09-25/e296844dba227b179e50c76e03504cd6.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 1, 3, '123456');
INSERT INTO `bs_goods` VALUES (8, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2018-11-25/414997bc5c5431df778d65f16c2c5d0c.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 1, 3, '123456');
INSERT INTO `bs_goods` VALUES (9, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2019-06-17/671cd9c61e9fe2e65757632fb4c5dd92.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 1, 3, '123456');
INSERT INTO `bs_goods` VALUES (10, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://img.pddpic.com/mms-material-img/2021-07-18/bef8982b-75f7-47b5-92e2-063245d3dc17.jpeg.a.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 1, 3, '123456');
INSERT INTO `bs_goods` VALUES (11, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2021-03-04/714ab7af13107654aa573660fb0c45e6.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 1, 3, '123456');
INSERT INTO `bs_goods` VALUES (12, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2021-06-19/32ac2beffc807d6bfd41cb224ce7b68c.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 1, 3, '123456');
INSERT INTO `bs_goods` VALUES (13, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://img.pddpic.com/gaudit-image/2021-10-12/9738f9c22ae2c064a5ae8a41f941db2d.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 1, 3, '123456');
INSERT INTO `bs_goods` VALUES (14, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2020-11-17/30d4f9f5d66468335f51eff17d4c82bf.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 1, 3, '123456');
INSERT INTO `bs_goods` VALUES (15, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://img.pddpic.com/mms-material-img/2021-07-18/bef8982b-75f7-47b5-92e2-063245d3dc17.jpeg.a.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 1, 3, '123456');
INSERT INTO `bs_goods` VALUES (16, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://img.pddpic.com/gaudit-image/2021-11-04/20f227ac6613d1ae7ffe136611850151.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 1, 3, '123456');
INSERT INTO `bs_goods` VALUES (17, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2020-08-24/0f8198246047d5fdab62ce6976754c25.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 1, 3, '123456');
INSERT INTO `bs_goods` VALUES (18, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2021-07-01/95b2b6cb95ce6ebfee002441547825a6.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 0, 3, '123456');
INSERT INTO `bs_goods` VALUES (19, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2020-04-21/7e22ba845f908c4a497de1bdb7eda4aa.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 0, 3, '123456');
INSERT INTO `bs_goods` VALUES (20, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2020-09-25/e296844dba227b179e50c76e03504cd6.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 0, 3, '123456');
INSERT INTO `bs_goods` VALUES (21, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2018-11-25/414997bc5c5431df778d65f16c2c5d0c.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 0, 3, '123456');
INSERT INTO `bs_goods` VALUES (22, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2019-06-17/671cd9c61e9fe2e65757632fb4c5dd92.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 0, 3, '123456');
INSERT INTO `bs_goods` VALUES (23, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://img.pddpic.com/mms-material-img/2021-07-18/bef8982b-75f7-47b5-92e2-063245d3dc17.jpeg.a.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 0, 9, '123456');
INSERT INTO `bs_goods` VALUES (24, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2021-03-04/714ab7af13107654aa573660fb0c45e6.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 0, 4, '123456');
INSERT INTO `bs_goods` VALUES (25, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2021-06-19/32ac2beffc807d6bfd41cb224ce7b68c.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 0, 4, '123456');
INSERT INTO `bs_goods` VALUES (26, '我是小叮当，哈哈哈哈哈哈', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://img.pddpic.com/gaudit-image/2021-10-12/9738f9c22ae2c064a5ae8a41f941db2d.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 0, 4, '123456');
INSERT INTO `bs_goods` VALUES (27, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2020-11-17/30d4f9f5d66468335f51eff17d4c82bf.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 0, 4, '123456');
INSERT INTO `bs_goods` VALUES (28, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://img.pddpic.com/mms-material-img/2021-07-18/bef8982b-75f7-47b5-92e2-063245d3dc17.jpeg.a.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 0, 4, '123456');
INSERT INTO `bs_goods` VALUES (29, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://img.pddpic.com/gaudit-image/2021-11-04/20f227ac6613d1ae7ffe136611850151.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 0, 4, '123456');
INSERT INTO `bs_goods` VALUES (30, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2020-08-24/0f8198246047d5fdab62ce6976754c25.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 0, 4, '123456');
INSERT INTO `bs_goods` VALUES (31, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2021-07-01/95b2b6cb95ce6ebfee002441547825a6.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 0, 5, '123456');
INSERT INTO `bs_goods` VALUES (32, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2020-04-21/7e22ba845f908c4a497de1bdb7eda4aa.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 0, 5, '123456');
INSERT INTO `bs_goods` VALUES (33, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2020-09-25/e296844dba227b179e50c76e03504cd6.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 0, 5, '123456');
INSERT INTO `bs_goods` VALUES (34, '洋河蓝色瓶装经典Q7浓香型白酒500ml52度高端纯粮食白酒2瓶装包邮', '【2017春季全场2件8】春款薄绒休闲套头纯色印花连帽大码卫衣套装新款上新！！', 'https://t00img.yangkeduo.com/goods/images/2018-11-25/414997bc5c5431df778d65f16c2c5d0c.jpeg', 100.00, 29.00, 100, 0, 0, 0, 1, '[\r\n    \"http://shop.test.top/static/mall/upload/zhutu01.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu02.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu03.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu04.jpg\",\r\n    \"http://shop.test.top/static/mall/upload/zhutu05.jpg\"\r\n]', ' <img src=\"/static/mall/upload/xq1.jpg\"><img src=\"/static/mall/upload/xq2.jpg\"><img src=\"/static/mall/upload/xq3.jpg\"><img src=\"/static/mall/upload/xq4.jpg\"><img src=\"/static/mall/upload/xq5.jpg\"><img src=\"/static/mall/upload/xq6.jpg\"><img src=\"/static/mall/upload/xq7.jpg\"><img src=\"/static/mall/upload/xq8.jpg\"><img src=\"/static/mall/upload/xq9.jpg\">', 0, 5, '123456');

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
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

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

-- ----------------------------
-- Table structure for bs_goods_favorite
-- ----------------------------
DROP TABLE IF EXISTS `bs_goods_favorite`;
CREATE TABLE `bs_goods_favorite`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `goods_id` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `uid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '收藏用户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_goods_favorite
-- ----------------------------
INSERT INTO `bs_goods_favorite` VALUES (1, 1, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (2, 2, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (3, 3, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (4, 4, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (5, 5, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (6, 6, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (7, 7, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (8, 8, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (9, 9, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (10, 10, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (11, 11, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (12, 12, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (13, 13, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (14, 14, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (15, 15, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (17, 17, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (18, 18, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (19, 19, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (20, 20, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (21, 21, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (22, 22, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (23, 23, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (24, 24, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (25, 25, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (26, 26, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (27, 27, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (28, 28, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (30, 30, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (31, 31, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (32, 32, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (33, 33, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (35, 16, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (36, 34, 'bs76eb38dc7a8550b10d506b157e17d50f');
INSERT INTO `bs_goods_favorite` VALUES (37, 29, 'bs76eb38dc7a8550b10d506b157e17d50f');

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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_navs
-- ----------------------------
INSERT INTO `bs_navs` VALUES (1, '超级红包', 0, 'http://blog.wei1.top', '/static/mall/images/icon-link1.png', 1634822944, 1667478091);
INSERT INTO `bs_navs` VALUES (2, '酒水饮料', 0, 'http://blog.wei1.top', '/static/mall/images/icon-link2.png', 1634822944, 1667478091);
INSERT INTO `bs_navs` VALUES (3, '我的订单', 0, 'http://blog.wei1.top', '/static/mall/images/icon-link3.png', 1634822944, 1667478091);
INSERT INTO `bs_navs` VALUES (4, '个人主页', 0, 'http://blog.wei1.top', '/static/mall/images/icon-link4.png', 1634822944, 1667478091);

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
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bs_stores
-- ----------------------------
INSERT INTO `bs_stores` VALUES (1, '小唯店铺', '123456', 0, 0, 1, 1);

SET FOREIGN_KEY_CHECKS = 1;


CREATE TABLE `bs_order` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_sn` varchar(32) NOT NULL DEFAULT '' COMMENT '订单编号',
  `uid` varchar(50) NOT NULL DEFAULT '' COMMENT '用户标识',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '-1-已取消，0-待支付，1-已支付，2-待收货，3-已完，-2-已退款',
  `price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '订单金额',
  `pay_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '实付金额',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `up_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `send_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '发货时间',
  `pay_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '支付时间',
  `trans_id` varchar(50) NOT NULL DEFAULT '' COMMENT '交易号',
  `address` varchar(500) NOT NULL DEFAULT '' COMMENT '地址信息',
  `cancel_pay_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '超时支付截止时间',
  `store_num` varchar(20) NOT NULL DEFAULT '' COMMENT '门店编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

CREATE TABLE `bs_order_goods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_sn` varchar(32) NOT NULL DEFAULT '' COMMENT '订单编号',
  `goods_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '商品编号',
  `thumb` varchar(300) NOT NULL DEFAULT '' COMMENT '商品缩略图',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '商品标题',
  `price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '商品单价',
  `count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '购买数量',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COMMENT='订单商品';