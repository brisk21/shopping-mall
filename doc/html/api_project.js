define({
  "name": "接口文档",
  "version": "1.0.0",
  "description": "BS-SHOP-APIDOC",
  "title": "bs_shop客户端接口文档",
  "url": "http://xxxxx.com",
  "header": {
    "title": "接口通用规则",
    "content": "<h2>API 调用规则</h2>\n<p>每次请求 API 接口时，均需要提供 http请求头headers，具体如下：</p>\n<table>\n<thead>\n<tr>\n<th>名称</th>\n<th>类型</th>\n<th>说明</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td><code>bs_token</code></td>\n<td>String</td>\n<td>登录获取的token，登录、注册接口或者无需登录接口可不填</td>\n</tr>\n</tbody>\n</table>\n<p>jq 的ajax实例：</p>\n<pre class=\"prettyprint lang-javascript\">$.ajax({\n        url:url,\n        async:false,\n        dataType:'json',\n        data:data,\n        type:type?type:'post',\n        headers: {\n            //本地登录缓存的token\n            'BSTOKEN': localStorage.getItem('user_token')\n        },\n        beforeSend:function (request) {\n            //或者这里设置请求头\n            // request.setRequestHeader('BSTOKEN', ocalStorage.getItem('user_token'));\n        },\n        success:function (res) {\n            //401需要重新登录\n            if (res.code == '401' && res.data.login_url ){\n                return location.href = res.data.login_url;\n            }\n            if (typeof callback =='function'){\n                callback(res)\n            }\n        },\n        error:function () {\n            if (typeof callback =='function'){\n                callback()\n            }\n        }\n    })\n</pre>\n"
  },
  "footer": {
    "title": "API 状态码说明",
    "content": "<h2>HTTP 状态码</h2>\n<table>\n<thead>\n<tr>\n<th>code</th>\n<th>描述</th>\n<th>说明</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>0</td>\n<td>提交成功</td>\n<td>msg提示成功消息</td>\n</tr>\n<tr>\n<td>-1</td>\n<td>提交异常</td>\n<td>具体看返回的msg信息</td>\n</tr>\n<tr>\n<td>401</td>\n<td>登录超时</td>\n<td>需要重新登录</td>\n</tr>\n<tr>\n<td>403</td>\n<td>无权操作</td>\n<td>具体看msg</td>\n</tr>\n</tbody>\n</table>\n"
  },
  "sampleUrl": false,
  "defaultVersion": "0.0.0",
  "apidoc": "0.3.0",
  "generator": {
    "name": "apidoc",
    "time": "2021-12-23T09:15:45.041Z",
    "url": "http://apidocjs.com",
    "version": "0.19.1"
  }
});
