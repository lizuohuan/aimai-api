
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>爱麦415-下载</title>
    <%@include file="../wechat/common/css.jsp" %>
    <style>
        .content{
            width: 100%;
            height:100%;
            background: url("<%=request.getContextPath()%>/resources/img/download-bg.png");
            background-position: center;
            background-size: cover;
        }
        .title{
            padding: 30px;
            color: #000;
            font-size: 18px;
            text-align: center;
        }
        .title img{
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
            margin-bottom: 15px;
        }
        .download-bar{
            position: absolute;
            top: 50%;
            left:50%;
            transform: translate(-50%, -50%);
            -webkit-transform: translate(-50%, -50%);
            -moz-transform: translate(-50%, -50%);
            -os-transform: translate(-50%, -50%);
        }
        .download-btn{
            padding: 10px;
            border-radius: 6px;
            color: #FFF;
            border-color: #2E75B5;
            box-shadow: 0px 2px 6px 0px #2E75B5;
            background: #2E75B5;
            width: 140px;
            text-align: center;
        }
        .download-btn:active, .download-btn:focus{
            background: #2E75B5 !important;
            border-color: #2E75B5 !important;
        }
    </style>

</head>
<body ng-app="webApp" ng-controller="controller" ng-cloak>
<div class="content">
    <div class="download-bar">
        <div class="title">
            <img src="<%=request.getContextPath()%>/resources/img/download-logo.png" width="50">
            <p>爱麦415</p>
        </div>
        <button class="download-btn" ng-click="download()">免费下载</button>
    </div>
</div>
<%@include file="../wechat/common/js.jsp" %>
<script>
    var webApp = angular.module('webApp', []);
    webApp.controller('controller', function($scope) {
        $scope.download = function () {
            var agent = navigator.userAgent.toLowerCase();        //检测是否是ios
            if (agent.indexOf('iphone') >= 0 || agent.indexOf('ipad') >= 0) {
                location.href = "https://itunes.apple.com/cn/app/id1279207510?mt=8";
            }
            else {
                location.href = "https://www.pgyer.com/Cg53";
            }
        }
    });
</script>

</body>
</html>
