
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>课程详情</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/course/courseInfo.css">
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
<body ng-app="webApp" ng-controller="courseInfoController">

<div class="mui-content" style="display: block;">

    <div class="course-cover" style="background: url('{{imgUrl}}{{curriculum.cover}}')"></div>

    <div class="collect-icon">
        <img ng-click="collect()" src="<%=request.getContextPath()%>/resources/img/course/1.png" />
    </div>

    <div class="collect-info" ng-cloak>
        <div class="mui-row title-bar">
            <div class="row-left">
                <div class="course-title">{{curriculum.curriculumName}}</div>
                <span class="course-badge">{{curriculum.stageName}}</span>
                <span class="course-badge">{{curriculum.year | date:'yyyy'}}年</span>
                <div class="list-num">
                    <div class="mui-row">
                        <div class="mui-col-xs-6">
                            <img src="<%=request.getContextPath()%>/resources/img/course/2.png" />
                            {{curriculum.videoNum}}个视频课
                        </div>
                        <div class="mui-col-xs-6">
                            <img src="<%=request.getContextPath()%>/resources/img/course/3.png" />
                            {{curriculum.hdSeconds}}
                        </div>
                    </div>
                </div>
            </div>
            <div class="row-left">
                ￥{{curriculum.price}}
                <div class="component">{{curriculum.number}}份</div>
            </div>

            <div class="mui-row">
                <div class="mui-col-xs-12">
                    <a class="watch-btn" href="<%=request.getContextPath()%>/page/studyCompany/studyUserList?orderId={{curriculum.orderId}}&flag=0">{{curriculum.watchNum == null ? 0 : curriculum.watchNum}}人已观看</a>
                    <a class="watch-btn">{{curriculum.countUser - curriculum.watchNum}}人未观看</a>
                    <a class="watch-btn" href="<%=request.getContextPath()%>/page/studyCompany/studyUserList?orderId={{curriculum.orderId}}&flag=1">{{curriculum.finishExamine == null ? 0 : curriculum.finishExamine}}人已考核</a>
                </div>
            </div>
        </div>
    </div>

    <div class="course-info">
        <div id="slider" class="mui-slider">
            <div id="sliderSegmentedControl" class="mui-slider-indicator mui-segmented-control mui-segmented-control-inverted">
                <a class="mui-control-item mui-active" href="#page1">
                    <img id="introduceImg" src="<%=request.getContextPath()%>/resources/img/course/4-4.png">
                    <span>介绍</span>
                </a>
                <a class="mui-control-item" href="#page2">
                    <img id="catalogueImg" src="<%=request.getContextPath()%>/resources/img/course/5.png">
                    <span>目录</span>
                </a>
                <a class="mui-control-item" href="#page3">
                    <img id="commentImg" src="<%=request.getContextPath()%>/resources/img/course/6.png">
                    <span>评论</span>
                </a>
            </div>
            <div id="sliderProgressBar" class="mui-slider-progress-bar mui-col-xs-4"></div>
            <div class="mui-slider-group" id="mui-slider-group">
                <!--介绍-->
                <div id="page1" class="mui-slider-item mui-control-content mui-active">
                    <div class="introduce-title">
                        <span class="perch"></span>
                        <span class="title">课程介绍</span>
                        <div class="introduce-context" ng-bind-html="curriculum.curriculumDescribe | trustHtml"></div>
                    </div>
                    <div class="introduce-title">
                        <span class="perch"></span>
                        <span class="title">讲师名称</span>
                        <div class="introduce-context" ng-bind-html="curriculum.teacherName | trustHtml"></div>
                    </div>
                    <div class="introduce-title">
                        <span class="perch"></span>
                        <span class="title">讲师介绍</span>
                        <div class="introduce-context" ng-bind-html="curriculum.teacherIntroduce | trustHtml"></div>
                    </div>
                    <div class="introduce-title">
                        <span class="perch"></span>
                        <span class="title">适用人群</span>
                        <div class="introduce-context" ng-bind-html="curriculum.applyPerson | trustHtml"></div>
                    </div>
                </div>

                <!--目录-->
                <div id="page2" class="mui-slider-item mui-control-content">
                    <div id="pullrefreshCatalogue" class="mui-content mui-scroll-wrapper">
                        <div class="mui-scroll">
                            <div class="not-data" ng-show="curriculum.courseWares.length == 0">暂无目录.</div>
                            <ul class="mui-table-view mui-table-view-chevron" id="catalogueList">
                                <li ng-repeat="course in curriculum.courseWares">
                                    <div class="mui-ellipsis catalogue" ng-repeat="video in course.videos">
                                        {{course.courseWareName}}：{{video.name}}
                                        <span class="catalogue-time">{{video.lowDefinitionSeconds}}</span>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!--评论-->
                <div id="page3" class="mui-slider-item mui-control-content">
                    <div id="pullrefreshComment" class="mui-content mui-scroll-wrapper">
                        <div class="mui-scroll">
                            <ul class="mui-table-view mui-table-view-chevron" id="commentList">
                                <div class="not-data">暂无评论.</div>
                            </ul>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <div class="fix-div">
        <div class="purchase-btn">
            <div class="mui-row">
                <div class="mui-col-xs-3" style="padding-right: 10px">
                    <a class="mui-btn mui-btn-block yellow-btn" ng-cloak>{{allocationNum}}/{{curriculum.number}}</a>
                </div>
                <div class="mui-col-xs-9">
                    <a class="mui-btn mui-btn-block fix-btn" ng-click="allocationCourse()">分配课程</a>
                </div>
            </div>
        </div>
    </div>

