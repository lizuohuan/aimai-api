
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>错题库</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/study/exerciseBank.css">
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
        <div class="not-data">没有课程.</div>
        <!--数据列表-->
        <ul class="mui-table-view mui-table-view-chevron" id="dataList">
        </ul>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script>
    // 监听tap事件，解决 a标签 不能跳转页面问题
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
            pageSize: pageSize
        }
        var dataList = null;
        CC.ajaxRequestData("post", false, "curriculum/queryCurriculumError", arr, function (result) {
            dataList = result.data;
        });
        var html = "";
        for(var i = 0; i < dataList.length; i++) {
            var obj = dataList[i];
            html += '<li class="mui-table-view-cell mui-media">' +
                    '   <a href="javascript: courseWareList(' + obj.id + ', ' + obj.orderId + ', \'' + obj.curriculumName + '\')" class="mui-navigate-right">' +
                    '       <div class="mui-media-body">' +
                    '           <p class="list-title mui-ellipsis">' + obj.curriculumName + '</p>' +
                    '           <p class="list-num">' +
                    '               <img src="' + CC.ip + 'resources/img/my/3.png" />' +
                    '               <span class="num-title">' +
                    '                   <span class="num">' + obj.videoNum + '</span> 个视频课' +
                    '                   <span class="errors">错题<span>' + obj.errorNum + '</span>题</span>' +
                    '               </span>' +
                    '           </p>' +
                    '       </div>' +
                    '   </a>' +
                    '</li>';
        }
        return html;
    }

    //课件列表
    function courseWareList (curriculumId, orderId, curriculumName) {
        sessionStorage.setItem("curriculumName", curriculumName);
        location.href = CC.ip + "page/errorList?curriculumId=" + curriculumId + "&orderId=" + orderId;
    }
</script>

</body>
</html>
