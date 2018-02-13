
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title id="title">新闻详情</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/index/newsInfo.css">
    <style>
        /*图片预览css*/
        .mui-preview-image.mui-fullscreen {
            position: fixed;
            z-index: 1001;
            background-color: #000;
        }
        .mui-preview-header,
        .mui-preview-footer {
            position: absolute;
            width: 100%;
            left: 0;
            z-index: 10;
        }
        .mui-preview-header {
            height: 44px;
            top: 0;
        }
        .mui-preview-footer {
            height: 50px;
            bottom: 0px;
        }
        .mui-preview-header .mui-preview-indicator {
            display: block;
            line-height: 25px;
            color: #fff;
            text-align: center;
            margin: 15px auto 4px !important;
            background-color: rgba(0, 0, 0, 0.4);
            border-radius: 12px;
            font-size: 16px;
        }
        .mui-preview-image {
            display: none;
            -webkit-animation-duration: 0.5s;
            animation-duration: 0.5s;
            -webkit-animation-fill-mode: both;
            animation-fill-mode: both;
        }
        .mui-preview-image.mui-preview-in {
            -webkit-animation-name: fadeIn;
            animation-name: fadeIn;
        }
        .mui-preview-image.mui-preview-out {
            background: none;
            -webkit-animation-name: fadeOut;
            animation-name: fadeOut;
        }
        .mui-preview-image.mui-preview-out .mui-preview-header,
        .mui-preview-image.mui-preview-out .mui-preview-footer {
            display: none;
        }
        .mui-zoom-scroller {
            position: absolute;
            display: -webkit-box;
            display: -webkit-flex;
            display: flex;
            -webkit-box-align: center;
            -webkit-align-items: center;
            align-items: center;
            -webkit-box-pack: center;
            -webkit-justify-content: center;
            justify-content: center;
            left: 0;
            right: 0;
            bottom: 0;
            top: 0;
            width: 100%;
            height: 100%;
            margin: 0;
            -webkit-backface-visibility: hidden;
        }
        .mui-zoom {
            -webkit-transform-style: preserve-3d;
            transform-style: preserve-3d;
        }
        #page3 .mui-slider .mui-slider-group .mui-slider-item img {
            width: auto;
            height: auto;
            max-width: 100%;
            max-height: 100%;
        }
        .mui-android-4-1 .mui-slider .mui-slider-group .mui-slider-item img {
            width: 100%;
        }
        .mui-android-4-1 .mui-slider.mui-preview-image .mui-slider-group .mui-slider-item {
            display: inline-table;
        }
        .mui-android-4-1 .mui-slider.mui-preview-image .mui-zoom-scroller img {
            display: table-cell;
            vertical-align: middle;
        }
        .mui-preview-loading {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            display: none;
        }
        .mui-preview-loading.mui-active {
            display: block;
        }
        .mui-preview-loading .mui-spinner-white {
            position: absolute;
            top: 50%;
            left: 50%;
            margin-left: -25px;
            margin-top: -25px;
            height: 50px;
            width: 50px;
        }
        .mui-preview-image img.mui-transitioning {
            -webkit-transition: -webkit-transform 0.5s ease, opacity 0.5s ease;
            transition: transform 0.5s ease, opacity 0.5s ease;
        }
        @-webkit-keyframes fadeIn {
            0% {
                opacity: 0;
            }
            100% {
                opacity: 1;
            }
        }
        @keyframes fadeIn {
            0% {
                opacity: 0;
            }
            100% {
                opacity: 1;
            }
        }
        @-webkit-keyframes fadeOut {
            0% {
                opacity: 1;
            }
            100% {
                opacity: 0;
            }
        }
        @keyframes fadeOut {
            0% {
                opacity: 1;
            }
            100% {
                opacity: 0;
            }
        }
        p img {
            max-width: 100%;
            height: auto;
        }
    </style>
