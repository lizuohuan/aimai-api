
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>选择地址</title>
    <%@include file="../common/css.jsp" %>
    <style>
        #sliderProgressBar {
            transition: all 0.3s;
            background: #2E75B5;
            position: relative;
            top: 1px;
            z-index: 2;
        }
        .mui-slider {
            position: fixed;
        }
        .mui-table-view{
            background: inherit;
        }
        .mui-table-view-cell:after, .mui-table-view-cell:before{
            height: 0;
        }
        .mui-active{
            color: #000000 !important;
        }
        .mui-ios .mui-table-view-cell{
            color: #000000;
            font-size: 16px;
        }
        .active{
            color: #2e75b6 !important;
        }
        .active span{
            display: inline-block;
            width: 3px;
            background: #2e75b6;
            float: left;
            height: 18px;
            margin-right: 10px;
            position: relative;
            top: 2px;
        }
        .mui-table-view{
            padding-bottom: 100px;
        }
        .fix{
            position: fixed;
            bottom: 0;
            z-index: 999;
            background: #F6F9FE;
            width: 100%;
            margin: 0;
            padding: 15px;
        }
        .fix button{
            margin-bottom: 0;
        }
    </style>
</head>
<body ng-app="webApp" ng-controller="addressController">

<div id="slider" class="mui-slider">
    <div id="sliderSegmentedControl" class="mui-slider-indicator mui-segmented-control mui-segmented-control-inverted">
        <a class="mui-control-item mui-active" href="#page1" id="address">
            请选择
        </a>
        <a class="mui-control-item" href="#page2" id="city">

        </a>
        <a class="mui-control-item" href="#page3" id="county">

        </a>
    </div>
    <div id="sliderProgressBar" class="mui-slider-progress-bar mui-col-xs-4"></div>
    <div class="mui-slider-group" id="mui-slider-group">
        <!--省-->
        <div id="page1" class="mui-slider-item mui-control-content mui-active">
            <div class="mui-content mui-scroll-wrapper">
                <div class="mui-scroll">
                    <ul class="mui-table-view">
                        <li ng-click="nationwide()" class="mui-table-view-cell">全国</li>
                        <li ng-click="selectProvince(address.cityList, address.shortName, address.id, address.mergerName, $event)" class="mui-table-view-cell" ng-repeat="address in addressList"><span></span>{{address.shortName}}</li>
                    </ul>
                </div>
            </div>
        </div>

        <!--市-->
        <div id="page2" class="mui-slider-item mui-control-content">
            <div class="mui-content mui-scroll-wrapper">
                <div class="mui-scroll">
                    <ul class="mui-table-view">
                        <li ng-click="selectCity(city.cityList, city.name, city.id, city.mergerName,$event)" class="mui-table-view-cell" ng-repeat="city in addressCity"><span></span>{{city.shortName}}</li>
                    </ul>
                </div>
            </div>
        </div>

        <!--县-->
        <div id="page3" class="mui-slider-item mui-control-content">
            <div class="mui-content mui-scroll-wrapper">
                <div class="mui-scroll">
                    <ul class="mui-table-view">
                        <li ng-click="selectCounty(county.id, county.mergerName)" class="mui-table-view-cell" ng-repeat="county in addressCounty">{{county.shortName}}</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="mui-content-padded fix">
    <button class="mui-btn mui-btn-block bg-color" ng-click="accomplish()">完成 </button>
</div>

<%@include file="../common/js.jsp" %>
<script>

    (function($) {
        //左右却换加载
        document.getElementById('slider').addEventListener('slide', function(e) {
            CC.print(e.detail.slideNumber);
            if (e.detail.slideNumber == 0) {

            }
            else if (e.detail.slideNumber == 1) {

            }
            else if (e.detail.slideNumber == 2) {

            }
        });
    })(mui);

    mui(".mui-scroll-wrapper").scroll();

    var webApp = angular.module('webApp', []);
    webApp.controller('addressController', function($scope, $http, $timeout) {
        $scope.roleId = CC.getUrlParam("roleId");
        $scope.addressList = null;
        $scope.addressCity = null;
        $scope.addressCounty = null;
        $scope.cityId = null;
        $scope.mergerName = null;
        $scope.levelType = 0;
        CC.ajaxRequestData("get", false, "city/getCities", {}, function (result) {
            $scope.addressList = result.data;
        });

        //选择省
        $scope.selectProvince = function (cityList, shortName, cityId, mergerName, event) {
            $scope.cityId = cityId;
            $scope.mergerName = mergerName;
            $scope.levelType = 1;
            var obj = event.target; //获取当前对象
            $("#page1 .mui-table-view-cell").removeClass("active");
            $(obj).addClass("active");
            $scope.addressCity = cityList;
            $("#city").html(shortName);
            $("#address").html(shortName);
            //js 触发 slider方式
            var gallery = mui('.mui-slider');
            gallery.slider().gotoItem(1);

            //重置县
            $timeout(function () {
                $scope.addressCounty = null;
            });
            $("#county").html("");
        }

        //选择市
        $scope.selectCity = function (cityList, shortName, cityId, mergerName, event) {
            $scope.cityId = cityId;
            $scope.mergerName = mergerName;
            $scope.levelType = 2;

            var obj = event.target; //获取当前对象
            $("#page2 .mui-table-view-cell").removeClass("active");
            $(obj).addClass("active");

            $scope.addressCounty = cityList;
            $("#county").html(shortName);
            //js 触发 slider方式
            var gallery = mui('.mui-slider');
            gallery.slider().gotoItem(2);
        }

        //选择县
        $scope.selectCounty = function (cityId, mergerName) {
            CC.print(cityId);
            CC.print(mergerName);
            var json = {
                cityId : cityId,
                mergerName : mergerName,
                levelType : 3
            }
            sessionStorage.setItem("selectAddress", JSON.stringify(json));
            window.history.back();
        }

        //选择全国
        $scope.nationwide = function () {
            var json = {
                cityId : 100000,
                mergerName : "全国",
                levelType : 1
            }
            sessionStorage.setItem("selectAddress", JSON.stringify(json));
            window.history.back();
        }

        //提交
        $scope.accomplish = function () {
            if ($scope.cityId == null) {
                mui.toast("请选择地址.");
            }
            else {
                var json = {
                    cityId : $scope.cityId,
                    mergerName : $scope.mergerName,
                    levelType : $scope.levelType
                }
                sessionStorage.setItem("selectAddress", JSON.stringify(json));
                window.history.back();
            }
        }
    });

    $(function() {
        var height = document.body.clientHeight;
        $(".mui-slider-item").css("minHeight", (height - 40) + "px");
    });

</script>

</body>
</html>
