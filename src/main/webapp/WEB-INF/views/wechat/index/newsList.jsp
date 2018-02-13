
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>首页</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/index/newsList.css">
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

<div class="mui-content">
    <div id="pullrefreshInformation" class="mui-content mui-scroll-wrapper">
        <div class="mui-scroll">
            <ul class="mui-table-view mui-table-view-chevron" id="informationList">

            </ul>
        </div>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script>
    mui.init();
    // 监听tap事件，解决 a标签 不能跳转页面问题
    mui('body').on('tap','a',function(){document.location.href=this.href;});

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

    $("#informationList").html(getDataList(1, 10));

    var pageNo1 = 1;
    //资讯上拉
    function pullrefreshInformation() {
        var html = getDataList(++pageNo1, 10);
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
    function getDataList (pageNO, pageSize) {
        var parameter = {
            pageNO : pageNO,
            pageSize : pageSize
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
    });


</script>

</body>
</html>