</div>

<%@include file="../common/js.jsp" %>
<script>
    CC.reload(); //刷新一下上一页传回来的东西
    var orderId = CC.getUrlParam("orderId"); //此处为orderId
    var curriculumId = CC.getUrlParam("curriculumId"); //此处为课程ID
    var webApp = angular.module('webApp', []);
    webApp.controller('courseInfoController', function($scope, $http, $timeout) {
        $scope.userInfo = CC.getUserInfo(); //登录人信息
        $scope.imgUrl = CC.ipImg; //图片IP
        $scope.allocationNum = CC.getUrlParam("allocationNum"); //allocationNum 已分配数量
        $scope.curriculum = null; //课程对象
        CC.ajaxRequestData("post", false, "curriculum/queryCurriculumByOrder", {orderId : orderId}, function (result) {
            $scope.curriculum = result.data;
            $scope.curriculum.hdSeconds = CC.getFormat($scope.curriculum.hdSeconds);
            for (var i = 0; i < $scope.curriculum.courseWares.length; i++) {
                var courseWares = $scope.curriculum.courseWares[i];
                for (var j = 0; j < courseWares.videos.length; j++) {
                    var video = courseWares.videos[j];
                    video.highDefinitionSeconds = CC.getFormatTime(video.highDefinitionSeconds);
                    video.lowDefinitionSeconds = CC.getFormatTime(video.lowDefinitionSeconds);
                }
            }
        });

        //收藏
        $scope.collect = function () {
            var parameter = {
                type : 1,
                targetId : curriculumId
            }
            CC.ajaxRequestData("post", false, "collect/addCollect", parameter, function (result) {
                mui.alert("收藏成功.");
            });
        }

        //分配课程
        $scope.allocationCourse = function () {
            if ($scope.allocationNum == $scope.curriculum.number) {
                mui.toast("已分配完.");
            }
            else {
                location.href = CC.ip + "page/studyCompany/allotUserList?curriculumId=" + $scope.curriculum.id;
            }
        }

    });
    //富文本过滤器
    webApp.filter('trustHtml', ['$sce',function($sce) {
        return function(val) {
            return $sce.trustAsHtml(val);
        };
    }]);

    var $introduceImg = $("#introduceImg");
    var $catalogueImg = $("#catalogueImg");
    var $commentImg = $("#commentImg");
    (function($) {
        //左右却换加载
        document.getElementById('slider').addEventListener('slide', function(e) {
            console.log(e.detail.slideNumber);
            if (e.detail.slideNumber == 0) {
                $introduceImg.attr("src", CC.ip + "resources/img/course/4-4.png");
                $catalogueImg.attr("src", CC.ip + "resources/img/course/5.png");
                $commentImg.attr("src", CC.ip + "resources/img/course/6.png");
            }
            else if (e.detail.slideNumber == 1) {
                $introduceImg.attr("src", CC.ip + "resources/img/course/4.png");
                $catalogueImg.attr("src", CC.ip + "resources/img/course/5-5.png");
                $commentImg.attr("src", CC.ip + "resources/img/course/6.png");
            }
            else if (e.detail.slideNumber == 2) {
                $introduceImg.attr("src", CC.ip + "resources/img/course/4.png");
                $catalogueImg.attr("src", CC.ip + "resources/img/course/5.png");
                $commentImg.attr("src", CC.ip + "resources/img/course/6-6.png");
            }
        });
    })(mui);

    //初始化上拉容器
    mui('#pullrefreshCatalogue').pullRefresh({
        container: '#pullrefreshCatalogue',
        down: {
            contentdown: "", //可选，在下拉可刷新状态时，下拉刷新控件上显示的标题内容
            contentover: "", //可选，在释放可刷新状态时，下拉刷新控件上显示的标题内容
            contentrefresh: "", //可选，正在刷新状态时，下拉刷新控件上显示的标题内容
            callback: function() {
                mui('#pullrefreshCatalogue').pullRefresh().endPulldownToRefresh(); //refresh completed
            }
        },
        up: {
            callback: pullrefreshCatalogue
        }
    });
    mui('#pullrefreshComment').pullRefresh({
        container: '#pullrefreshComment',
        down: {
            contentdown: "", //可选，在下拉可刷新状态时，下拉刷新控件上显示的标题内容
            contentover: "", //可选，在释放可刷新状态时，下拉刷新控件上显示的标题内容
            contentrefresh: "", //可选，正在刷新状态时，下拉刷新控件上显示的标题内容
            callback: function() {
                mui('#pullrefreshComment').pullRefresh().endPulldownToRefresh(); //refresh completed
            }
        },
        up: {
            callback: pullrefreshComment
        }
    });

    var pageNo1 = 0; // 目录分页页码
    var pageNo2 = 1; // 评论分页页码

    //目录上拉
    function pullrefreshCatalogue() {
        var html = getDataList(1, 10, 0);
        mui('#pullrefreshCatalogue').pullRefresh().scrollToBottom();
        setTimeout(function() {
            if(html == "") {
                mui('#pullrefreshCatalogue').pullRefresh().endPullupToRefresh((true)); //参数为true代表没有更多数据了。
                $(".mui-pull-caption-nomore").html("没有更多数据了.");
                pageNo1--;
            } else {
                mui('#pullrefreshCatalogue').pullRefresh().endPullupToRefresh((false));
                $("#catalogueList").append(html);
            }
        }, 1500);
    }

    //评论上拉
    function pullrefreshComment() {
        var html = getDataList(++pageNo2, 10, 1);
        mui('#pullrefreshComment').pullRefresh().scrollToBottom();
        setTimeout(function() {
            if(html == "") {
                mui('#pullrefreshComment').pullRefresh().endPullupToRefresh((true)); //参数为true代表没有更多数据了。
                $(".mui-pull-caption-nomore").html("没有更多数据了.");
                pageNo2--;
            } else {
                mui('#pullrefreshComment').pullRefresh().endPullupToRefresh((false));
                $("#commentList").append(html);
            }
        }, 1500);
    }

    var allHtml = getDataList(1, 10, 1);
    if (allHtml == "") $(".not-data").show();
    else $("#commentList").html(allHtml);

    //获取数据
    function getDataList (pageNO, pageSize, type) {

        CC.print("传入的页码：" + pageNO);
        var parameter = {
            pageNO: pageNO,
            pageSize: pageSize,
            curriculumId : curriculumId
        }

        if (type == 0) {
            var html = "";
            for (var i = 0; i < 0; i++) {
                html += '<li class="mui-ellipsis catalogue">答复阿斯蒂是的阿斯蒂芬阿斯蒂芬是的答复阿斯蒂是的阿斯蒂芬阿斯蒂芬是的' +
                            '<span class="catalogue-time">19:30</span>' +
                        '</li>';
            }
            return html;
        }
        else if (type == 1) {
            var html = "";
            var dataList = null;
            CC.ajaxRequestData("post", false, "evaluate/queryEvaluate", parameter, function (result) {
                dataList = result.data;
            });
            for (var i = 0; i < dataList.length; i++) {
                var avatar = dataList[i].avatar == null ? CC.ip + "resources/img/my/11.png" : CC.ipImg + dataList[i].avatar;
                var dateTime = CC.getCountTime(dataList[i].createTime, dataList[i].timeStamp);
                html += '<li class="mui-table-view-cell mui-media">' +
                        '   <i class="mui-media-object mui-pull-left head" style="background: url(' + avatar + ');"></i>' +
                                '<div class="mui-media-body">' +
                                    '<p class="mui-ellipsis">' + dataList[i].userName + '</p>' +
                                    '<p class="mui-ellipsis comment-time">' + dateTime + '</p>' +
                                    '<div class="comment-context">' + dataList[i].content + '</div>' +
                                '</div>' +
                        '</li>';
            }
            return html;
        }

    }

</script>

</body>
</html>
