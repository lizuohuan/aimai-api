
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>意见反馈</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/my/feedback.css">
</head>
<body ng-app="webApp" ng-controller="feedbackController" ng-cloak>

<div class="mui-content">
    <div class="bg-div">
        <textarea class="mui-textarea" ng-model="content" placeholder="请输入您的宝贵意见"></textarea>
    </div>
    <div style="padding: 15px;">
        <button class="mui-btn mui-btn-block" ng-click="submitData()">提交</button>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script>
    var webApp = angular.module('webApp', []);
    webApp.controller('feedbackController', function($scope, $http, $timeout) {
        $scope.content = "";
        $scope.submitData = function () {
            if (CC.isEmoji.test($scope.content)) {
                mui.toast("不支持Emoji表情.");
                return false;
            }
            CC.ajaxRequestData("post", false, "suggest/submitSuggest", {content : $scope.content}, function () {
                mui.alert("感谢您的意见.", "", function () {
                    location.reload();
                });
            });
        }

    });
</script>

</body>
</html>
