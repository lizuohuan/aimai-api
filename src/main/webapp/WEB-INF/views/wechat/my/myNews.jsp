
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>我的消息</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/my/myNews.css">
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
        <!--数据列表-->
        <div id="dataList">
            <div class="not-data">没有任何消息</div>
        </div>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script>
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

    //下拉
    function pullLoad() {}
    var pageNo1 = 1;
    var allHtml = getOrderList(1, 10);
    if (allHtml == "")$(".not-data").show();
    else $("#dataList").append(allHtml);
    /**
     * 上拉加载具体业务实现
     */
    function pullupRefresh() {
        var html = getOrderList(++pageNo1, 10);
        mui('#pullrefresh').pullRefresh().scrollToBottom();
        setTimeout(function() {
            if(html == "") {
                mui('#pullrefresh').pullRefresh().endPullupToRefresh((true)); //参数为true代表没有更多数据了。
                $(".mui-pull-caption-nomore").html("没有更多消息了.");
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

    //获取精品生活
    function getOrderList(pageNO, pageSize) {
        console.debug("传入的页码：" + pageNO);
        var parameter = {
            pageNO: pageNO,
            pageSize: pageSize
        }
        var html = null;
        CC.ajaxRequestData("post", false, "systemInfo/getSystemInfo", parameter, function (result) {
            html = bindData(result.data);
        });
        return html;
    }

    //拼装数据
    function bindData(jsonData) {
        var html = "";
        for(var i = 0; i < jsonData.length; i++) {
            var className = "";
            //if (jsonData[i].isChecked == 1) className = "isChecked";
            html += '<div class="news ' + className + '">' +
                    '<div class="news-bg" isLink=' + jsonData[i].isLink + ' linkUrl="' + jsonData[i].linkUrl + '">' +
                    '<div class="news-title">' + jsonData[i].title + '</div>' +
                    '<div class="news-time">' + CC.timeStampConversion(jsonData[i].createTime) + '</div>' +
                    '<div class="news-context">' + jsonData[i].digest + '</div>' +
                    '</div>' +
                    '</div>';
        }

        return html;
    }

    //消息外联跳转
    mui('#dataList').on('tap', '.news-bg', function() {
        var isLink = this.getAttribute("isLink"),
                linkUrl = this.getAttribute("linkUrl");
        if (isLink == 1) {
            location.href = linkUrl;
        }
    });
</script>

</body>
</html>
