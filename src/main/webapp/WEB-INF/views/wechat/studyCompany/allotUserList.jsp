
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>视频分配</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/studyCompany/studyUserList.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/mui.indexedlist.css">
    <style>
        .mui-indexed-list-inner{height: inherit !important;}
    </style>
</head>
<body ng-app="webApp" ng-controller="userController" ng-cloak>
<header class="mui-bar mui-bar-nav">
    <a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"></a>
    <h1 class="mui-title">视频分配</h1>
    <a class="mui-btn mui-btn-link mui-pull-right mui-btn-blue" ng-click="complete()">完成</a>
</header>
<div class="mui-content">
    <div id='list' class="mui-indexed-list">
        <div class="mui-indexed-list-search mui-input-row mui-search">
            <input type="search" class="mui-input-clear mui-indexed-list-search-input" placeholder="搜索">
        </div>
        <div class="mui-indexed-list-bar hide">
            <a>A</a>
            <a>B</a>
            <a>C</a>
            <a>D</a>
            <a>E</a>
            <a>F</a>
            <a>G</a>
            <a>H</a>
            <a>I</a>
            <a>J</a>
            <a>K</a>
            <a>L</a>
            <a>M</a>
            <a>N</a>
            <a>O</a>
            <a>P</a>
            <a>Q</a>
            <a>R</a>
            <a>S</a>
            <a>T</a>
            <a>U</a>
            <a>V</a>
            <a>W</a>
            <a>X</a>
            <a>Y</a>
            <a>Z</a>
        </div>
        <div class="mui-indexed-list-alert"></div>
        <div class="mui-indexed-list-inner">
            <div class="allSelect">
                <div class="mui-checkbox">
                    <label>
                        <input type="checkbox" ng-click="allSelect($event)"/>全选
                    </label>
                </div>
            </div>
            <div class="mui-indexed-list-empty-alert">没有数据</div>
            <%--<div class="not-data" style="display: block" ng-show="userList.length == 0">暂无人员</div>--%>
            <ul class="mui-table-view" id="dataList">

            </ul>
        </div>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/mui.indexedlist.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/pinying.js"></script>

<script>

    var webApp = angular.module('webApp', []);
    webApp.controller('userController', function($scope, $http, $timeout) {
        $scope.imgUrl = CC.ipImg; //获取图片服务器IP
        $scope.curriculumId = CC.getUrlParam("curriculumId");
        $scope.userList = null;

        // 公司用户获取公司下的用户列表
        $scope.queryUserForAllocation = function (searchParam) {
            $scope.parameter = {
                searchParam : searchParam,
                curriculumId : $scope.curriculumId,
                isAllocation : 1,
                pageNO : 1,
                pageSize : 1000
            }
            CC.ajaxRequestData("post", false, "user/queryUserForAllocation", $scope.parameter, function (result) {
                $scope.userList = result.data;
                var html = "";
                var html2 = ""; //不是字母
                for (var i = 0; i < $scope.userList.length; i++) {
                    var obj = $scope.userList[i];
                    var arrResult = makePy(obj.showName);
                    CC.print(arrResult);
                    CC.print(arrResult.toString().replace(",", ""));
                    var spell = arrResult.toString().replace(",", "");
                    obj.avatar = obj.avatar == null ? CC.ip + "resources/img/my/11.png" : CC.ipImg + obj.avatar;
                    if (spell == obj.showName) {
                        CC.print("不是字母");
                        html2 += '<li data-value="' + spell + '" data-tags="' + spell + '" class="mui-table-view-cell mui-indexed-list-item mui-checkbox mui-left">' +
                                '   <div class="user-info">' +
                                '       <div class="user-head" style="background: url(' + obj.avatar + ')"></div>' +
                                '       <div class="user-name">' + obj.showName + '</div>' +
                                '       <div class="user-phone">' + obj.phone + '</div>' +
                                '   </div>' +
                                '   <input type="checkbox" value="' + obj.id + '" />' +
                                '</li>';
                    }
                    else {
                        var firstLetter = spell.substring(0, 1);
                        CC.print(firstLetter);
                        //html += '<li data-group="' + firstLetter + '" class="mui-table-view-divider mui-indexed-list-group">' + firstLetter + '</li>';
                        html += '<li data-value="' + firstLetter + '" data-tags="' + spell + '" class="mui-table-view-cell mui-indexed-list-item mui-checkbox mui-left">' +
                                '   <div class="user-info">' +
                                '       <div class="user-head" style="background: url(' + obj.avatar + ')"></div>' +
                                '       <div class="user-name">' + obj.showName + '</div>' +
                                '       <div class="user-phone">' + obj.phone + '</div>' +
                                '   </div>' +
                                '   <input type="checkbox" value="' + obj.id + '" />' +
                                '</li>';
                    }
                }
                $("#dataList").html(html + html2);
            });
        }
        $scope.queryUserForAllocation(null);

        //点击完成
        $scope.complete = function () {
            $scope.userIds  = [];
            $("#dataList").find("input[type='checkbox']").each(function () {
                if ($(this).is(":checked")) {
                    $scope.userIds .push($(this).val());
                }
            });
            CC.print($scope.userIds);
            $scope.parameter = {
                userIds : $scope.userIds.toString(),
                curriculumId : $scope.curriculumId,
                number : 1,
            }
            CC.print($scope.parameter);
            CC.ajaxRequestData("post", false, "allocation/addAllocation", $scope.parameter, function (result) {
                history.back();
            });
        }

        //全选
        $scope.allSelect = function (event) {
            if ($(event.target).is(":checked")) {
                $("#dataList").find("input[type='checkbox']:checkbox").prop("checked", true); //TODO prop很有用
            }
            else {
                $("#dataList").find("input[type='checkbox']:checkbox").prop("checked", false); //TODO prop很有用
            }
        }
    });

    mui.init();
    mui.ready(function() {
        var header = document.querySelector('header.mui-bar');
        var list = document.getElementById('list');
        list.style.height = (document.body.offsetHeight - header.offsetHeight - 20) + 'px';
        window.indexedList = new mui.IndexedList(list);
    });
</script>

</body>
</html>
