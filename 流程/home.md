```mermaid
graph TD

home(首页板块)
banner(轮播)
navs(导航)
hot(热门)
category(推荐分类)
goods(猜你喜欢)
jump_url(跳转链接)
goods_detail(商品详情)
time_limit(时间限制)


home-->banner-->jump_url
banner-->time_limit
navs-->time_limit
home-->navs-->jump_url

home-->hot-->|商品列表| goods_detail
home-->category-->|商品列表| goods_detail
home-->goods-->|商品列表| goods_detail


```
## 流程图
![alt 首页基本流程功能图](home.png "首页功能")

