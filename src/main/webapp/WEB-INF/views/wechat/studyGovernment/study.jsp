
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>学习</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/studyCompany/study.css">
    <style>
        /*隐藏下拉样式*/
        .mui-pull-top-pocket .mui-pull-loading:before,
        .mui-pull-top-pocket .mui-pull-loading:after,
        .mui-pull-top-pocket .mui-spinner:after {
            content: '' !important;
            background: none !important;
        }
        /*政府学习*/
        .header{
            position: fixed;
            z-index: 9999;
            width: 100%;
            background: #F6F9FE;
        }
        .mui-indexed-list-search{
            background: #FFF;
            padding: 10px;
            height: initial !important;
            border: none !important;
        }
        .mui-indexed-list-search input{
            background-color: #FFF !important;
            border: 1px solid #e1e1e1;
            color: #000;
            font-size: 12px;
            border-radius: 4px !important;
            margin-bottom: 0;
        }
        .mui-input-row.mui-search .mui-icon-clear{
            top: 16px;
            right: 10px;
        }
        .mui-search .mui-placeholder .mui-icon{
            font-size: 18px;
            margin-right: 10px;
        }
        .mui-search .mui-placeholder{
            top: 10px;
            font-size: 12px;
        }
        .mui-indexed-list-search.mui-active:before{
            font-size: 16px;
            left:20px;
            color: #999999;
            margin-top: -10px;
        }
        .search-div{
            padding: 0;
            background: #fff;
            text-align: center;
        }
        .search-div .mui-input-row{
            height: inherit !important;
        }
        .search-div .search-input{
            display: inline-block;
            background: #FFF;
            font-size: 12px;
            border-radius: 0;
            border: 1px solid #E1E1E1;
            padding: 5px;
            width: 80%;
            color: #999999;
        }
        .search-div .mui-placeholder span{
            font-size: 12px;
        }
        .mui-icon-search:before{
            font-size: 15px;
            margin-right: 5px;
        }
        .user-size{
            padding: 10px;
            color: #000000;
        }
        .user-size span{
            color: #999999;
        }
        .user-size .num{
            color: #2e75b6;
        }
        .mui-content{
            padding-top: 139px;
        }
        .logo{
            border-radius: 10px !important;
            width: 42px !important;
            height: 42px !important;
            background-size: cover !important;
            background-position: center !important;
        }
        .address{
            color: #999999;
            padding-right: 110px;
            position: relative;
            width: 100%;
            overflow: hidden;
            text-overflow:ellipsis;
            white-space: nowrap;
        }
        .address img{
            width: 16px;
        }
        .name {
            padding-right: 15px;
        }
        .personnel{
            float: right;
            position: absolute;
            right: 15px;
        }
        .personnel .num{
            color: #2e75b6;
            margin: 0 3px;
        }
        .current-position{
            padding: 10px;
            font-size: 14px;
            text-align: center;
        }
        .current-position a{
            color: #000000;
        }
    </style>
</head>
<body ng-app="webApp" ng-controller="controller" ng-cloak>

<div class="header">
    <div class="current-position">
        <a href="<%=request.getContextPath()%>/page/address">
            <span id="address">{{selectAddress == null ? userInfo.city.mergerName : selectAddress.mergerName}}</span>
            <span class="mui-icon mui-icon-arrowdown"></span>
        </a>
    </div>
    <div class="search-div">
        <div class="mui-indexed-list-search mui-input-row mui-search">
            <input id="search" type="search" class="mui-input-clear mui-indexed-list-search-input" placeholder="搜索公司名称、地区">
        </div>
    </div>
    <div class="user-size">
        <span>共 <span class="num">{{dataInfo.companyNum}}</span> 个公司</span>、
        <span> <span class="num">{{dataInfo.safeNum}}</span> 位安全人员</span>
    </div>
</div>

<div id="pullrefreshCompany" class="mui-content mui-scroll-wrapper">
    <div class="mui-scroll">
        <div class="not-data">暂无数据.</div>
        <ul class="mui-table-view mui-table-view-chevron" id="dataList">

        </ul>

    </div>
</div>

<!--底部tab切换-->
<nav class="mui-bar mui-bar-tab tab-bottom" id="tabBottom">
    <a class="mui-tab-item" href="<%=request.getContextPath()%>/page/index">
        <div class="tab-icon"><img src="<%=request.getContextPath()%>/resources/img/tab/1.png"></div>
        <span class="mui-tab-label">首页</span>
    </a>
    <a class="mui-tab-item" href="<%=request.getContextPath()%>/page/course">
        <div class="tab-icon"><img src="<%=request.getContextPath()%>/resources/img/tab/2.png"></div>
        <span class="mui-tab-label">课程</span>
    </a>
    <a class="mui-tab-item mui-active" href="javascript:void(0)">
        <div class="tab-icon"><img src="<%=request.getContextPath()%>/resources/img/tab/3-3.png"></div>
        <span class="mui-tab-label">学习</span>
    </a>
    <a class="mui-tab-item" href="<%=request.getContextPath()%>/page/my">
        <div class="tab-icon"><img src="<%=request.getContextPath()%>/resources/img/tab/4.png"></div>
        <span class="mui-tab-label">我的</span>
    </a>
