
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>首页</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/swiper.min.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/index/index.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/mui.picker.min.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/mui.poppicker.css">
    <style>
        /*隐藏下拉样式*/
        .mui-pull-top-pocket .mui-pull-loading:before,
        .mui-pull-top-pocket .mui-pull-loading:after,
        .mui-pull-top-pocket .mui-spinner:after {
            content: '' !important;
            background: none !important;
        }
    </style>
</head>
<body ng-app="webApp" ng-controller="indexController" ng-cloak>

<div class="mui-content">
    <div id="pullrefreshInformation" class="mui-content mui-scroll-wrapper">
        <div class="mui-scroll">
            <div class="swiper-container">
                <div class="swiper-wrapper">
                    <div class="swiper-slide" ng-repeat="banner in bannerList">
                        <a ng-show="banner.isLink == 1" href="{{banner.linkUrl}}">
                            <div class="banner-cover" style="background: url('{{ipImg}}{{banner.apiImage}}')"></div>
                        </a>
                        <a ng-show="banner.isLink != 1" href="<%=request.getContextPath()%>/page/bannerInfo?bannerId={{banner.id}}">
                            <div class="banner-cover" style="background: url('{{ipImg}}{{banner.apiImage}}')"></div>
                        </a>
                    </div>
                </div>
                <div class="swiper-pagination"></div>
            </div>

            <!-- 标签 -->
            <div class="home-label">
                <div class="mui-row">
                    <div class="mui-col-sm-4 mui-col-xs-4">
                        <a href="<%=request.getContextPath()%>/page/aboutUs">
                            <img src="<%=request.getContextPath()%>/resources/img/index/1.png"/>
                            <span>关于我们</span>
                        </a>

                    </div>
                    <div class="mui-col-sm-4 mui-col-xs-4">
                        <a href="<%=request.getContextPath()%>/page/aptitude">
                            <img src="<%=request.getContextPath()%>/resources/img/index/2.png"/>
                            <span>资质</span>
                        </a>
                    </div>
                    <div class="mui-col-sm-4 mui-col-xs-4">
                        <a href="<%=request.getContextPath()%>/page/branch">
                            <img src="<%=request.getContextPath()%>/resources/img/index/3.png"/>
                            <span>网点</span>
                        </a>
                    </div>
                </div>
            </div>

            <!-- 资讯 -->
            <div class="home-news">
                <h3 class="news-consult">新闻咨询
                    <span id="clickPackUp" class="packUp"><span id="font">收起</span> <i class="fa fa-angle-up"></i></span>
                </h3>
                <div class="screen-bar" id="screenBar">
                    <div class="screen-item">
                        <span class="hint">地区</span>
                        <div class="right-bar" id="region">
                            <span id="nationwide" class="screen-active">全国</span>
                            <span id="showProvince">
                                <i id="province">省</i>
                                <i class="icon-below"></i>
                            </span>
                            <span id="showCity">
                                <i id="city">市</i>
                                <i class="icon-below"></i>
                            </span>
                        </div>
                    </div>
                    <div class="screen-item">
                        <span class="hint">类型</span>
                        <div class="right-bar" id="tradeType">
                            <span class="screen-active" data-id="1">行业动态</span>
                            <span data-id="2">重大新闻</span>
                            <span data-id="3">安全事故</span>
                            <span data-id="4">安全常识</span>
                            <span data-id="5">考试</span>
                            <span data-id="6">其他</span>
                        </div>
                    </div>
                    <div class="screen-item">
                        <span class="hint">排序</span>
                        <div class="right-bar" id="hotDec">
                            <span class="screen-active" data-id="0">热门</span>
                            <span data-id="1">最新</span>
                        </div>
                    </div>
                    <div class="more-btn-div">
                        <a class="news-more" href="<%=request.getContextPath()%>/page/newsList">查看更多</a>
                    </div>
                </div>
            </div>


            <!-- 资讯列表 -->
            <div class="news-list">
                <ul class="mui-table-view mui-table-view-chevron" id="informationList">

                </ul>
            </div>
        </div>
    </div>
</div>

<!--底部tab切换-->
<nav class="mui-bar mui-bar-tab tab-bottom" id="tabBottom">
    <a class="mui-tab-item mui-active" href="javascript:void(0)">
        <div class="tab-icon"><img src="<%=request.getContextPath()%>/resources/img/tab/1-1.png"></div>
        <span class="mui-tab-label">首页</span>
    </a>
    <a class="mui-tab-item" href="<%=request.getContextPath()%>/page/course">
        <div class="tab-icon"><img src="<%=request.getContextPath()%>/resources/img/tab/2.png"></div>
        <span class="mui-tab-label">课程</span>
    </a>
    <a class="mui-tab-item studyJurisdiction" href="<%=request.getContextPath()%>/page/study">
        <div class="tab-icon"><img src="<%=request.getContextPath()%>/resources/img/tab/3.png"></div>
        <span class="mui-tab-label">学习</span>
    </a>
    <a class="mui-tab-item" href="<%=request.getContextPath()%>/page/my">
        <div class="tab-icon"><img src="<%=request.getContextPath()%>/resources/img/tab/4.png"></div>
        <span class="mui-tab-label">我的</span>
    </a>
