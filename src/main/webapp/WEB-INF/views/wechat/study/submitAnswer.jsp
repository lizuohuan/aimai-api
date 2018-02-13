<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>考试结果</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/study/submitAnswer.css">
</head>
<body ng-app="webApp" ng-controller="submitAnswerController" ng-cloak>

<div class="mui-content">
    <div class="grade-bar">
        <div ng-class="{true:'grade passScore', false:'grade'}[queryPaperRecord.resultScore >= queryPaperRecord.passScore]">
            {{queryPaperRecord.resultScore}}
            <span>分</span>
        </div>
        <div class="hint" ng-show="queryPaperRecord.resultScore < queryPaperRecord.passScore">
            抱歉您没有通过本次考核。
            <p ng-show="">您还有一次重新考核的机会</p>
        </div>
        <div class="hint" ng-show="queryPaperRecord.resultScore >= queryPaperRecord.passScore">
            恭喜您，通过考核。
        </div>
    </div>
    <div class="result-bar mui-row">
        <div class="statistical-result">
            结果统计
            <span class="mistake">
                <span></span>
                错误
            </span>
            <span class="correct">
                <span></span>
                正确
            </span>
        </div>
        <div ng-class="{true:'grade-item grade-item-active', false:'grade-item'}[answer.isCorrect == 1]" ng-repeat="answer in queryPaperRecord.jsonArray">
            {{$index + 1}}
        </div>
    </div>

    <div class="analysis-btn">
        <div class="mui-row">
            <div class="mui-col-xs-6" style="text-align: right;padding-right: 5px">
                <button class="mui-btn mistakes-btn" ng-click="error(0)">错题解析</button>
            </div>
            <div class="mui-col-xs-6" style="text-align: left;padding-left: 5px">
                <button class="mui-btn return-btn" ng-click="error(1)">全部解析</button>
            </div>
        </div>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script>
    var webApp = angular.module('webApp', []);
    webApp.controller('submitAnswerController', function($scope) {
        $scope.paperId = CC.getUrlParam("paperId"); //试卷ID
        $scope.orderId = CC.getUrlParam("orderId"); //订单ID
        $scope.queryPaperRecord = null; //考试结果
        CC.ajaxRequestData("post", false, "paper/queryPaperRecord", {paperId : $scope.paperId, orderId : $scope.orderId}, function (result) {
            $scope.queryPaperRecord = result.data;
        });

        //错题解析
        $scope.error = function (type) {
            $scope.ids = [];
            if (type == 0) {
                for (var i = 0; i < $scope.queryPaperRecord.jsonArray.length; i++) {
                    var obj = $scope.queryPaperRecord.jsonArray[i];
                    if (obj.isCorrect == 0) {
                        $scope.ids.push(obj.examinationId);
                    }
                }
            }
            else {
                for (var i = 0; i < $scope.queryPaperRecord.jsonArray.length; i++) {
                    var obj = $scope.queryPaperRecord.jsonArray[i];
                    $scope.ids.push(obj.examinationId);
                }
            }
            sessionStorage.removeItem("orderIds");
            sessionStorage.setItem("ids", $scope.ids);
            location.href = CC.ip + "page/errorInfo";
        }
    });
</script>

</body>
</html>
