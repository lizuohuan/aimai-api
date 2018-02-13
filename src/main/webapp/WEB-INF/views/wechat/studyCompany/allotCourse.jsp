
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>课程分配</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/studyCompany/allotCourse.css">
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

<div id="pullrefreshCouse" class="mui-content mui-scroll-wrapper">
    <div class="mui-scroll">
        <div class="not-data">暂无课程</div>
        <ul class="mui-table-view mui-table-view-chevron" id="dataList">

        </ul>
    </div>
</div>

<div style="height: 70px;"></div>

<div class="fix-div">
    <a class="mui-btn mui-btn-block fix-btn" onclick="allotCourse()">确定</a>
</div>


<%@include file="../common/js.jsp" %>

<script>
    mui.init({
        pullRefresh: {
            container: '#pullrefreshCouse',
            down: {
                contentdown: "", //可选，在下拉可刷新状态时，下拉刷新控件上显示的标题内容
                contentover: "", //可选，在释放可刷新状态时，下拉刷新控件上显示的标题内容
                contentrefresh: "", //可选，正在刷新状态时，下拉刷新控件上显示的标题内容
                callback: function() {
                    mui('#pullrefreshCouse').pullRefresh().endPulldownToRefresh(); //refresh completed
                }
            },
            up: {
                contentrefresh: '正在使劲加载...',
                callback: pullrefreshCouse,
                auto: false, //默认加载
            }
        }
    });

    var pageNo1 = 1;
    var allHtml = getOrderList(1, 10);
    if (allHtml == "")$(".not-data").show();
    else $("#dataList").append(allHtml);
    /**
     * 上拉加载具体业务实现
     */
    function pullrefreshCouse() {
        var html = getOrderList(++pageNo1, 10);
        mui('#pullrefreshCouse').pullRefresh().scrollToBottom();
        setTimeout(function() {
            if(html == "") {
                mui('#pullrefreshCouse').pullRefresh().endPullupToRefresh((true)); //参数为true代表没有更多数据了。
                $(".mui-pull-caption-nomore").html("没有更多课程了.");
                pageNo1--;
            } else {
                mui('#pullrefreshCouse').pullRefresh().endPullupToRefresh((false));
                $("#dataList").append(html);
            }
        }, 1500);
    }
    if(mui.os.plus) {
        mui.plusReady(function() {
            setTimeout(function() {
                mui('#pullrefreshCouse').pullRefresh().pulldownLoading();
            }, 1000);

        });
    } else {
        mui.ready(function() {
            mui('#pullrefreshCouse').pullRefresh().pulldownLoading();
        });
    }

    //获取精品生活
    function getOrderList(pageNO, pageSize) {
        console.debug("传入的页码：" + pageNO);
        var parameter = {
            pageNO: pageNO,
            pageSize: pageSize,
            userId : CC.getUrlParam("userId")
        }
        var dataList = null;
        CC.ajaxRequestData("post", false, "curriculum/queryWaitAllocationCurriculum", parameter, function (result) {
            dataList = result.data;
        });
        var html = "";
        for (var i = 0; i < dataList.length; i++) {
            var obj = dataList[i];
            var style = "background: url('" + CC.ip + obj.cover + "')";
            html += '<li class="mui-table-view-cell mui-media">' +
                    '   <div class="mui-checkbox mui-left">' +
                    '       <label>' +
                    '           <div class="mui-media-object mui-pull-left" style="' + style + '"></div>' +
                    '           <div class="mui-media-body">' +
                    '               <div class="list-title">' +
                    '                   <p>' + obj.curriculumName + '</p>' +
                    '               </div>' +
                    '               <p class="list-num">' +
                    '                   <img src="' + CC.ip + 'resources/img/my/3.png">' +
                    '                   <span class="num-title"><span class="num"> ' + obj.videoNum + '</span> 个视频课</span>' +
                    '               </p>' +
                    '               <span class="collect-num"><span>' + obj.number + '</span>份</span>' +
                    '           </div>' +
                    '       </label>' +
                    '       <input name="checkbox" value="' + obj.orderId + '" type="checkbox" >' +
                    '   </div>' +
                    '</li>';
        }

        return html;
    }

    //确定分配
    function allotCourse () {
        var orderIds = [];
        $("#dataList").find("input[type='checkbox']").each(function () {
            if ($(this).is(":checked")) {
                orderIds.push($(this).val());
            }
        });
        if (orderIds.length == 0) {
            mui.toast("请选择课程.");
            return false;
        }
        var parameter = {
            orderIds: orderIds.toString(),
            userId : CC.getUrlParam("userId"),
            number : 1
        }
        CC.print(parameter);
        CC.ajaxRequestData("post", false, "allocation/batchAddAllocation", parameter, function (result) {
            history.back();
        });
    }

    $(function (){
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
