ALTER TABLE `bs_order`
ADD COLUMN `content_virtual` varchar(1000) NULL DEFAULT '' COMMENT '虚拟商品发货信息' AFTER `code_tihuo`,
ADD COLUMN `tihuo_address` varchar(128) NOT NULL DEFAULT '' COMMENT '提货地址' AFTER `content_virtual`;