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
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]); return null;
}