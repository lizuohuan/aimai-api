
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
    </style>
</head>
<body>

<div id="slider" class="mui-slider">
    <div id="sliderSegmentedControl" class="mui-slider-indicator mui-segmented-control mui-segmented-control-inverted">
        <a class="mui-control-item mui-active" href="#page1">
            课程学习
        </a>
        <a class="mui-control-item" href="#page2">
            人员列表
        </a>
    </div>
    <div id="sliderProgressBar" class="mui-slider-progress-bar mui-col-xs-6"></div>
    <div class="mui-slider-group" id="mui-slider-group">
        <!--课程学习-->
        <div id="page1" class="mui-slider-item mui-control-content mui-active">
            <div id="pullrefreshCourse" class="mui-content mui-scroll-wrapper">
                <div class="mui-scroll">
                    <ul class="mui-table-view mui-table-view-chevron" id="courseList">
                        <div class="not-data">暂无课程</div>
                    </ul>
                </div>
            </div>
        </div>

        <!--人员列表-->
        <div id="page2" class="mui-slider-item mui-control-content">
            <div id="pullrefreshPerson" class="mui-content mui-scroll-wrapper">
                <div class="mui-scroll">
                    <div class="search-div">
                        <div class="mui-input-row mui-search">
                            <a class="search-input" href="<%=request.getContextPath()%>/page/studyCompany/searchUser">
                                <span class="mui-icon mui-icon-search"></span>
                                搜索名字、身份证、电话
                            </a>
                        </div>
                    </div>
                    <div class="user-size">
                        <span>共 <span id="peopleNum">0</span> 位员工</span>
                        <a href="<%=request.getContextPath()%>/page/studyCompany/searchUser">
                            <img src="<%=request.getContextPath()%>/resources/img/study/11.png">
                            添加员工
                        </a>
                    </div>

                    <ul class="mui-table-view mui-table-view-chevron" id="dataList">
                        <div class="not-data">暂无员工</div>
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
    mui('#pullrefreshPerson').pullRefresh({
        container: '#pullrefreshPerson',
        down: {
            contentdown: "", //可选，在下拉可刷新状态时，下拉刷新控件上显示的标题内容
            contentover: "", //可选，在释放可刷新状态时，下拉刷新控件上显示的标题内容
            contentrefresh: "", //可选，正在刷新状态时，下拉刷新控件上显示的标题内容
            callback: function() {
                mui('#pullrefreshPerson').pullRefresh().endPulldownToRefresh(); //refresh completed
            }
        },
        up: {
            callback: pullrefreshPerson
        }
    });

    var pageNo1 = 1;
    var allHtml = getDataList(1, 10, 0)
    if (allHtml == "") $("#courseList .not-data").show();
    else $("#courseList").html(allHtml);
    //课程上拉
    function pullrefreshCourse() {
        var html = getDataList(++pageNo1, 10, 0);
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

    var pageNo2 = 1;
    var allHtml = getDataList(1, 10, 1)
    if (allHtml == "") $("#dataList .not-data").show();
    else $("#dataList").html(allHtml);
    //人员列表上拉
    function pullrefreshPerson() {
        var html = getDataList(++pageNo2, 10, 1);
        mui('#pullrefreshPerson').pullRefresh().scrollToBottom();
        setTimeout(function() {
            if(html == "") {
                mui('#pullrefreshPerson').pullRefresh().endPullupToRefresh((true)); //参数为true代表没有更多数据了。
                $(".mui-pull-caption-nomore").html("没有更多数据了.");
                pageNo2--;
            } else {
                mui('#pullrefreshPerson').pullRefresh().endPullupToRefresh((false));
                $("#dataList").append(html);
            }
        }, 1500);
    }

    //获取数据
    function getDataList (pageNO, pageSize, type) {
        CC.print("传入的页码：" + pageNO);
        var parameter = {
            pageNO: pageNO,
            pageSize: pageSize,
        }
        var dataList = null;
        if (type == 0) {
            CC.ajaxRequestData("post", false, "curriculum/queryCurriculumStudy", parameter, function (result) {
                dataList = result.data;
            });

            var html = "";
            for (var i = 0; i < dataList.length; i++) {
                var obj = dataList[i];
                var schedule = obj.allocationNum / obj.number * 100;
                var haveLearned = "";
                if (obj.allocationNum == obj.number) {
                    //haveLearned = '<img class="haveLearned" src="' + CC.ip + 'resources/img/study/13.png"/>';
                }
                var allocationNum = obj.allocationNum == null ? 0 : obj.allocationNum;
                html += '<li class="mui-table-view-cell mui-media">' +
                        '   <a href="' + CC.ip + 'page/studyCompany/studyCompanyCourseInfo?orderId=' + obj.orderId + '&allocationNum=' + allocationNum + '&curriculumId=' + obj.id + '">' +
                        haveLearned +
                        '       <div class="mui-media-object mui-pull-left" style="background: url(' + CC.ipImg + obj.cover + ') no-repeat;background-size: cover;width: 100px;background-position:center;"></div>' +
                        '       <div class="mui-media-body">' +
                        '           <p class="mui-ellipsis title">' + obj.curriculumName + '</p>' +
                        '           <div class="course-info">' +
                        '               <div class="list-num2">' +
                        '                   <span class="num-title2">' +
                        '                       <img src="' +  CC.ip+ 'resources/img/my/3.png" />' +
                        '                       <span class="num2">' + obj.videoNum + '</span> 个视频课' +
                        '                   </span>' +
                        '               </div>' +
                        '               <p class="money">￥<span>' + obj.price + '</span></p>' +
                        '               <p class="study-progress"><span style="width: ' + schedule + '%"></span></p>' +
                        '           </div>' +
                        '       </div>' +
                        '       <p class="list-num">' +
                        '           <img src="' +  CC.ip+ 'resources/img/study/2.png">' +
                        '           <span class="num-title">已分配<span class="num">' + allocationNum + '</span>份</span>' +
                        '           <span style="float: right">' +
                        '               <img src="' +  CC.ip+ 'resources/img/study/1.png">' +
                        '               <span class="num-title">共<span class="num">' + obj.number + '</span>份</span>' +
                        '           </span>' +
                        '       </p>' +
                        '   </a>' +
                        '</li>';
            }
        }
        else {
            parameter = {
                searchParam : null,
                orderId : null,
                isAllocation : null,
                pageNO : pageNO,
                pageSize : pageSize
            }
            CC.ajaxRequestData("post", false, "user/queryUserForAllocation", parameter, function (result) {
                dataList = result.data;
            });

            var html = "";
            for (var i = 0; i < dataList.length; i++) {
                var obj = dataList[i];
                $("#peopleNum").html(obj.peopleNum);
                obj.avatar = obj.avatar == null ? CC.ip + "resources/img/my/11.png" : CC.ipImg + obj.avatar;
                obj.finishCourseWareNum = obj.finishCourseWareNum == null ? 0 : obj.finishCourseWareNum
                var passHtml = "";
                var passTimeHtml = "";
                var notPass = "";
                if (obj.isPass == 1) {
                    passHtml = "<span class=\"exam-pass\">考试通过</span>";
                    passTimeHtml = "<p class=\"pass-time\">通过时间：" + CC.timeStampConversion(obj.passTime) + "</p>";
                }
                else {
                    notPass = '<div class="course-hour">' +
                            '      <span>' + obj.finishCourseWareNum + '</span>课时' +
                            '      <p>已学习</p>' +
                            '  </div>';
                }
                var curriculumNameHtml = "";
                if (obj.curriculumName != null) {
                    curriculumNameHtml = '<img src="' + CC.ip + 'resources/img/study/12.png">' + obj.curriculumName + passTimeHtml;
                }
                html += '<li class="mui-table-view-cell mui-media">' +
                        '   <a href="' + CC.ip + 'page/studyCompany/userDetail?userId=' + obj.id + '">' +
                        '       <i class="mui-media-object mui-pull-left head" style="background: url(' + obj.avatar + ')"></i>' +
                        '       <div class="mui-media-body">' +
                        '           <div class="mui-row">' +
                        '               <div class="mui-col-xs-8">' +
                        '                   <div class="name">' + obj.showName + passHtml + '</div>' +
                        '                   <div class="course-name mui-ellipsis">' +
                        curriculumNameHtml +
                        '                   </div>' +
                        '               </div>' +
                        '               <div class="mui-col-xs-4">' +
                        notPass +
                        '               </div>' +
                        '           </div>' +
                        '       </div>' +
                        '   </a>' +
                        '</li>';
            }

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
