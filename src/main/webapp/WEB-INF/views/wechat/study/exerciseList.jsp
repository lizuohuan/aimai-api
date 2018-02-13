
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>学习题库</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/study/exerciseList.css">
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

<!--下拉刷新容器-->
<div id="pullrefresh" class="mui-content mui-scroll-wrapper">
    <div class="mui-scroll">
        <div class="not-data">没有课件.</div>
        <!--数据列表-->
        <ul class="mui-table-view mui-table-view-chevron" id="dataList">
            <li class="mui-table-view-cell mui-media">
                <a href="javascript:;" class="mui-navigate-right">
                    <div class="mui-media-body">
                        <p class="list-title mui-ellipsis">安全生产管理培训课
                            <span class="badge">已练习</span>
                        </p>
                        <p class="list-num">
                            共<span class="num">12</span> 题
                        </p>
                    </div>
                </a>
            </li>
        </ul>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script>
    mui('body').on('tap','a',function(){document.location.href=this.href;});
    mui.init({
        pullRefresh: {
            container: '#pullrefresh',
            down: {
                contentdown: "", //可选，在下拉可刷新状态时，下拉刷新控件上显示的标题内容
                contentover: "", //可选，在释放可刷新状态时，下拉刷新控件上显示的标题内容
                contentrefresh: "", //可选，正在刷新状态时，下拉刷新控件上显示的标题内容
                callback: function() {
                    mui('#pullrefresh').pullRefresh().endPulldownToRefresh(); //refresh completed
                }
            },
            up: {
                contentrefresh: '正在使劲加载...',
                callback: pullupRefresh,
                auto: false, //默认加载
            }
        }
    });

    var allHtml = getDataList(1, 10)
    if (allHtml == "") $(".not-data").show();
    else $("#dataList").html(allHtml);

    //下拉
    function pullLoad() {}
    var pageNo1 = 1;
    /**
     * 上拉加载具体业务实现
     */
    function pullupRefresh() {
        var html = getDataList(++pageNo1, 10);
        mui('#pullrefresh').pullRefresh().scrollToBottom();
        setTimeout(function() {
            if(html == "") {
                mui('#pullrefresh').pullRefresh().endPullupToRefresh((true)); //参数为true代表没有更多数据了。
                $(".mui-pull-caption-nomore").html("没有更多数据了.");
                pageNo1--;
            } else {
                mui('#pullrefresh').pullRefresh().endPullupToRefresh((false));
                $("#dataList").append(html);
            }
        }, 1500);
    }
    if(mui.os.plus) {
        mui.plusReady(function() {
            setTimeout(function() {
                mui('#pullrefresh').pullRefresh().pulldownLoading();
            }, 1000);

        });
    } else {
        mui.ready(function() {
            mui('#pullrefresh').pullRefresh().pulldownLoading();
        });
    }

    function getDataList(pageNO, pageSize) {
        console.debug("传入的页码：" + pageNO);
        var arr = {
            pageNO: pageNO,
            pageSize: pageSize,
            curriculumId : CC.getUrlParam("curriculumId"),
            orderId : CC.getUrlParam("orderId"),
        }
        var dataList = null;
        CC.ajaxRequestData("post", false, "courseWare/statisticsCourseWare", arr, function (result) {
            dataList = result.data;
        });
        var html = "";
        for(var i = 0; i < dataList.length; i++) {
            var obj = dataList[i];
            var isExamination = obj.isExamination == 0 ? "" : "<span class=\"badge\">已练习</span>";
            html += '<li class="mui-table-view-cell mui-media">' +
                    '   <a href="javascript: goExamList(' + obj.paperId + ', ' + obj.examinationNum + ', ' + obj.useTime + ', ' + obj.orderId + ', ' + obj.isExamination + ', ' + obj.isStudy + ', \'' + obj.courseWareName + '\')" class="mui-navigate-right">' +
                    '       <div class="mui-media-body">' +
                    '           <p class="list-title mui-ellipsis">' + obj.courseWareName + '' +
                    isExamination +
                    '           </p>' +
                    '           <p class="list-num">' +
                    '               共<span class="num">' + obj.examinationNum + '</span> 题' +
                    '           </p>' +
                    '       </div>' +
                    '   </a>' +
                    '</li>';
        }
        return html;
    }

    //去练习
    function goExamList (paperId, examinationNum, useTime, orderId, isExamination, isStudy, courseWareName) {
        if (paperId == null || examinationNum == 0) {
            mui.toast("没有练习题.");
        }
        else if (isStudy == 0) {
            mui.toast("您还没有学习完.");
        }
        else {
            if (isExamination == 1) {
                location.href = CC.ip + "page/submitAnswer?paperId=" + paperId + "&orderId=" + orderId;
            }
            else {
                sessionStorage.setItem("curriculumName", courseWareName); //TODO 此处为课件名字
                location.href = CC.ip + "page/examList?paperId=" + paperId + '&type=0&useTime=' + useTime + "&orderId=" + orderId;
            }
        }
    }

</script>

</body>
</html>
