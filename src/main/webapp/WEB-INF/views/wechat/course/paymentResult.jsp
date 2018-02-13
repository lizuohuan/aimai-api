
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>支付结果</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/course/paymentResult.css">
</head>
<body ng-app="webApp" ng-controller="paymentResultController">

<div class="mui-content" id="succeed" ng-show="isSucceed == 1">
    <div class="div-icon">
        <img src="<%=request.getContextPath()%>/resources/img/course/12.png">
        <p class="title">支付成功</p>
        <p class="hint">您可以在我的课程里面观看课程</p>
        <br>
        <br>
        <div class="mui-row">
            <div class="mui-col-xs-6" style="text-align: right;padding-right: 5px">
                <button type="button" class="mui-btn return-btn" ng-click="returnPage()">返回首页</button>
            </div>
            <div class="mui-col-xs-6" style="text-align: left;padding-left: 5px">
                <button type="button" class="mui-btn yellow-btn" ng-click="myCourses()">去我的课程</button>
            </div>
        </div>
    </div>
</div>

<div class="mui-content" id="beDefeated" ng-show="isSucceed == 0">
    <div class="div-icon">
        <img src="<%=request.getContextPath()%>/resources/img/course/11.png">
        <p class="title">支付失败</p>
        <p class="hint">订单已提交，你可以在我的订单里面从新支付</p>
        <br>
        <br>
        <div class="mui-row">
            <div class="mui-col-xs-6" style="text-align: right;padding-right: 5px">
                <button class="mui-btn return-btn" ng-click="returnPage()">返回首页</button>
            </div>
            <div class="mui-col-xs-6" style="text-align: left;padding-left: 5px">
                <button class="mui-btn yellow-btn" ng-click="myOrder()">重新支付</button>
            </div>
        </div>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script>
    var webApp = angular.module('webApp', []);
    webApp.controller('paymentResultController', function($scope) {
        $scope.isSucceed = CC.getUrlParam("isSucceed");
        //返回课程首页
        $scope.returnPage = function () {
            location.href = CC.ip + "page/course";
            //window.history.go(-2);
        }

        //去我的课程
        $scope.myCourses = function () {
            if (CC.getUserInfo().roleId == 3) location.href = CC.ip + "page/studyCompany/study";
            else if (CC.getUserInfo().roleId == 2) location.href = CC.ip + "page/studyGovernment/study";
            else location.href = CC.ip + "page/study";
        }

        //去我的课程
        $scope.myOrder = function () {
            location.href = CC.ip + "page/myOrder";
        }
    });
</script>

</body>
</html>
