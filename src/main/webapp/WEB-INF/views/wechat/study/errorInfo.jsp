<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>错题解析</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/swiper.min.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/study/errorInfo.css">
</head>
<body ng-app="webApp" ng-controller="controller" ng-cloak>

<div class="mui-content">
    <div class="title-bar" ng-show="orderIds != null">
        <p>{{orderIds.curriculumName}}</p>
        <p>课时:{{orderIds.courseWareName}}</p>
    </div>
    <div class="swiper-container">
        <div class="swiper-wrapper">
            <div class="swiper-slide" ng-repeat="examination in examinationList">
                <ul class="mui-table-view mui-table-view-chevron">
                    <li class="mui-table-view-cell mui-media">
                        <span class="list-title" ng-show="examination.type == 0">单选题</span>
                        <span class="list-title" ng-show="examination.type == 1">多选题</span>
                        <span class="list-title" ng-show="examination.type == 2">判断题</span>
                        <%--<span class="answer">A</span>--%>
                    </li>
                    <li class="mui-table-view-cell mui-media">
                        <a href="javascript:;">
                            <span class="topic-title">{{examination.title}}（）</span>
                            <p class="topic-answer" ng-repeat="item in examination.examinationItemsList">
                                <span ng-show="$index == 0">A</span>
                                <span ng-show="$index == 1">B</span>
                                <span ng-show="$index == 2">C</span>
                                <span ng-show="$index == 3">D</span>
                                <span ng-show="$index == 4">E</span>
                                <span ng-show="$index == 5">F</span>
                                <span ng-show="$index == 6">G</span>
                                <span ng-show="$index == 7">H</span>
                                <span ng-show="$index == 8">I</span>
                                <span ng-show="$index == 9">J</span>
                                <span ng-show="$index == 10">K</span>
                                、{{item.itemTitle}}
                            </p>
                        </a>
                    </li>
                </ul>
                <ul class="mui-table-view mui-table-view-chevron answer-bar-ul">
                    <li class="mui-table-view-cell">
                        <p class="analysis">
                            <span class="blue-badge">答案</span>
                            <span class="answer" ng-repeat="item in examination.examinationItemsList" ng-show="item.isCorrect == 1">
                                <span ng-show="$index == 0">A</span>
                                <span ng-show="$index == 1">B</span>
                                <span ng-show="$index == 2">C</span>
                                <span ng-show="$index == 3">D</span>
                                <span ng-show="$index == 4">E</span>
                                <span ng-show="$index == 5">F</span>
                                <span ng-show="$index == 6">G</span>
                                <span ng-show="$index == 7">H</span>
                                <span ng-show="$index == 8">I</span>
                                <span ng-show="$index == 9">J</span>
                                <span ng-show="$index == 10">K</span>
                            </span>
                        </p>
                        <p class="analysis">
                            <span class="gray-badge">考点</span>
                            <span class="analysis-context">{{examination.emphasis}}</span>
                        </p>
                        <p class="analysis inTheEnd-analysis">
                            <span class="gray-badge">解析</span>
                            <span class="analysis-context">{{examination.examinationKey}}</span>
                        </p>
                    </li>
                </ul>
            </div>
        </div>
        <!-- Add Pagination -->
        <div class="swiper-pagination"></div>
    </div>

</div>

<%@include file="../common/js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/swiper.min.js"></script>

<script>
    var swiper = new Swiper('.swiper-container', {
        pagination: '.swiper-pagination',
        paginationType: 'fraction',
        autoHeight: true, //enable auto height
        observer:true,//修改swiper自己或子元素时，自动初始化swiper
        observeParents:true,//修改swiper的父元素时，自动初始化swiper
    });

    var webApp = angular.module('webApp', []);
    webApp.controller('controller', function($scope) {
        $scope.orderIds = JSON.parse(sessionStorage.getItem("orderIds"));
        $scope.examinationList = null; //考试结果
        if ($scope.orderIds == null) {
            CC.print(sessionStorage.getItem("ids"));
            $scope.parameter = {
                ids : "[" + sessionStorage.getItem("ids").toString() + "]"
            }
            CC.ajaxRequestData("post", false, "examination/queryExaminationKey", $scope.parameter, function (result) {
                $scope.examinationList = result.data;
            });
        }
        else {
            $scope.parameter = {
                courseWareId : $scope.orderIds.courseWareId,
                orderId : $scope.orderIds.orderId,
                pageNO : 1,
                pageSize : 2000
            }
            CC.ajaxRequestData("post", false, "examination/queryErrorExamination", $scope.parameter, function (result) {
                $scope.examinationList = result.data;
            });
        }

    });


</script>

</body>
</html>