</head>
<body ng-app="webApp" ng-controller="newController" ng-cloak>
<div class="content">
    <div class="title">{{news.title}}</div>
    <div class="hint">
        <span class="time">{{news.createTime | date:'MM-dd   HH:mm'}}</span>
        <span class="source">{{news.source}}</span>
        <span class="editor">{{news.editor}}</span>
        <span class="share-img">
            <a ng-click="collect()" ng-if="isCollect == 0"><img src="<%=request.getContextPath()%>/resources/img/index/10.png" ></a>
            <a ng-if="isCollect == 1"><img src="<%=request.getContextPath()%>/resources/img/index/12.png" ></a>
            <a ng-click="share()"><img src="<%=request.getContextPath()%>/resources/img/index/9.png" ></a>
        </span>
    </div>
    <div id="content" class="context" ng-bind-html="news.content | trustHtml"></div>
</div>

<!-- 分享弹窗 -->
<div id="sharePicture" class="mui-popover mui-popover-action mui-popover-bottom">
    <ul class="mui-table-view">
        <li class="mui-table-view-cell">
            <div class="popover-title">
                <div>分享到</div>
            </div>
            <div class="mui-row">
                <div class="mui-col-xs-3 popover-tab">
                    <a ng-click="weChatFriend()">
                        <img src="<%=request.getContextPath()%>/resources/img/index/5.png">
                        <p>微信好友</p>
                    </a>
                </div>
                <div class="mui-col-xs-3 popover-tab">
                    <a ng-click="weChatFriends()">
                        <img src="<%=request.getContextPath()%>/resources/img/index/6.png">
                        <p>微信朋友圈</p>
                    </a>
                </div>
                <div class="mui-col-xs-3 popover-tab">
                    <a ng-click="qq()">
                        <img src="<%=request.getContextPath()%>/resources/img/index/7.png">
                        <p>QQ</p>
                    </a>
                </div>
                <div class="mui-col-xs-3 popover-tab">
                    <a ng-click="qqSpace()">
                        <img src="<%=request.getContextPath()%>/resources/img/index/8.png">
                        <p>QQ空间</p>
                    </a>
                </div>
            </div>
        </li>
    </ul>
</div>

<%@include file="../common/js.jsp" %>
<script src="<%=request.getContextPath()%>/resources/js/mui.zoom.js"></script>
<script src="<%=request.getContextPath()%>/resources/js/mui.previewimage.js"></script>

