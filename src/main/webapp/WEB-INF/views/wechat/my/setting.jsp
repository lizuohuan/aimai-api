
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>设置</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/my/setting.css">
</head>
<body ng-app="webApp" ng-controller="settingController" ng-cloak>

<div class="mui-content">
    <div class="mui-input-group my-list-menu">
        <div class="mui-input-row" ng-show="userInfo.roleId == 4">
            <a class="mui-navigate-right title" href="<%=request.getContextPath()%>/page/settingDefinition">
                清晰度设置
            </a>
        </div>
        <div class="mui-input-row">
            <a ng-if="userInfo.email == null" class="mui-navigate-right title" href="<%=request.getContextPath()%>/page/settingEmail">
                绑定邮箱
                <span ng-if="userInfo.email == null" class="not-binding">未绑定</span>
            </a>
            <a ng-if="userInfo.email != null" class="mui-navigate-right title" href="<%=request.getContextPath()%>/page/settingUpdateEmail">
                绑定邮箱
                <span ng-if="userInfo.email != null" class="email-binding">{{userInfo.email}}</span>
            </a>
        </div>
        <div class="mui-input-row">
            <a class="mui-navigate-right title" href="<%=request.getContextPath()%>/page/updatePassword">
                修改密码
            </a>
        </div>
    </div>

    <div class="mui-input-group my-list-menu" style="margin-top: 10px;">
        <%--<div class="mui-input-row">
            <a class="title">
                清除缓存
            </a>
        </div>--%>
        <div class="mui-input-row">
            <a class="mui-navigate-right title" href="<%=request.getContextPath()%>/page/aboutUs">
                关于我们
            </a>
        </div>
        <div class="mui-input-row" style="padding-left: 0;">
            <a class="login-out" ng-click="loginOut()">
                退出登录
            </a>
        </div>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script>
    var webApp = angular.module('webApp', []);
    webApp.controller('settingController', function($scope, $http, $timeout) {
        $scope.userInfo = CC.getUserInfo();
        //退出登录
        $scope.loginOut = function () {
            mui.confirm('是否确认退出登录？', '', ["确认","取消"], function(e) {
                if (e.index == 0) {
                    CC.ajaxRequestData("post", false, "user/logout", null, function () {
                        localStorage.removeItem("userInfo");
                        window.history.back();
                    });
                }
            });
        }
    });
</script>

</body>
</html>
