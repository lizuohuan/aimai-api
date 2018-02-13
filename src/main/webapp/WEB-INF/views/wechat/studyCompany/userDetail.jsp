
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
        <div class="user-info">
            <div class="head-img" ng-show="userInfo.avatar == null" style="background: url('<%=request.getContextPath()%>/resources/img/my/11.png') 100%"></div>
            <div class="head-img" ng-show="userInfo.avatar != null" style="background: url('{{imgUrl}}{{userInfo.avatar}}') 100%"></div>
            <div class="user-name" ng-if="userInfo != null">{{userInfo.showName}}</div>
            <div class="user-signature" ng-if="userInfo.introduce != null && userInfo.introduce != ''">{{userInfo.introduce}}</div>
        </div>
    </div>
    <div class="title">个人信息</div>
    <div class="mui-input-group">
        <div class="mui-input-row">
            <label>姓名</label>
            <input type="text" readonly class="mui-input" value="{{userInfo.showName}}">
        </div>
        <div class="mui-input-row">
            <label>电话</label>
            <input type="text" readonly class="mui-input" value="{{userInfo.phone}}">
        </div>
        <div class="mui-input-row">
            <label>身份证号</label>
            <input type="text" readonly class="mui-input" value="{{userInfo.pid}}">
        </div>
        <div class="mui-input-row">
            <label>部门</label>
            <input type="text" readonly class="mui-input" value="{{userInfo.departmentName == null ? '暂无' : userInfo.departmentName}}">
        </div>
        <div class="mui-input-row">
            <label>职位</label>
            <input type="text" readonly class="mui-input" value="{{userInfo.jobTitle == null ? '暂无' : userInfo.jobTitle}}">
        </div>
    </div>
    <div class="title">学习课程</div>
    <div class="not-data" style="display: block;" ng-show="userInfo.curriculumList.length == 0">暂无课程.</div>
    <div class="mui-row margin-bottom">
        <div class="mui-col-xs-6" ng-repeat="course in userInfo.curriculumList">
            <div class="ribbon" ng-click="userCourseInfo(course.orderId)">
                <div class="wrap" ng-show="course.isPass == 1">
                    <span class="ribbon-title">通过考核</span>
                </div>
                <div class="course-cover" style="background: url('{{imgUrl}}{{course.cover}}')"></div>
                <div class="video-title">
                    {{course.curriculumName}}
                </div>
                <div class="list-num">
                    <span class="num-title">
                        <img src="<%=request.getContextPath()%>/resources/img/my/3.png" />
                        <span class="num">{{course.videoNum}}</span>个视频课
                    </span>
                </div>
                <div class="study-progress">
                    <span style="width: {{course.studyNum / course.number * 100}}%"></span>
                </div>
                <div class="list-num">
                    <span class="num-title color-black">
                        <img src="<%=request.getContextPath()%>/resources/img/study/2.png">
                        已学习<span class="num">{{course.studyNum}}</span>份
                    </span>
                </div>
            </div>
        </div>
    </div>

    <div style="height: 70px;"></div>

    <div class="fix-div">
        <a class="mui-btn mui-btn-block fix-btn" ng-click="allotCourse()">分配课程</a>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script>

    var webApp = angular.module('webApp', []);
    webApp.controller('userController', function($scope, $http, $timeout) {
        $scope.imgUrl = CC.ipImg; //获取图片服务器IP
        $scope.userId = CC.getUrlParam("userId");
        $scope.userInfo = null;

        //员工课程详情
        CC.ajaxRequestData("post", false, "user/queryUserDetail", {userId : $scope.userId}, function (result) {
            $scope.userInfo = result.data;
        });

        //员工课程详情
        $scope.userCourseInfo = function (orderId) {
            location.href = CC.ip + "page/studyCompany/userCourseInfo?orderId=" + orderId + "&userId=" + $scope.userId;
        }

        //课程分配
        $scope.allotCourse = function () {
            location.href = CC.ip + "page/studyCompany/allotCourse?userId=" + $scope.userId;
        }

    });

</script>

</body>
</html>
