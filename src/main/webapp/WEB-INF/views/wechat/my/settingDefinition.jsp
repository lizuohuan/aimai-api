
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>清晰度设置</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/my/setting.css">
</head>
<body ng-app="webApp" ng-controller="settingDefinitionController" ng-cloak>

<div class="mui-content">
    <ul class="mui-table-view mui-table-view-radio">
        <li ng-class="{true: 'mui-table-view-cell mui-selected', false: 'mui-table-view-cell'}[userInfo.definition == 0]" ng-click="definition(0)">
            <a class="mui-navigate-right title">
                标清
            </a>
        </li>
        <li ng-class="{true: 'mui-table-view-cell mui-selected', false: 'mui-table-view-cell'}[userInfo.definition == 1]" ng-click="definition(1)">
            <a class="mui-navigate-right title">
                高清
            </a>
        </li>
    </ul>
</div>

<%@include file="../common/js.jsp" %>
<script>
    var webApp = angular.module('webApp', []);
    webApp.controller('settingDefinitionController', function($scope, $http, $timeout) {
        $scope.userInfo = CC.getUserInfo();

        //设置清晰度
        $scope.definition = function (definition) {
            CC.ajaxRequestData("post", false, "user/updateUser", {definition : definition}, function () {
                CC.ajaxRequestData("post", false, "user/getInfo", null, function (result) {
                    localStorage.setItem("userInfo", JSON.stringify(result.data));
                    window.history.back();
                });
            });
        }
    });
</script>

</body>
</html>
