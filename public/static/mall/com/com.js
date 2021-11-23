function bs_request(url,data,callback,type) {
    $.ajax({
        url:url,
        async:false,
        dataType:'json',
        data:data,
        type:type?type:'post',
        beforeSend:function () {

        },
        success:function (res) {
            if (res.code == '4003' && res.data.login_url ){
                return location.href = res.data.login_url;
            }
            if (typeof callback =='function'){
                callback(res)
            }
        },
        error:function () {
            if (typeof callback =='function'){
                callback()
            }
        }
    })
}
//获取参数
function bs_get_param(name) {
    // 获取参数
    var url = window.location.search;
    // 正则筛选地址栏
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
    // 匹配目标参数
    var result = url.substr(1).match(reg);
    //返回参数值
    return result ? decodeURIComponent(result[2]) : null;
}