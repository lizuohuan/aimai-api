
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>我的收藏</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/my/myCollect.css">
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
            课程
        </a>
        <a class="mui-control-item" href="#page2">
            考题
        </a>
        <a class="mui-control-item" href="#page3">
            资讯
        </a>
    </div>
    <div id="sliderProgressBar" class="mui-slider-progress-bar mui-col-xs-4"></div>
    <div class="mui-slider-group" id="mui-slider-group">
        <!--课程-->
        <div id="page1" class="mui-slider-item mui-control-content mui-active">
            <div id="pullrefreshCourse" class="mui-content mui-scroll-wrapper">
                <div class="mui-scroll">
                    <ul class="mui-table-view mui-table-view-chevron" id="courseList">
                        <div class="not-data">暂无相关收藏.</div>
                    </ul>
                </div>
            </div>
        </div>

        <!--考题-->
        <div id="page2" class="mui-slider-item mui-control-content">
            <div id="pullrefreshCollect" class="mui-content mui-scroll-wrapper">
                <div class="mui-scroll">
                    <div class="mui-table-view mui-table-view-chevron" id="collectList">
                        <ul class="mui-table-view">
                            <div class="not-data">暂无相关收藏.</div>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!--资讯-->
        <div id="page3" class="mui-slider-item mui-control-content">
            <div id="pullrefreshInformation" class="mui-content mui-scroll-wrapper">
                <div class="mui-scroll">
                    <ul class="mui-table-view mui-table-view-chevron" id="informationList">
                        <div class="not-data">暂无相关收藏.</div>
                    </ul>
                </div>
            </div>
        </div>

    </div>
</div>

