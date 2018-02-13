
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>绑定邮箱</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/login/registerPhone.css">
</head>
<body ng-app="webApp" ng-controller="controller" ng-cloak>

<div class="mui-content">
    <div class="email-icon"></div>
    <div class="my-set-email">你已绑定邮箱</div>
    <div class="my-email">{{userInfo.email}}</div>
    <div class="mui-content-padded">
        <button class="mui-btn mui-btn-block" ng-click="cutEmail()">切换邮箱</button>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script>
    var webApp = angular.module('webApp', []);
    webApp.controller('controller', function($scope, $http, $timeout) {
        $scope.userInfo = CC.getUserInfo();

        $scope.cutEmail = function () {
            location.href = CC.ip + "page/settingEmail";
        }
    });
</script>
</body>
</html>