<script>
    mui.previewImage();//开启图片预览
    var useragent = navigator.userAgent;
    if (useragent.match(/MicroMessenger/i) == 'MicroMessenger') {
        var jsSignList = CC.getWxJsSign(); //微信api签名
        wx.config({
            debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
            appId: jsSignList.appId, // 必填，公众号的唯一标识
            timestamp: jsSignList.timestamp, // 必填，生成签名的时间戳
            nonceStr: jsSignList.noncestr, // 必填，生成签名的随机串
            signature: jsSignList.signature,// 必填，签名，见附录1
            jsApiList: ["showOptionMenu"] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
        });
        wx.ready(function() {
            wx.showOptionMenu();
        });
    }

    var webApp = angular.module('webApp', []);
    webApp.controller('newController', function($scope, $http, $timeout) {
        $scope.newsId = CC.getUrlParam("newsId");
        $scope.news = null;
        $scope.isCollect = 0; //是否已收藏
        CC.ajaxRequestData("post", false, "news/info", { id : $scope.newsId }, function (result) {
            $scope.news = result.data;
            $("#title").html($scope.news.title);
        });

        /**获取是否已经收藏**/
        CC.ajaxRequestData("post", false, "collect/isCollect", { type : 0, targetId : $scope.newsId }, function (result) {
            $scope.isCollect = result.data;
        });

        $(function () {
            $("#content").find("video").attr("controls", "controls");
            $("#content").find("img").attr("data-preview-src", "").attr("data-preview-group", 1);
            $("#content").find("img").each(function () {
                $(this).attr("src", "http://icloud.aimaiap.com/" + $(this).attr("_src"));
                $(this).attr("_src", "http://icloud.aimaiap.com/" + $(this).attr("_src"));
            });
            $("#content").find("video").each(function () {
                $(this).attr("src", "http://icloud.aimaiap.com/" + $(this).attr("src"));
            });
        });

        if (useragent.match(/MicroMessenger/i) == 'MicroMessenger') {
            var jsSignList = CC.getWxJsSign(); //微信api签名
            wx.config({
                debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
                appId: jsSignList.appId, // 必填，公众号的唯一标识
                timestamp: jsSignList.timestamp, // 必填，生成签名的时间戳
                nonceStr: jsSignList.noncestr, // 必填，生成签名的随机串
                signature: jsSignList.signature,// 必填，签名，见附录1
                jsApiList: ["onMenuShareTimeline", "onMenuShareAppMessage", "onMenuShareQQ", "onMenuShareQZone"] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
            });

            wx.ready(function(){

                //wx.hideOptionMenu();

                //微信好友
                wx.onMenuShareTimeline({
                    title: $scope.news.title, // 分享标题
                    desc: $scope.news.digest, // 分享描述
                    link: location.href, // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致
                    imgUrl: CC.ipImg + $scope.news.image, // 分享图标
                    type: '', // 分享类型,music、video或link，不填默认为link
                    dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
                    success: function () {
                        mui.toast("分享成功.");
                    },
                    cancel: function () {
                        mui.toast("取消.");
                    }
                });
                //微信朋友圈
                wx.onMenuShareAppMessage({
                    title: $scope.news.title, // 分享标题
                    desc: $scope.news.digest, // 分享描述
                    link: location.href, // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致
                    imgUrl: CC.ipImg + $scope.news.image, // 分享图标
                    type: '', // 分享类型,music、video或link，不填默认为link
                    dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
                    success: function () {
                        //mui.toast("分享成功.");
                    },
                    cancel: function () {}
                });
                //QQ
                wx.onMenuShareQQ({
                    title: $scope.news.title, // 分享标题
                    desc: $scope.news.digest, // 分享描述
                    link: location.href, // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致
                    imgUrl: CC.ipImg + $scope.news.image, // 分享图标
                    success: function () {
                        //mui.toast("分享成功.");
                    },
                    cancel: function () {
                    }
                });
                //QQ空间
                wx.onMenuShareQZone({
                    title: $scope.news.title, // 分享标题
                    desc: $scope.news.digest, // 分享描述
                    link: location.href, // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致
                    imgUrl: CC.ipImg + $scope.news.image, // 分享图标
                    success: function () {
                        //mui.toast("分享成功.");
                    },
                    cancel: function () {
                    }
                });

            });
        }

        //微信好友
        $scope.weChatFriend = function () {
            wx.ready(function(){
                wx.onMenuShareTimeline({
                    title: $scope.news.title, // 分享标题
                    desc: $scope.news.digest, // 分享描述
                    link: location.href, // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致
                    imgUrl: CC.ipImg + $scope.news.image, // 分享图标
                    type: '', // 分享类型,music、video或link，不填默认为link
                    dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
                    success: function () {
                        //mui.toast("分享成功.");
                    },
                    cancel: function () {
                    }
                });
            });
            wx.error(function(res){
                // config信息验证失败会执行error函数，如签名过期导致验证失败，具体错误信息可以打开config的debug模式查看，也可以在返回的res参数中查看，对于SPA可以在这里更新签名。
                alert("错误信息:"+JSON.stringify(res));
            });
        }

        //微信朋友圈
        $scope.weChatFriends = function () {

        }

        //QQ
        $scope.qq = function () {

        }

        //QQ空间
        $scope.qqSpace = function () {

        }

        //分享
        $scope.share = function () {
            //mui('#sharePicture').popover('toggle');
            mui.alert("请点击右上角三个点点分享.");
        }
        //收藏
        $scope.collect = function () {
            var parameter = {
                type : 0,
                targetId : $scope.newsId
            }
            CC.ajaxRequestData("post", false, "collect/addCollect", parameter, function (result) {
                $timeout(function () {
                    $scope.isCollect = 1;
                })
                mui.alert("收藏成功.");
            });
        }


    });
    //富文本过滤器
    webApp.filter('trustHtml', ['$sce',function($sce) {
        return function(val) {
            return $sce.trustAsHtml(val);
        };
    }]);

</script>

</body>
</html>