</nav>

<%@include file="../common/js.jsp" %>
<script>
    CC.reload();
    var selectAddress = sessionStorage.getItem("selectAddress") != null ? JSON.parse(sessionStorage.getItem("selectAddress")) : sessionStorage.getItem("selectAddress"); //获取已经选择地址
    CC.print(selectAddress);
    var webApp = angular.module('webApp', []);
    webApp.controller('controller', function($scope, $http, $timeout) {
        $scope.userInfo = CC.getUserInfo(); //登录人信息
        $scope.imgUrl = CC.ipImg; //获取图片服务器IP
        $scope.selectAddress = sessionStorage.getItem("selectAddress") != null ? JSON.parse(sessionStorage.getItem("selectAddress")) : sessionStorage.getItem("selectAddress"); //获取已经选择地址
        $scope.dataInfo = null;
        $scope.parameter = {
            cityId : $scope.selectAddress == null ? CC.getUserInfo().cityId : $scope.selectAddress.cityId,
            levelType : 3
        }
        CC.ajaxRequestData("post", false, "user/statistics", $scope.parameter, function (result) {
            $scope.dataInfo = result.data;
        });
    });

    //给搜索框绑定改变事件
    $('#search').bind('input propertychange', function() {
        var allHtml = getDataList(1, 10, $("#search").val());
        if (allHtml == ""){ $("#dataList").html(""); $(".not-data").show();}
        else {$("#dataList").html(allHtml);$(".not-data").hide();}
    });

    mui('body').on('tap','a',function(){document.location.href=this.href;});
    //初始化上拉容器
    mui('#pullrefreshCompany').pullRefresh({
        container: '#pullrefreshCompany',
        down: {
            contentdown: "", //可选，在下拉可刷新状态时，下拉刷新控件上显示的标题内容
            contentover: "", //可选，在释放可刷新状态时，下拉刷新控件上显示的标题内容
            contentrefresh: "", //可选，正在刷新状态时，下拉刷新控件上显示的标题内容
            callback: function() {
                mui('#pullrefreshCompany').pullRefresh().endPulldownToRefresh(); //refresh completed
            }
        },
        up: {
            callback: pullrefreshCompany
        }
    });

    var pageNo1 = 1;
    var allHtml = getDataList(1, 10, $("#search").val());
    if (allHtml == "") $(".not-data").show();
    else $("#dataList").html(allHtml);
    function pullrefreshCompany() {
        var html = getDataList(++pageNo1, 10, $("#search").val());
        mui('#pullrefreshCompany').pullRefresh().scrollToBottom();
        setTimeout(function() {
            if(html == "") {
                mui('#pullrefreshCompany').pullRefresh().endPullupToRefresh((true)); //参数为true代表没有更多数据了。
                $(".mui-pull-caption-nomore").html("没有更多数据了.");
                pageNo1--;
            } else {
                mui('#pullrefreshCompany').pullRefresh().endPullupToRefresh((false));
                $("#dataList").append(html);
            }
        }, 1500);
    }

    //获取数据
    function getDataList (pageNO, pageSize, searchParam) {

        var parameter = {
            pageNO: pageNO,
            pageSize: pageSize,
            searchParams : searchParam,
            cityId : selectAddress == null ? CC.getUserInfo().cityId : selectAddress.cityId
        }
        var dataList = null;
        CC.ajaxRequestData("post", false, "user/queryCompanyList", parameter, function (result) {
            dataList = result.data;
        });


        var html = "";
        for (var i = 0; i < dataList.length; i++) {
            var obj = dataList[i];
            obj.avatar = obj.avatar == null ? CC.ip + "resources/img/my/11.png" : CC.ipImg + obj.avatar;
            obj.joinNum = obj.joinNum == null ? 0 : obj.joinNum;
            html += '<li class="mui-table-view-cell mui-media">' +
                    '   <a href="' + CC.ip + 'page/studyGovernment/companyCourseInfo?companyId=' + obj.id + '">' +
                    '       <i class="mui-media-object mui-pull-left logo" style="background: url(' + obj.avatar + ')"></i>' +
                    '       <div class="mui-media-body">' +
                    '           <div class="name mui-ellipsis">' + obj.showName + '</div>' +
                    '           <div class="course-name mui-ellipsis">' +
                    '               <p class="address">' +
                    '                   <img src="' + CC.ip + 'resources/img/study/15.png">' +
                    '                   <span>' + obj.city.mergerName + '</span>' +
                    '                   <span class="personnel">参培人员<span class="num">' + obj.joinNum + '</span>员</span>' +
                    '               </p>' +
                    '           </div>' +
                    '       </div>' +
                    '   </a>' +
                    '</li>';
        }
        return html;
    }

</script>

</body>
</html>
