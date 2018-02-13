<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/mui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/jquery-2.1.0.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/angular.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/config.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/exif.js"></script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>

<script>
    /**加载loading**/
    $(document).ready(function(){
        $("body").append(CC.showLoading("请稍后..."));
    });
    /**加载完成关闭**/
    window.onload = function () {
        CC.hideLoading();
    }
    console.log('%c欢迎使用爱麦安培', 'background-image:-webkit-gradient( linear, left top, right top, color-stop(0, #f22), color-stop(0.15, #f2f), color-stop(0.3, #22f), color-stop(0.45, #2ff), color-stop(0.6, #2f2),color-stop(0.75, #2f2), color-stop(0.9, #ff2), color-stop(1, #f22) );color:transparent;-webkit-background-clip: text;font-size:5em;');
    CC.print("************************登录人信息**********************");
    CC.print(CC.getUserInfo());
    CC.print("************************登录人信息**********************");
    if (CC.getUserInfo() != null) {
        if (CC.getUserInfo().roleId == 3) $(".studyJurisdiction").attr("href", CC.ip + "page/studyCompany/study");
        if (CC.getUserInfo().roleId == 2)  $(".studyJurisdiction").attr("href", CC.ip + "page/studyGovernment/study");
    }

    var bannerInfo = "page/app/bannerInfo",
            newsInfo = "page/app/newsInfo",
            bannerInfo2 = "page/bannerInfo",
            newsInfo2 = "page/newsInfo",
            aboutUs = "aboutUs",
            aptitude = "aptitude",
            polling = "polling",
            branch = "branch",
            download = "page/app/download",
            agreement = "page/app/agreement";
    var href = location.href;
    if (!CC.isDebug) {
        if (href.indexOf(bannerInfo) != -1
                || href.indexOf(newsInfo) != -1
                || href.indexOf(bannerInfo2) != -1
                || href.indexOf(newsInfo2) != -1
                || href.indexOf(aboutUs) != -1
                || href.indexOf(aptitude) != -1
                || href.indexOf(polling) != -1
                || href.indexOf(branch) != -1
                || href.indexOf(download) != -1
                || href.indexOf(agreement) != -1) {
            //TODO 不做任何处理
        }
        else {
            // 对浏览器的UserAgent进行正则匹配，不含有微信独有标识的则为其他浏览器
            var useragent = navigator.userAgent;
            if (useragent.match(/MicroMessenger/i) != 'MicroMessenger') {
                // 这里警告框会阻塞当前页面继续加载
                alert('已禁止本次访问：您必须使用微信内置浏览器访问本页面！');
                $("body").html("<div class='warning'>已禁止本次访问：<br>您必须使用微信内置浏览器访问本页面！<div/>");
            }
            else {
                var jsSignList = CC.getWxJsSign(); //微信api签名
                wx.config({
                    debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
                    appId: jsSignList.appId, // 必填，公众号的唯一标识
                    timestamp: jsSignList.timestamp, // 必填，生成签名的时间戳
                    nonceStr: jsSignList.noncestr, // 必填，生成签名的随机串
                    signature: jsSignList.signature,// 必填，签名，见附录1
                    jsApiList: ["hideOptionMenu"] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
                });
                wx.ready(function() {
                    wx.hideOptionMenu();
                });
            }
        }
    }

</script>
