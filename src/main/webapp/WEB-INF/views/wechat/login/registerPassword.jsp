
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>设置密码</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/login/registerPhone.css">
</head>
<body ng-app="webApp" ng-controller="registerPasswordController" ng-cloak>

<div class="mui-content">
    <form class="mui-input-group">
        <div class="mui-input-row">
            <input id='paw1' type="password" class="mui-input-clear mui-input" placeholder="输入新密码" maxlength="32">
        </div>
        <div class="mui-input-row">
            <input id='paw2' type="password" class="mui-input" placeholder="再次输入密码" maxlength="32">
        </div>
    </form>
    <div class="mui-content-padded">
        <button class="mui-btn mui-btn-block" ng-click="nextStep()">下一步</button>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/jQuery.md5.js"></script>

<script>
    var webApp = angular.module('webApp', []);
    webApp.controller('registerPasswordController', function($scope, $http, $timeout) {
        $scope.registerInfo = JSON.parse(localStorage.getItem("registerInfo")); //获取上级页面的信息
        //提交密码
        $scope.nextStep = function() {
            var $paw1 = $("#paw1").val(); //新密码
            var $paw2 = $("#paw2").val(); //确认密码
            if($paw1 == "") {
                mui.toast("请输入新密码.");
                return false;
            } else if($paw1.trim().length < 6 || $paw1.trim().length > 32) {
                mui.toast("请输入6-32位的密码.");
                return false;
            } else if($paw2 == "") {
                mui.toast("请输入确认密码.");
                return false;
            } else if($paw1 != $paw2) {
                mui.toast("两次密码不一致.");
                return false;
            }

            $scope.registerInfo.password = $.md5($paw2);
            localStorage.setItem("registerInfo", JSON.stringify($scope.registerInfo));
            sessionStorage.removeItem("selectAddress");
            sessionStorage.removeItem("tradeInfo");
            sessionStorage.removeItem("veriFaceImages");
            sessionStorage.removeItem("licenseFile");
            //跳转信息页面
            location.href = CC.ip + "page/registerData";

        }
    });
</script>
</body>
</html>
