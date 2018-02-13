
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>员工详情</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/studyCompany/userDetail.css">
</head>
<body ng-app="webApp" ng-controller="userController" ng-cloak>

<div class="mui-content">
    <!-- 头像栏 -->
    <div class="head-bar">
        <a class="add-user" href="<%=request.getContextPath()%>/page/studyCompany/addUser?userId={{userId}}&pageType=0">添加</a>
        <div class="user-info">
            <div class="head-img" ng-show="user.avatar == null" style="background: url('<%=request.getContextPath()%>/resources/img/my/11.png') 100%"></div>
            <div class="head-img" ng-show="user.avatar != null" style="background: url('{{imgUrl}}{{user.avatar}}') 100%"></div>
            <div class="user-name" ng-if="user != null">{{user.showName}}</div>
            <div class="user-signature" ng-if="userInfo.introduce != null && userInfo.introduce != ''">{{userInfo.introduce}}</div>

        </div>
    </div>
    <div class="title">个人信息</div>
    <div class="mui-input-group">
        <div class="mui-input-row">
            <label>姓名</label>
            <input type="text" readonly class="mui-input" value="{{user.showName}}">
        </div>
        <div class="mui-input-row">
            <label>电话</label>
            <input type="text" readonly class="mui-input" value="{{user.phone}}">
        </div>
        <div class="mui-input-row">
            <label>身份证号</label>
            <input type="text" readonly class="mui-input" value="{{user.pid}}">
        </div>
        <div class="mui-input-row">
            <label>部门</label>
            <input type="text" readonly class="mui-input" value="{{user.departmentName == null ? '暂无' : user.departmentName}}">
        </div>
        <div class="mui-input-row">
            <label>职位</label>
            <input type="text" readonly class="mui-input" value="{{user.jobTitle == null ? '暂无' : user.jobTitle}}">
        </div>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script>

    CC.reload(); //刷新一下上一页传回来的东西
    var webApp = angular.module('webApp', []);
    webApp.controller('userController', function($scope, $http, $timeout) {
        $scope.userInfo = CC.getUserInfo(); //登录人信息
        $scope.imgUrl = CC.ipImg; //获取图片服务器IP
        $scope.userId = CC.getUrlParam("userId");
        $scope.user = null;
        //员工课程详情
        CC.ajaxRequestData("post", false, "user/queryUserDetail", {userId : $scope.userId}, function (result) {
            $scope.user = result.data;
        });
    });

</script>

</body>
</html>