<%@include file="../common/js.jsp" %>
<script>
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
    mui('#pullrefreshCollect').pullRefresh({
        container: '#pullrefreshCollect',
        down: {
            contentdown: "", //可选，在下拉可刷新状态时，下拉刷新控件上显示的标题内容
            contentover: "", //可选，在释放可刷新状态时，下拉刷新控件上显示的标题内容
            contentrefresh: "", //可选，正在刷新状态时，下拉刷新控件上显示的标题内容
            callback: function() {
                mui('#pullrefreshCollect').pullRefresh().endPulldownToRefresh(); //refresh completed
            }
        },
        up: {
            callback: pullrefreshCollect
        }
    });
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

    var pageNo1 = 1;
    var pageNo2 = 1;
    var pageNo3 = 1;

    var isComeNo1 = 0;
    var isComeNo2 = 0; //判断是否换过
    //默认加载一次
    var allHtml = getDataList(1, 10, 1)
    if (allHtml == "") $("#courseList .not-data").show();
    else $("#courseList").html(allHtml);

    var collectList = $("#collectList");
    var informationList = $("#informationList");

    //左右却换加载
    (function($) {
        document.getElementById('slider').addEventListener('slide', function(e) {
            CC.print(e.detail.slideNumber);
            if (e.detail.slideNumber == 0) {

            }
            else if (e.detail.slideNumber == 1 && isComeNo1 == 0) {
                var ohHtml = getDataList(1, 10, 2);
                if (ohHtml == "") collectList.find(".not-data").show();
                else collectList.html(ohHtml);
                isComeNo1 = 1;
            }
            else if (e.detail.slideNumber == 2 && isComeNo2 == 0) {
                var ohHtml = getDataList(1, 10, 0);
                if (ohHtml == "") informationList.find(".not-data").show();
                else informationList.html(ohHtml);
                isComeNo2 = 1;
            }
        });
    })(mui);

    //课程上拉
    function pullrefreshCourse() {
        var html = getDataList(++pageNo1, 10, 1);
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

    //考题上拉
    function pullrefreshCollect() {
        var html = getDataList(++pageNo2, 10, 2);
        mui('#pullrefreshCollect').pullRefresh().scrollToBottom();
        setTimeout(function() {
            if(html == "") {
                mui('#pullrefreshCollect').pullRefresh().endPullupToRefresh((true)); //参数为true代表没有更多数据了。
                $(".mui-pull-caption-nomore").html("没有更多数据了.");
                pageNo2--;
            } else {
                mui('#pullrefreshCollect').pullRefresh().endPullupToRefresh((false));
                $("#collectList").append(html);
            }
        }, 1500);
    }

    //资讯上拉
    function pullrefreshInformation() {
        var html = getDataList(++pageNo3, 10, 0);
        mui('#pullrefreshInformation').pullRefresh().scrollToBottom();
        setTimeout(function() {
            if(html == "") {
                mui('#pullrefreshInformation').pullRefresh().endPullupToRefresh((true)); //参数为true代表没有更多数据了。
                $(".mui-pull-caption-nomore").html("没有更多数据了.");
                pageNo3--;
            } else {
                mui('#pullrefreshInformation').pullRefresh().endPullupToRefresh((false));
                $("#informationList").append(html);
            }
        }, 1500);
    }

    //获取数据
    function getDataList (pageNO, pageSize, type) {
        var parameter = {
            pageNO : pageNO,
            pageSize : pageSize,
            type : type
        }
        var dataList = null;
        CC.ajaxRequestData("post", false, "collect/queryCollect", parameter, function (result) {
            dataList = result.data;
        });

        //课程
        if (type == 1) {
            var html = "";
            for (var i = 0; i < dataList.length; i++) {
                html += '<li class="mui-table-view-cell mui-media">' +
                        '   <a href="'+ CC.ip +'page/courseInfo?curriculumId=' + dataList[i].id + '">' +
                        '       <div class="mui-media-object mui-pull-left" style="background: url(' + CC.ipImg + dataList[i].cover + ')"></div>' +
                        '       <div class="mui-media-body">' +
                        '           <div class="list-title">' +
                        '               <p>' + dataList[i].curriculumName + '</p>' +
                        '           </div>' +
                        '           <p class="list-num">' +
                        '               <img src="' + CC.ip + '/resources/img/my/3.png" />' +
                        '               <span class="num-title">' +
                        '                   <span class="num"> ' + dataList[i].videoNum + '</span> 个视频课' +
                        '               </span>' +
                        '           </p>' +
                        '       </div>' +
                        '   </a>' +
                        '</li>';
            }
            return html;
        }
        //考题
        else if (type == 2) {
            var html = "";
            for (var i = 0; i < dataList.length; i++) {
                var obj = dataList[i];
                var typeHtml = "<span class=\"topic-type\">单选题&nbsp;</span>";
                if (obj.type == 1) {
                    typeHtml = "<span class=\"topic-type\">多选题&nbsp;</span>";
                }
                else if (obj.type == 2) {
                    typeHtml = "<span class=\"topic-type\">判断题&nbsp;</span>";
                }

                var examinationItemsListHtml = "";
                var answer = "";
                for (var j = 0; j < obj.examinationItemsList.length; j++) {
                    var item = obj.examinationItemsList[j];
                    examinationItemsListHtml += "<p class=\"topic-answer\">" + letter(j) + "、" + item.itemTitle + "</p>";
                    if (item.isCorrect == 1) {
                        answer = letter(j);
                    }
                }
                html += '<ul class="mui-table-view">' +
                        '<li class="mui-table-view-cell" style="margin-top:10px">' +
                        typeHtml +
                        '<span class="topic-title">' + obj.title + '（）</span>' +
                        examinationItemsListHtml +
                        '</li>' +
                        '<li class="mui-table-view-cell">' +
                        '<p class="analysis">' +
                        '<span class="blue-badge">答案</span>' +
                        '<span class="answer">' + answer + '</span>' +
                        '</p>' +
                        '<p class="analysis">' +
                        '<span class="gray-badge">考点</span>' +
                        '<span class="analysis-context">' + obj.emphasis + '</span>' +
                        '</p>' +
                        '<p class="analysis">' +
                        '<span class="gray-badge">解析</span>' +
                        '<span class="analysis-context">' + obj.examinationKey + '</span>' +
                        '</p>' +
                        '</li>' +
                        '</ul>';
            }
            return html;
        }
        else if (type == 0) {
            var html = "";
            for (var i = 0; i < dataList.length; i++) {
                var dateTime = CC.getCountTime(dataList[i].createTime, new Date().getTime());
                html += '<li class="mui-table-view-cell mui-media">' +
                        '<a href="javascript:;">' +
                        '<img class="mui-media-object mui-pull-left" src="' + CC.ipImg + dataList[i].image + '">' +
                        '<div class="mui-media-body">' +
                        '<div class="list-title"><p>' + dataList[i].title + '</p></div>' +
                        '<p class="list-time">' +
                        '<span class="time">' + dateTime + '前</span>' +
                        '</p>' +
                        '<span class="collect-num"><img src="' + CC.ip + 'resources/img/index/4.png"/>' + dataList[i].collectNum + '</span>' +
                        '</div>' +
                        '</a>' +
                        '</li>';
            }
            return html;
        }

    }

    //字母
    function letter (sortNum) {
        if (sortNum == 0) return "A";
        if (sortNum == 1) return "B";
        if (sortNum == 2) return "C";
        if (sortNum == 3) return "D";
        if (sortNum == 4) return "E";
        if (sortNum == 5) return "F";
        if (sortNum == 6) return "G";
        if (sortNum == 7) return "H";
        if (sortNum == 8) return "I";
        if (sortNum == 9) return "J";
        if (sortNum == 10) return "K";
    }

    $(function() {
        $(".list-title").each(function (i) {
            var divH = $(this).height();
            var $p = $("p", $(this)).eq(0);
            while ($p.outerHeight() > divH) {
                $p.text($p.text().replace(/(\s)*([a-zA-Z0-9]+|\W)(\.\.\.)?$/, "..."));
            };
        });
        var height = document.body.clientHeight;
        $(".mui-slider-item").css("minHeight", (height - 50) + "px");
    });
</script>

</body>
</html>
