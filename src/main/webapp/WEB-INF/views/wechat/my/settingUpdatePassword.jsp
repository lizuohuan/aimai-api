
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>设置新密码</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/login/registerPhone.css">
</head>
<body ng-app="webApp" ng-controller="newPasswordController" ng-cloak>

<div class="mui-content">
    <form class="mui-input-group">
        <div class="mui-input-row" ng-if="type == 1">
            <input id='paw0' type="password" class="mui-input" placeholder="输入原始密码" maxlength="16">
        </div>
        <div class="mui-input-row">
            <input id='paw1' type="password" class="mui-input" placeholder="输入新密码" maxlength="16">
        </div>
        <div class="mui-input-row">
            <input id='paw2' type="password" class="mui-input" placeholder="再次输入密码" maxlength="16">
        </div>
    </form>
    <div class="mui-content-padded">
        <button class="mui-btn mui-btn-block" ng-click="nextStep()">确认修改</button>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/jQuery.md5.js"></script>

<script>
    var webApp = angular.module('webApp', []);
    webApp.controller('newPasswordController', function($scope, $http, $timeout) {

        $scope.type = CC.getUrlParam("type"); //获取类型
        $scope.phone = CC.getUrlParam("phone"); //获取上级页面的信息
        //提交密码
        $scope.nextStep = function() {
            var $paw0 = $("#paw0").val(); //原始密码
            var $paw1 = $("#paw1").val(); //新密码
            var $paw2 = $("#paw2").val(); //确认密码
            if ($scope.type == 1) {
                if($paw0 == "") {
                    mui.toast("请输入原始密码.");
                    return false;
                } else if($paw1.trim().length < 6 || $paw1.trim().length > 12) {
                    mui.toast("请输入6-12位的密码.");
                    return false;
                }
            }
            if($paw1 == "") {
                mui.toast("请输入新密码.");
                return false;
            } else if($paw1.trim().length < 6 || $paw1.trim().length > 12) {
                mui.toast("请输入6-12位的密码.");
                return false;
            } else if($paw2 == "") {
                mui.toast("请输入确认密码.");
                return false;
            } else if($paw1 != $paw2) {
                mui.toast("两次密码不一致.");
                return false;
            }

            var parameter = {}

            if ($scope.type == 1) {
                parameter = {
                    newPwd : $.md5($paw2),
                    oldPwd : $.md5($paw0),
                }
            }
            else {
                parameter = {
                    newPwd : $.md5($paw2),
                    phone : $scope.phone,
                }
            }
            CC.ajaxRequestData("post", false, "user/setPwd", parameter, function () {
                localStorage.removeItem("userInfo");
                location.href = CC.ip + "page/login";
            });

        }
    });
</script>
</body>
</html>
