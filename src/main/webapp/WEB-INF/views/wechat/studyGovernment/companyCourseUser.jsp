
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>课程详情</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/studyGovernment/companyDetail.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/studyGovernment/companyCourseUser.css">

</head>
<body ng-app="webApp" ng-controller="companyController">

<div class="mui-content" style="display: block">
    <ul class="mui-table-view mui-table-view-chevron" id="courseList" ng-cloak>
        <li class="mui-table-view-cell mui-media">
            <a href="javascript: void(0)">
                <div class="mui-media-object mui-pull-left" style="background: url('{{imgUrl}}{{course.cover}}')"></div>
                <div class="mui-media-body">
                    <p class="list-title mui-ellipsis">{{course.curriculumName}}</p>
                    <div class="mui-row">
                        <div class="mui-col-xs-6">
                            <div class="list-num">
                                <img src="<%=request.getContextPath()%>/resources/img/my/3.png">
                                <span class="num-title"><span class="num">{{course.videoNum}}</span>个视频课</span>
                            </div>
                        </div>
                        <div class="mui-col-xs-6">
                            <div class="list-num">
                            <span class="minute">
                                <img src="<%=request.getContextPath()%>/resources/img/course/3.png" />
                                <span>{{course.hdSeconds}}</span>
                            </span>
                            </div>
                        </div>
                    </div>
                </div>
            </a>
        </li>
    </ul>

    <div class="course-info">
        <div id="slider" class="mui-slider">
            <div id="sliderSegmentedControl" class="mui-slider-indicator mui-segmented-control mui-segmented-control-inverted">
                <a class="mui-control-item mui-active" href="#page1">
                    <img src="<%=request.getContextPath()%>/resources/img/study/17.png" />
                    <span>观看人员({{course.watchUsers.length}})</span>
                </a>
                <a class="mui-control-item" href="#page2">
                    <img src="<%=request.getContextPath()%>/resources/img/study/16.png" />
                    <span>安全人员({{course.safeUsers.length}})</span>
                </a>
            </div>
            <div id="sliderProgressBar" class="mui-slider-progress-bar mui-col-xs-6"></div>
            <div class="mui-slider-group" id="mui-slider-group" ng-cloak>
                <div id="page1" class="mui-slider-item mui-control-content mui-active">
                    <div class="not-data" style="display: block;" ng-show="course.watchUsers.length == 0">暂无相关人员</div>
                    <div class="user-list" ng-repeat="user in course.watchUsers">
                        <div ng-if="user.avatar != null" class="user-head" style="background: url('{{imgUrl}}{{user.avatar}}')"></div>
                        <div ng-if="user.avatar == null" class="user-head" style="background: url('<%=request.getContextPath()%>/resources/img/my/11.png')"></div>
                        <div class="name">{{user.showName}}</div>
                    </div>
                </div>

                <div id="page2" class="mui-slider-item mui-control-content">
                    <div class="not-data" style="display: block;" ng-show="course.safeUsers.length == 0">暂无相关人员</div>
                    <div class="user-list" ng-repeat="user in course.safeUsers">
                        <div ng-if="user.avatar != null" class="user-head" style="background: url('{{imgUrl}}{{user.avatar}}')"></div>
                        <div ng-if="user.avatar == null" class="user-head" style="background: url('<%=request.getContextPath()%>/resources/img/my/11.png')"></div>
                        <div class="name">{{user.showName}}</div>
                    </div>
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
        $scope.course = JSON.parse(sessionStorage.getItem("course"));
        $scope.course.hdSeconds = CC.getFormat($scope.course.hdSeconds);
        CC.print($scope.course);
    });
</script>

</body>
</html>
