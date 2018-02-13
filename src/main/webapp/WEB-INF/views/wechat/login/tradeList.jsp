
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>行业列表</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/login/tradeList.css">
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
        <div class="mui-input-group mui-table-view" id="dataList">

        </div>
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
                //callback: pullupRefresh,
                auto: false, //默认加载
            }
        }
    });

    //下拉
    function pullLoad() {}
    var pageNo1 = 0;
    /**
     * 上拉加载具体业务实现
     */
    function pullupRefresh() {
        var html = getOrderList(++pageNo1, 10);
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

    $("#dataList").append(getOrderList(1, 10));

    //获取行业
    function getOrderList(pageNO, pageSize) {
        CC.print("传入的页码：" + pageNO);
        var arr = {
            pageNO: pageNO,
            pageSize: pageSize
        }
        var html = "";
        CC.ajaxRequestData("get", false, 'trade/queryTrade', arr, function(result) {
            html = bindData(result.data);
        });
        return html;
    }

    //拼装数据
    function bindData(jsonData) {
        var html = "";
        for(var i = 0; i < jsonData.length; i++) {
            var checked = "";
            if (CC.getUrlParam("tradeId") == jsonData[i].id) {
                checked = "checked";
            }
            html += '<div class="mui-input-row mui-radio mui-left" onclick="setTrade(this)">' +
                        '<label>' + jsonData[i].tradeName + '</label>' +
                        '<input ' + checked + ' name="radio1" type="radio" value="' + jsonData[i].id + '">' +
                    '</div>';
        }
        return html;
    }

    function setTrade (obj) {
        var json = {
            tradeName : $(obj).find("label").text(),
            tradeId : $(obj).find("input").val(),
        }
        sessionStorage.setItem("tradeInfo", JSON.stringify(json));
        window.history.back();
    }
</script>

</body>
</html>
