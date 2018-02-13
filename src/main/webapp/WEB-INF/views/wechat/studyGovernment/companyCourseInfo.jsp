
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>公司详情</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/studyGovernment/companyDetail.css">

</head>
<body ng-app="webApp" ng-controller="companyController" ng-cloak>

<div class="mui-content">
    <!-- 头像栏 -->
    <div class="head-bar">
        <div class="user-info" ng-click="companyDetail()">
            <div class="head-img" ng-show="company.avatar == null" style="background: url('<%=request.getContextPath()%>/resources/img/my/11.png') 100%"></div>
            <div class="head-img" ng-show="company.avatar != null" style="background: url('{{imgUrl}}{{company.avatar}}') 100%"></div>
            <div class="user-name">{{company.showName}}</div>
            <div class="user-signature"><img src="<%=request.getContextPath()%>/resources/img/study/19.png">{{company.city.mergerName}}</div>
        </div>
    </div>
    <div class="title">个人信息</div>
    <div class="mui-row">
        <div class="mui-col-xs-4">
            <div class="user-num">{{company.joinNum}}位</div>
            <div class="user-num">参培人员</div>
        </div>
        <div class="mui-col-xs-4">
            <div class="user-num">{{company.safeNum}}位</div>
            <div class="user-num">安全人员</div>
        </div>
        <div class="mui-col-xs-4">
            <div class="user-num">{{company.joinNum - company.safeNum}}位</div>
            <div class="user-num">未通过人员</div>
        </div>
    </div>
    <div class="title" style="margin-top: 10px">学习课程</div>
    <div class="not-data" style="display: block;background: #FFF" ng-show="curriculumList.length == 0">暂无课程.</div>
    <div class="mui-row margin-bottom">
        <div class="mui-col-xs-6" ng-repeat="course in curriculumList">
            <div class="ribbon" ng-click="userCourseInfo(course)">
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
                <div class="list-num">
                    <span class="num-title">
                        <img src="<%=request.getContextPath()%>/resources/img/study/17.png" />
                        <span class="yellow">{{course.watchNum == null ? 0 : course.watchNum}}</span>位观看
                    </span>
                </div>
                <div class="list-num">
                    <span class="num-title">
                        <img src="<%=request.getContextPath()%>/resources/img/study/16.png" />
                        <span class="num">{{course.safeUsers.length}}</span>位安全人员
                    </span>
                </div>
            </div>
        </div>

    </div>
</div>

<%@include file="../common/js.jsp" %>
<script>

    var webApp = angular.module('webApp', []);
    webApp.controller('companyController', function($scope, $http, $timeout) {
        $scope.imgUrl = CC.ipImg; //获取图片服务器IP
        $scope.companyId = CC.getUrlParam("companyId");
        $scope.company = null;
        CC.ajaxRequestData("post", false, "user/queryCompanyDetail", {companyId : $scope.companyId}, function (result) {
            $scope.company = result.data;
        });

        $scope.parameter = {
            pageNO : 1,
            pageSize : 1000,
            companyId : $scope.companyId
        }
        CC.ajaxRequestData("post", false, "curriculum/queryCurriculumByCompany", $scope.parameter, function (result) {
            $scope.curriculumList = result.data;
        });

        //该公司详情
        $scope.companyDetail = function () {
            location.href = CC.ip + "page/studyGovernment/companyDetail?companyId=" + $scope.companyId;
        }

        //该公司课程详情
        $scope.userCourseInfo = function (course) {
            sessionStorage.setItem("course", JSON.stringify(course));
            location.href = CC.ip + "page/studyGovernment/companyCourseUser";
        }

    });

</script>

</body>
</html>
