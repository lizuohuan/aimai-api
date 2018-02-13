
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>修改密码</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/my/updatePassword.css">
</head>
<body ng-app="webApp" ng-controller="updatePasswordController" ng-cloak>

<div class="mui-content">
    <div class="mui-input-group my-list-menu">
        <div class="mui-input-row">
            <a class="mui-navigate-right title" href="<%=request.getContextPath()%>/page/settingPhone">
                忘记密码
            </a>
        </div>
        <div class="mui-input-row">
            <a class="mui-navigate-right title" href="<%=request.getContextPath()%>/page/settingUpdatePassword?type=1">
                记得密码
            </a>
        </div>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script>
    var webApp = angular.module('webApp', []);
    webApp.controller('updatePasswordController', function($scope, $http, $timeout) {

    });
</script>

</body>
</html>
