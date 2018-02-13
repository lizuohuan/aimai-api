
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>使用协议</title>
    <%@include file="../wechat/common/css.jsp" %>
    <style>
        .content{padding: 0 10px;}
        .title{
            font-size: 16px;
            padding: 15px;
            text-align: center;
        }
        .context * {
            max-width: 100%;
        }
    </style>

</head>
<body ng-app="webApp" ng-controller="controller" ng-cloak>
<div class="content">
    <div class="title">{{content.name}}</div>
    <div class="context" ng-bind-html="content.content | trustHtml"></div>
</div>
<%@include file="../wechat/common/js.jsp" %>
<script>
    var webApp = angular.module('webApp', []);
    webApp.controller('controller', function($scope) {
        CC.ajaxRequestData("post", false, "content/info", { id : 6 }, function (result) {
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
