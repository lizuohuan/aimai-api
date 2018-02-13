
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>我的</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/my/my.css">
</head>
<body ng-app="webApp" ng-controller="myController" ng-cloak>

<div class="mui-content">
    <div id="myScroll" class="mui-content mui-scroll-wrapper">
        <div class="mui-scroll">
            <!-- 头像栏 -->
            <div class="head-bar">
                <div ng-click="isLogin('page/personInfo')"><img class="edit-img" src="<%=request.getContextPath()%>/resources/img/my/2.png" /></div>
                <div class="user-info">
                    <div class="border-wai">
                        <div class="border-nei">
                            <a href="<%=request.getContextPath()%>/page/login" ng-if="userInfo == null">
                                <img src="<%=request.getContextPath()%>/resources/img/my/11.png" />
                            </a>
                            <i class="head" ng-show="userInfo.avatar == null && userInfo != null" style="background: url('<%=request.getContextPath()%>/resources/img/my/11.png')"></i>
                            <i class="head" ng-show="userInfo.avatar != null" style="background: url('{{imgUrl}}{{userInfo.avatar}}') 100%"></i>
                        </div>
                    </div>
                    <a href="<%=request.getContextPath()%>/page/login" class="user-name" ng-if="userInfo == null">登录</a>
                    <div class="user-name" ng-if="userInfo != null">{{userInfo.showName}}</div>
                    <div class="user-signature" ng-if="userInfo.introduce != null && userInfo.introduce != ''">{{userInfo.introduce}}</div>
                </div>
            </div>
            <!--列表菜单栏-->
            <div class="mui-input-group my-list-menu">
                <div class="mui-input-row" ng-show="userInfo.roleId != 2">
                    <div class="mui-navigate-right" ng-click="isLogin('page/myOrder')">
                        <img class="mui-media-object mui-pull-left my-list-icon" src="<%=request.getContextPath()%>/resources/img/my/4.png">
                        <div class="mui-media-body">
                            <p class='mui-ellipsis'>我的订单</p>
                        </div>
                    </div>
                </div>
                <div class="mui-input-row">
                    <div class="mui-navigate-right" ng-click="isLogin('page/myNews')">
                        <img class="mui-media-object mui-pull-left my-list-icon" src="<%=request.getContextPath()%>/resources/img/my/5.png">
                        <div class="mui-media-body">
                            <p class='mui-ellipsis'>我的消息</p>
                        </div>
                    </div>
                </div>
                <div class="mui-input-row" ng-show="userInfo.roleId == 4">
                    <div class="mui-navigate-right" ng-click="isLogin('page/myCollect')">
                        <img class="mui-media-object mui-pull-left my-list-icon" src="<%=request.getContextPath()%>/resources/img/my/6.png">
                        <div class="mui-media-body">
                            <p class='mui-ellipsis'>我的收藏</p>
                        </div>
                    </div>
                </div>
                <div class="mui-input-row" ng-show="userInfo.roleId != 2">
                    <div>
                        <img class="mui-media-object mui-pull-left my-list-icon" src="<%=request.getContextPath()%>/resources/img/my/7.png">
                        <div class="mui-media-body">
                            <p class='mui-ellipsis'>我的积分
                                <span class="integral" ng-if="userInfo.accumulate == null">0积分</span>
                                <span class="integral" ng-if="userInfo.accumulate != null">{{userInfo.accumulate}}积分</span>
                            </p>
                        </div>
                    </div>
                </div>
                <%--<div class="mui-input-row" ng-show="userInfo.roleId == 4">
                    <div class="mui-navigate-right" ng-click="isLogin('page/certificate')">
                        <img class="mui-media-object mui-pull-left my-list-icon" src="<%=request.getContextPath()%>/resources/img/my/6.png">
                        <div class="mui-media-body">
                            <p class='mui-ellipsis'>我的证书</p>
                        </div>
                    </div>
                </div>--%>
                <div class="mui-input-row" ng-show="userInfo.roleId == 2 || userInfo.roleId == 3 || userInfo.roleId == 5">
                    <div class="mui-navigate-right" ng-click="isLogin('page/polling')">
                        <img class="mui-media-object mui-pull-left my-list-icon" src="<%=request.getContextPath()%>/resources/img/my/8.png">
                        <div class="mui-media-body">
                            <p class='mui-ellipsis'>安全巡监</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mui-input-group my-list-menu" style="margin-top: 10px;">
                <div class="mui-input-row">
                    <div class="mui-navigate-right" ng-click="isLogin('page/feedback')">
                        <img class="mui-media-object mui-pull-left my-list-icon" src="<%=request.getContextPath()%>/resources/img/my/9.png">
                        <div class="mui-media-body">
                            <p class='mui-ellipsis'>意见反馈</p>
                        </div>
                    </div>
                </div>
                <div class="mui-input-row">
                    <div class="mui-navigate-right" ng-click="isLogin('page/setting')">
                        <img class="mui-media-object mui-pull-left my-list-icon" src="<%=request.getContextPath()%>/resources/img/my/10.png">
                        <div class="mui-media-body">
                            <p class='mui-ellipsis'>设置</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!--底部tab切换-->
<nav class="mui-bar mui-bar-tab tab-bottom" id="tabBottom">
    <a class="mui-tab-item" href="<%=request.getContextPath()%>/page/index">
        <div class="tab-icon"><img src="<%=request.getContextPath()%>/resources/img/tab/1.png"></div>
        <span class="mui-tab-label">首页</span>
    </a>
    <a class="mui-tab-item" href="<%=request.getContextPath()%>/page/course">
        <div class="tab-icon"><img src="<%=request.getContextPath()%>/resources/img/tab/2.png"></div>
        <span class="mui-tab-label">课程</span>
    </a>
    <a class="mui-tab-item studyJurisdiction" href="<%=request.getContextPath()%>/page/study">
        <div class="tab-icon"><img src="<%=request.getContextPath()%>/resources/img/tab/3.png"></div>
        <span class="mui-tab-label">学习</span>
    </a>
    <a class="mui-tab-item mui-active" href="javascript:void(0)">
        <div class="tab-icon"><img src="<%=request.getContextPath()%>/resources/img/tab/4-4.png"></div>
        <span class="mui-tab-label">我的</span>
    </a>
</nav>

<%@include file="../common/js.jsp" %>
<script>

    CC.reload(); //刷新一下上一页传回来的东西

    mui.init();
    //我的可滚动
    mui("#myScroll").scroll();
    // 监听tap事件，解决 a标签 不能跳转页面问题
    mui('body').on('tap','a',function(){document.location.href=this.href;});

    var webApp = angular.module('webApp', []);
    webApp.controller('myController', function($scope, $http, $timeout) {
        $scope.userInfo = CC.getUserInfo(); //登录人信息
        $scope.imgUrl = CC.ipImg; //获取图片服务器IP


        //验证是否已登录
        $scope.isLogin = function (url) {
            if ($scope.userInfo == null) {
                mui.confirm('登录已失效，是否登录？', '', ["确认","取消"], function(e) {
                    if (e.index == 0) {
                        location.href = CC.ip + "page/login";
                    }
                });
            }
            else {
                location.href = CC.ip + url;
            }
        }
    });

</script>

</body>
</html>
