# thinkphp5购物商城

#### 介绍
用tp5开发一个购物商城，从简单到复杂，商品、搜索、购物车、订单、收藏、充值、交易记录等。

###### 在线体验(注册自动有1000体验余额): [http://demo.bs.shop.wei1.top/](http://demo.bs.shop.wei1.top/) 


###### 运行效果

![alt 用户中心](./public/test/user.png "用户中心")
![alt 购物车](./public/test/cart.png "购物车")

![alt 订单确认](./public/test/order_ready1.png "订单确认")
![alt 订单确认](./public/test/order_ready2.png "订单确认")
![alt 订单](./public/test/orders.png "订单")

![alt 首页](./public/test/home1.png "首页")
![alt 搜索列表](./public/test/pro-list.png "搜索列表")
![alt 地址列表](./public/test/address.png "地址列表")






#### 软件架构
基于thinkphp5开发，环境可以用lnmp或者lamp

#### 安装教程

1. 下载源码

   github：<a href="https://github.com/brisk21/shopping-mall">https://github.com/brisk21/shopping-mall</a>
   
   gitee：<a href="https://gitee.com/brisklan/thinkphp5-shopping-mall">https://gitee.com/brisklan/thinkphp5-shopping-mall</a>

2. 解压源码

3. 虚拟域名指向public（宝塔需要将运行目录指向public）

4. 创建数据库，导入sql（config下面的bs_shop.sql)数据

5. 访问域名（xxxx.com）访问

6.  伪静态设置（参考thinkphp）,下面是nginx配置：
```nginx
location / { 
   if (!-e $request_filename) {
   rewrite  ^(.*)$  /index.php?s=/$1  last;
   break;
    }
 }
```



#### 使用说明

1.  适用单商户
2.  支持购物车
3.  支持批量下单
4.  支持商品收藏、交易等




#### 特技

1. 用简单的方式实现一个thinkphp
2. 基于js编写前端逻辑，后期可以自己改成vue等，目前是前后分离模式

#### 交流群
群2（过期请加微信交流：wei1-top）：
![微信交流群②](https://images.gitee.com/uploads/images/2021/1122/173006_82afd9c6_2065616.png "微信交流群②")


###### 基于这个开发的一个返利版（建议在微信下直接授权登录）：[返利版demo](https://wx.wei1.top/union/store.user/index.html)
这是MVC模式，已上线使用。

![返利版demo](https://images.gitee.com/uploads/images/2021/1123/142916_e316c296_2065616.png "微信截图_20211123142709.png")
