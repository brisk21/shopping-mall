
function bs_request(url, data, callback, type) {

    var token = localStorage.getItem('user_token');
    $.ajax({
        url: url,
        async: true,
        dataType: 'json',
        data: data,
        type: type ? type : 'post',
        headers: {
            'BSTOKEN': token
        },
        beforeSend: function (request) {
            //或者这里设置请求头
            // request.setRequestHeader('BS-TOKEN', ocalStorage.getItem('user_token'));

        },
        success: function (res) {
            if (res.code === 401 && res.data.login_url) {
                return location.href = res.data.login_url;
            }
            if (typeof callback == 'function') {
                callback(res)
            }

        },
        complete: function (res) {

        },
        error: function () {
            if (typeof callback == 'function') {
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

/**
 * 复制内容
 * @param obj 复制的对象，如this
 * @param className 根据类查询
 * @param expire 毫秒
 */
function copy(obj,className,expire) {

    if (!expire){
        expire = 1000;
    }
    const range = document.createRange();
    const selection = window.getSelection();
    if (className && className !=='undefined'){
        range.selectNode(document.getElementsByClassName(className)[0]);//需要复制的内容,需要的是range
    }else {
        range.selectNode(obj); //需要复制的内容
    }
    if (selection.rangeCount > 0) selection.removeAllRanges();
    selection.addRange(range);
    document.execCommand('copy');

    var bsClassName = 'bs-alert-copy';
    var p= document.createElement('p');
    p.className = bsClassName;
    p.innerHTML = '<p class="" style="position: fixed; top: 30%;left: 45%; text-align: center; vertical-align: middle; background: #0000006e;color: white; padding: 10px;border-radius: 2px;">复制成功</p>';
    document.getElementsByTagName('body')[0].append(p);
    var node = document.getElementsByClassName(bsClassName)[0]
    setTimeout(function () {
        document.getElementsByTagName('body')[0].removeChild(node)
    },expire)

}