
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>安全巡监</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/index/aboutUs.css">
</head>
<body ng-app="webApp" ng-controller="controller" ng-cloak>
<div class="content">
    <div class="title">安全巡监</div>
    <div class="context" ng-bind-html="content.content | trustHtml"></div>
</div>

<%@include file="../common/js.jsp" %>

<script>
    var webApp = angular.module('webApp', []);
    webApp.controller('controller', function($scope, $http, $timeout) {
        CC.ajaxRequestData("post", false, "content/info", { id : 4 }, function (result) {
            $scope.content = result.data;
        });
    });
    //富文本过滤器
    webApp.filter('trustHtml', ['$sce',function($sce) {
        return function(val) {
            return $sce.trustAsHtml(val);
        };
    }]);
</script>

</body>
</html>