</nav>

<%@include file="../common/js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/swiper.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/mui.picker.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/mui.poppicker.js"></script>
<script>

    var cityId = null, type = 1, sort = 0;

    mui.init();
    // 监听tap事件，解决 a标签 不能跳转页面问题
    mui('body').on('tap','a',function(){document.location.href=this.href;});

    var swiper = new Swiper('.swiper-container', {
        pagination: '.swiper-pagination',
        paginationClickable: true,
        centeredSlides: true,
        autoplay: 3000,
        /*loop: true,*/ //导致angularjs 循环多次
        autoplayDisableOnInteraction: false,
        observer:true,//修改swiper自己或子元素时，自动初始化swiper
        observeParents:true,//修改swiper的父元素时，自动初始化swiper
    });

    //资讯列表
    mui('#pullrefreshInformation').pullRefresh({
        container: '#pullrefreshInformation',
        down: {
            contentdown: "", //可选，在下拉可刷新状态时，下拉刷新控件上显示的标题内容
            contentover: "", //可选，在释放可刷新状态时，下拉刷新控件上显示的标题内容
            contentrefresh: "", //可选，正在刷新状态时，下拉刷新控件上显示的标题内容
            callback: function() {
                mui('#pullrefreshInformation').pullRefresh().endPulldownToRefresh(); //refresh completed
            }
        },
        up: {
            callback: pullrefreshInformation
        }
    });

    var temp = getDataList(1, 10, cityId, type, sort);
    if (temp == "") {
        $("#informationList").html("<div style='padding: 15px;text-align: center;color: #999999'>暂无数据</div>");
    }
    else {
        $("#informationList").html(getDataList(1, 10, cityId, type, sort));
    }

    var pageNo1 = 1;
    //资讯上拉
    function pullrefreshInformation() {
        var html = getDataList(++pageNo1, 10, cityId, type, sort);
        mui('#pullrefreshInformation').pullRefresh().scrollToBottom();
        setTimeout(function() {
            if(html == "") {
                mui('#pullrefreshInformation').pullRefresh().endPullupToRefresh((true)); //参数为true代表没有更多数据了。
                $(".mui-pull-caption-nomore").html("没有更多数据了.");
                pageNo1--;
            } else {
                mui('#pullrefreshInformation').pullRefresh().endPullupToRefresh((false));
                $("#informationList").append(html);
            }
        }, 1500);
    }
    //获取数据
    function getDataList (pageNO, pageSize, cityId, type, sort) {
        var parameter = {
            pageNO : pageNO,
            pageSize : pageSize,
            cityId: cityId,
            type: type,
            sort: sort
        }
        var dataList = null;
        CC.ajaxRequestData("post", false, "news/queryNewsList", parameter, function (result) {
            dataList = result.data;
        });
        var html = "";
        for (var i = 0; i < dataList.length; i++) {
            var obj = dataList[i];
            var dateTime = CC.getCountTime(obj.createTime, new Date().getTime());
            html += '<li class="mui-table-view-cell mui-media">' +
                    '<a href="javascript: skip(' + obj.id + ', ' + obj.isLink + ',\'' + obj.linkUrl + '\')">' +
                    '<img class="mui-media-object mui-pull-left" src="' + CC.ipImg + obj.image + '">' +
                    '<div class="mui-media-body">' +
                    '<div class="list-title"><p>' + obj.title + '</p></div>' +
                    '<p class="list-time">' +
                    '<span class="time">' + dateTime + '</span>' +
                    '</p>' +
                    '<span class="collect-num"><img src="' + CC.ip + 'resources/img/index/4.png"/>' + obj.collectNum + '</span>' +
                    '</div>' +
                    '</a>' +
                    '</li>';
        }
        return html;
    }

    function skip (id, isLink, linkUrl) {
        if (isLink == 1) {
            location.href = linkUrl;
        }
        else {
            location.href = CC.ip + "page/newsInfo?newsId=" + id;
        }
    }

    $(function () {
        $(".list-title").each(function (i) {
            var divH = $(this).height();
            var $p = $("p", $(this)).eq(0);
            while ($p.outerHeight() > divH) {
                $p.text($p.text().replace(/(\s)*([a-zA-Z0-9]+|\W)(\.\.\.)?$/, "..."));
            };
        });

        mui('#tradeType').on('tap', "span", function(){
            $("#tradeType").find("span").removeClass("screen-active");
            $(this).addClass("screen-active");
            type = $(this).attr("data-id");
            var temp = getDataList(1, 10, cityId, type, sort);
            if (temp == "") {
                $("#informationList").html("<div style='padding: 15px;text-align: center;color: #999999'>暂无数据</div>");
            }
            else {
                $("#informationList").html(temp);
            }
        });

        mui('#hotDec').on('tap', "span", function(){
            $("#hotDec").find("span").removeClass("screen-active");
            $(this).addClass("screen-active");
            sort = $(this).attr("data-id");
            var temp = getDataList(1, 10, cityId, type, sort);
            if (temp == "") {
                $("#informationList").html("<div style='padding: 15px;text-align: center;color: #999999'>暂无数据</div>");
            }
            else {
                $("#informationList").html(temp);
            }
        });

        mui('#region').on('tap', "#nationwide", function(){
            $(this).parent().find("span").removeClass("screen-active");
            $(this).addClass("screen-active");
            var temp = getDataList(1, 10, null, type, sort);
            if (temp == "") {
                $("#informationList").html("<div style='padding: 15px;text-align: center;color: #999999'>暂无数据</div>");
            }
            else {
                $("#informationList").html(temp);
            }
        });


        var isOpen = 0;
        mui('.news-consult').on('tap', "#clickPackUp", function(){
            if (isOpen == 0) { // 收起
                isOpen = 1;
                $("#screenBar").slideUp();
                $(this).find("#font").html("展开");
                $(this).find("i").removeClass("fa-angle-up").addClass("fa-angle-down");
            }
            else{ //展开
                $("#screenBar").slideDown();
                isOpen = 0;
                $(this).find("#font").html("收起");
                $(this).find("i").removeClass("fa-angle-down").addClass("fa-angle-up");
            }
        });



    });

    var webApp = angular.module('webApp', []);
    webApp.controller('indexController', function($scope, $http, $timeout) {
        $scope.userInfo = CC.getUserInfo(); //登录人信息
        $scope.bannerList = null;
        $scope.ipImg = CC.ipImg;
        CC.ajaxRequestData("post", false, "banner/queryBannerList", {}, function (result) {
            $scope.bannerList = result.data;
        });

        //banner详情
        $scope.bannerInfo = function (banner) {
            CC.print(banner);
            if (banner.isLink == 1) {
                location.href = banner.linkUrl;
            }
            else {
                sessionStorage.setItem("bannerInfo", JSON.stringify(banner));
            }
        }

    });

    var $showProvince = $("#showProvince");
    var $informationList = $("#informationList");

    (function($, doc) {
        $.init();
        $.ready(function() {
            //级联示例
            var cityPicker = new $.PopPicker({
                layer: 2
            });
            var cityData = [];
            CC.ajaxRequestData("post", false, "city/getCities", {}, function (result) {
                cityData = result.data;
                for (var i = 0; i < cityData.length; i++) {
                    cityData[i].value = cityData[i].id;
                    cityData[i].text = cityData[i].name;
                    for (var j = 0; j < cityData[i].cityList.length; j++) {
                        cityData[i].cityList[j].value = cityData[i].cityList[j].id;
                        cityData[i].cityList[j].text = cityData[i].cityList[j].name;
                    }
                    cityData[i].children = cityData[i].cityList;
                }
            });
            cityPicker.setData(cityData);
            var showProvince = doc.getElementById('showProvince');
            var showCity = doc.getElementById('showCity');
            showProvince.addEventListener('tap', function(event) {
                cityPicker.show(function(items) {
                    document.getElementById("province").innerHTML = items[0].name;
                    document.getElementById("city").innerHTML = items[1].name;
                    cityId = items[1].id;
                    pageNo1 = 1;
                    $showProvince.parent().find("span").removeClass("screen-active");
                    showProvince.className = "screen-active";
                    var temp = getDataList(1, 10, cityId, type, sort);
                    if (temp == "") {
                        $informationList.html("<div style='padding: 15px;text-align: center;color: #999999'>暂无数据</div>");
                    }
                    else {
                        $informationList.html(temp);
                    }
                });
            }, false);
            showCity.addEventListener('tap', function(event) {
                cityPicker.show(function(items) {
                    document.getElementById("province").innerHTML = items[0].name;
                    document.getElementById("city").innerHTML = items[1].name;
                    cityId = items[1].id;
                    pageNo1 = 1;
                    $showProvince.parent().find("span").removeClass("screen-active");
                    showCity.className = "screen-active";
                    var temp = getDataList(1, 10, cityId, type, sort);
                    if (temp == "") {
                        $informationList.html("<div style='padding: 15px;text-align: center;color: #999999'>暂无数据</div>");
                    }
                    else {
                        $informationList.html(temp);
                    }                });
            }, false);
        })
    })(mui, document);

</script>

</body>
</html>
