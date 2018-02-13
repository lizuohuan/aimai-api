
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>课程详情</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/course/courseInfo.css">
    <style>
        /*隐藏下拉样式*/
        .mui-pull-top-pocket .mui-pull-loading:before,
        .mui-pull-top-pocket .mui-pull-loading:after,
        .mui-pull-top-pocket .mui-spinner:after {
            content: '' !important;
            background: none !important;
        }
    </style>
</head>
<body ng-app="webApp" ng-controller="courseInfoController" ng-cloak>

<div class="mui-content" style="display: block;">

    <div class="course-cover" style="background: url('{{imgUrl}}{{curriculum.cover}}')"></div>

    <div class="collect-info" ng-cloak>
        <div class="mui-row title-bar">
            <div class="row-left">
                <div class="course-title">{{curriculum.curriculumName}}</div>
                <span class="course-badge">{{curriculum.stageName}}</span>
                <span class="course-badge">{{curriculum.year | date:'yyyy'}}年</span>
                <div class="list-num">
                    <div class="mui-row">
                        <div class="mui-col-xs-6">
                            <img src="<%=request.getContextPath()%>/resources/img/course/2.png" />
                            {{curriculum.videoNum}}个视频课
                        </div>
                        <div class="mui-col-xs-6">
                            <img src="<%=request.getContextPath()%>/resources/img/course/3.png" />
                            {{curriculum.hdSeconds}}
                        </div>
                    </div>
                </div>
            </div>
            <div class="row-left row-right">
                <div ng-show="curriculum.isPass == 1">考核通过</div>
                <div ng-show="curriculum.isPass == 0">待考核</div>
                <div ng-show="curriculum.isPass == 1" class="component">{{curriculum.passTime | date : 'yyyy-MM-dd HH:mm'}}</div>
            </div>

        </div>
    </div>

    <div class="course-wares-info">
        <ul class="mui-table-view mui-table-view-chevron" id="catalogueList">
            <li ng-repeat="ware in curriculum.courseWares">
                <div ng-class="{true:'mui-ellipsis', false:'mui-ellipsis isStudy'}[video.videoStatus.status == 2]" ng-repeat="video in ware.videos">
                    <span ng-show="video.videoStatus.status == 2" class="label">已学习</span>
                    <span ng-show="video.videoStatus.status == 2" class="triangle"></span>
                    <i ng-show="video.videoStatus.status != 2"></i>
                    {{ware.courseWareName}}：{{video.name}}
                    <span class="catalogue-time">{{video.lowDefinitionSeconds}}</span>
                </div>
            </li>
        </ul>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script>
    var webApp = angular.module('webApp', []);
    webApp.controller('courseInfoController', function($scope, $http, $timeout) {
        $scope.imgUrl = CC.ipImg; //图片IP
        $scope.orderId = CC.getUrlParam("orderId");
        $scope.userId = CC.getUrlParam("userId");
        $scope.curriculum = null; //课程对象
        CC.ajaxRequestData("post", false, "curriculum/queryCurriculumByOrder", {orderId : $scope.orderId, userId : $scope.userId}, function (result) {
            $scope.curriculum = result.data;
            $scope.curriculum.hdSeconds = CC.getFormat($scope.curriculum.hdSeconds);
            for (var i = 0; i < $scope.curriculum.courseWares.length; i++) {
                var courseWares = $scope.curriculum.courseWares[i];
                for (var j = 0; j < courseWares.videos.length; j++) {
                    var video = courseWares.videos[j];
                    video.highDefinitionSeconds = CC.getFormatTime(video.highDefinitionSeconds);
                    video.lowDefinitionSeconds = CC.getFormatTime(video.lowDefinitionSeconds);
                }
            }
        });
    });

</script>

</body>
</html>
