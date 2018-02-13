<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>详细信息</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/studyGovernment/companyDetail.css">

</head>
<body ng-app="webApp" ng-controller="companyController" ng-cloak>

<div class="mui-content">
    <div class="mui-input-group">
        <div class="mui-input-row">
            <label>公司名称</label>
            <input type="text" readonly class="mui-input" value="{{company.showName}}">
        </div>
        <div class="mui-input-row">
            <label>营业执照编号</label>
            <input type="text" readonly class="mui-input" value="{{company.pid}}">
        </div>
        <div class="mui-input-row">
            <label>行业</label>
            <input type="text" readonly class="mui-input" value="{{company.tradeName}}">
        </div>
        <div class="mui-input-row">
            <label>地址</label>
            <input type="text" readonly class="mui-input" value="{{company.city.mergerName}}">
        </div>
        <div class="mui-input-row" style="height: inherit !important;padding: 10px 0">
            <label>营业执照照片</label>
            <div class="preview">
                <img src="{{imgUrl}}{{company.licenseFile}}">
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

    });

</script>

</body>
</html>
