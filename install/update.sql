ALTER TABLE `bs_order`
ADD COLUMN `content_virtual` varchar(1000) NULL DEFAULT '' COMMENT '虚拟商品发货信息' AFTER `code_tihuo`,
ADD COLUMN `tihuo_address` varchar(128) NOT NULL DEFAULT '' COMMENT '提货地址' AFTER `content_virtual`;

ALTER TABLE `bs_order`
ADD COLUMN `ip_address` varchar(20) NOT NULL DEFAULT '' COMMENT '下单IP地址' AFTER `tihuo_address`;



CREATE TABLE `bs_article_sys` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '文章标题',
  `content` text COMMENT '文章内容',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0',
  `up_time` int(10) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '1-展示中，0-已下线',
  `count_view` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '浏览量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='系统文章内容';