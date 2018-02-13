
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>学习</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/study/study.css">
    <style>
        /*隐藏下拉样式*/
        .mui-pull-top-pocket .mui-pull-loading:before,
        .mui-pull-top-pocket .mui-pull-loading:after,
        .mui-pull-top-pocket .mui-spinner:after {
            content: '' !important;
            background: none !important;
        }

        #page2 .mui-pull-bottom-pocket .mui-pull-loading:after,
        #page2 .mui-pull-bottom-pocket .mui-pull-loading:before{
            content: '' !important;
            background: none !important;
        }
    </style>
</head>
<body ng-app="webApp">

<div id="slider" class="mui-slider">
    <div id="sliderSegmentedControl" class="mui-slider-indicator mui-segmented-control mui-segmented-control-inverted">
        <a class="mui-control-item mui-active" href="#page1">
            课程学习
        </a>
        <a class="mui-control-item" href="#page2">
            考题
        </a>
    </div>
    <div id="sliderProgressBar" class="mui-slider-progress-bar mui-col-xs-6"></div>
    <div class="mui-slider-group" id="mui-slider-group">
        <!--课程学习-->
        <div id="page1" class="mui-slider-item mui-control-content mui-active">
            <div id="pullrefreshCourse" class="mui-content mui-scroll-wrapper">
                <div class="mui-scroll">
                    <div class="not-data">没有课程.</div>
                    <ul class="mui-table-view mui-table-view-chevron" id="courseList">

                    </ul>
                </div>
            </div>
        </div>

        <!--考题-->
        <div id="page2" class="mui-slider-item mui-control-content">
            <div id="pullrefreshTopic" class="mui-content mui-scroll-wrapper">
                <div ng-controller="controller" ng-cloak>
                    <!-- 练习题 -->
                    <ul class="mui-table-view mui-table-view-chevron">
                        <li class="mui-table-view-cell">
                            <a href="<%=request.getContextPath()%>/page/exerciseBank">
                                <img src="<%=request.getContextPath()%>/resources/img/study/5.png">
                                <span class="name">练习题</span>
                                <span class="right-img">
                                    <span class="right-name">去练习</span>
                                    <img src="<%=request.getContextPath()%>/resources/img/study/7.png">
                                </span>
                            </a>
                        </li>
                        <li class="mui-table-view-cell statisticalRate-bar">
                            <a href="javascript:;">
                                <span class="haveToPractice">已练习</span>
                                <span class="topic-num">{{statisticsExamination.countNum}}</span>
                                <span class="topic-hint">(题)</span>
                                <span class="rate">
                                    <span class="haveToPractice">已练习</span>
                                    <span class="percentage">{{statisticsExamination.correctPercent * 100 | number : 1}}%</span>
                                </span>
                            </a>
                        </li>
                    </ul>

                    <!-- 错题库 -->
                    <ul class="mui-table-view mui-table-view-chevron">
                        <li class="mui-table-view-cell">
                            <a href="<%=request.getContextPath()%>/page/errorBank">
                                <img src="<%=request.getContextPath()%>/resources/img/study/6.png">
                                <span class="name">错题库</span>
                                <span class="wrong-num">({{statisticsExamination.errorNum}})</span>
                                <span class="right-img">
                                    <span class="right-name">查看</span>
                                    <img src="<%=request.getContextPath()%>/resources/img/study/7.png">
                                </span>
                            </a>
                        </li>
                    </ul>

                    <!-- 模拟题 -->
                    <ul class="mui-table-view mui-table-view-chevron">
                        <li class="mui-table-view-cell">
                            <a href="<%=request.getContextPath()%>/page/simulationBank">
                                <img src="<%=request.getContextPath()%>/resources/img/study/3.png">
                                <span class="name">模拟题</span>
                                <span class="right-img">
                                    <span class="right-name">去练习</span>
                                    <img src="<%=request.getContextPath()%>/resources/img/study/7.png">
                                </span>
                            </a>
                        </li>
                        <li class="mui-table-view-cell statisticalRate-bar">
                            <a href="javascript:;">
                                <span class="haveToPractice">已练习</span>
                                <span class="topic-num">{{statisticsExamination.simulationCountNum}}</span>
                                <span class="topic-hint">(题)</span>
                                <span class="rate">
                                    <span class="haveToPractice">已练习</span>
                                    <span class="percentage">{{statisticsExamination.simulationCorrectPercent * 100 | number : 1}}%</span>
                                </span>
                            </a>
                        </li>
                    </ul>

                    <!-- 正式考题 -->
                    <ul class="mui-table-view mui-table-view-chevron">
                        <li class="mui-table-view-cell">
                            <a href="<%=request.getContextPath()%>/page/examBank">
                                <img src="<%=request.getContextPath()%>/resources/img/study/4.png">
                                <span class="name">正式考题</span>
                                <span class="right-img">
                                    <span class="right-name">去考试</span>
                                    <img src="<%=request.getContextPath()%>/resources/img/study/7.png">
                                </span>
                            </a>
                        </li>
                        <li class="mui-table-view-cell statisticalRate-bar">
                            <a href="javascript:;">
                                <span class="haveToPractice">已通过</span>
                                <span class="topic-num">{{statisticsExamination.passNum}}</span>
                                <span class="rate">
                                    <span class="haveToPractice">未通过</span>
                                    <span class="percentage">{{statisticsExamination.nonPassNum}}</span>
                                </span>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

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
    mui.init();
    // 监听tap事件，解决 a标签 不能跳转页面问题
    mui('#tabBottom').on('tap','a',function(){document.location.href=this.href;});
    mui('#mui-slider-group').on('tap','a',function(){document.location.href=this.href;});
    //初始化上拉容器
    mui('#pullrefreshCourse').pullRefresh({
        container: '#pullrefreshCourse',
        down: {
            contentdown: "", //可选，在下拉可刷新状态时，下拉刷新控件上显示的标题内容
            contentover: "", //可选，在释放可刷新状态时，下拉刷新控件上显示的标题内容
            contentrefresh: "", //可选，正在刷新状态时，下拉刷新控件上显示的标题内容
            callback: function() {
                mui('#pullrefreshCourse').pullRefresh().endPulldownToRefresh(); //refresh completed
            }
        },
        up: {
            callback: pullrefreshCourse
        }
    });
    mui('#pullrefreshTopic').pullRefresh({
        container: '#pullrefreshTopic'
    });

    var webApp = angular.module('webApp', []);
    webApp.controller('controller', function($scope, $http, $timeout) {
        $scope.statisticsExamination = null;
        //获取考试统计
        CC.ajaxRequestData("post", false, "curriculum/statisticsCurriculum", {}, function (result) {
            $scope.statisticsExamination = result.data;
        });
    });

    var pageNo1 = 1
    var allHtml = getDataList(1, 10)
    if (allHtml == "") $(".not-data").show();
    else $("#courseList").html(allHtml);
    //课程上拉
    function pullrefreshCourse() {
        var html = getDataList(++pageNo1, 10);
        mui('#pullrefreshCourse').pullRefresh().scrollToBottom();
        setTimeout(function() {
            if(html == "") {
                mui('#pullrefreshCourse').pullRefresh().endPullupToRefresh((true)); //参数为true代表没有更多数据了。
                $(".mui-pull-caption-nomore").html("没有更多数据了.");
                pageNo1--;
            } else {
                mui('#pullrefreshCourse').pullRefresh().endPullupToRefresh((false));
                $("#courseList").append(html);
            }
        }, 1500);
    }

    //获取数据
    function getDataList (pageNO, pageSize) {
        CC.print("传入的页码：" + pageNO);
        var parameter = {
            pageNO: pageNO,
            pageSize: pageSize,
        }
        var dataList = null;
        CC.ajaxRequestData("post", false, "curriculum/queryCurriculumStudy", parameter, function (result) {
            dataList = result.data;
        });

        var html = "";
        for (var i = 0; i < dataList.length; i++) {
            var obj = dataList[i];
            obj.finishSeconds = obj.finishSeconds == null ? 0 : obj.finishSeconds;
            obj.videoSeconds = obj.videoSeconds == null ? 0 : obj.videoSeconds;
            var schedule = obj.finishSeconds / obj.videoSeconds * 100;
            var haveLearned = "";
            if (obj.finishSeconds >= obj.videoSeconds) {
                haveLearned = '<img class="haveLearned" src="' + CC.ip + 'resources/img/study/13.png"/>';
            }
            if (obj.passNum > 0) {
                haveLearned = '<img class="haveLearned" style="left: 5px; top: -19px;" src="' + CC.ip + 'resources/img/study/20.png"/>';
            }
            var url = "";
            if (obj.studyStatus == 0 || obj.studyStatus == 2) {
                url = "javascript: mui.toast('当前课程已被终止')";
            }
            else {
                url = CC.ip + 'page/courseVideo?orderId=' + obj.orderId + '&isAudition=0&curriculumId=' + obj.id;
            }
            html += '<li class="mui-table-view-cell mui-media">' +
                    '   <a href="' + url + '">' +
                    haveLearned +
                    '       <div class="mui-media-object mui-pull-left" style="background: url(' + CC.ipImg + obj.cover + ') no-repeat;background-size: cover;width: 100px;background-position:center;"></div>' +
                    '       <div class="mui-media-body">' +
                    '           <p class="mui-ellipsis title">' + obj.curriculumName + '</p>' +
                    '           <div class="course-info">' +
                    '               <p class="exercises-bar">' +
                    '                   <span>' + obj.examinationNum + '习题</span>' +
                    '                   <span>' + obj.videoNum + '个视频课</span>' +
                    '                   <span>' + obj.pptNum + '个讲义</span>' +
                    '               </p>' +
                    '               <p class="study-progress"><span style="width: ' + schedule + '%"></span></p>' +
                    '               <p class="list-num">' +
                    '                   <img src="' + CC.ip + 'resources/img/study/2.png">' +
                    '                   <span class="num-title">已学习<span class="num">' + CC.getFormat(obj.finishSeconds) + '</span></span>&nbsp;' +
                    '                   <img src="' + CC.ip + 'resources/img/study/1.png">' +
                    '                   <span class="num-title">共<span class="num">' + CC.getFormat(obj.videoSeconds) + '</span></span>' +
                    '               </p>' +
                    '           </div>' +
                    '       </div>' +
                    '   </a>' +
                    '</li>';
        }
        return html;
    }



    $(function() {
        var height = document.body.clientHeight;
        $("#page1").css("minHeight", (height - 110) + "px");
    });


</script>

</body>
</html>
