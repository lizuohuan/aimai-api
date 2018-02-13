
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>搜索员工</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/studyCompany/searchUser.css">
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

<div class="header">
    <div class="search-div">
        <div class="mui-indexed-list-search mui-input-row mui-search">
            <input id="search" type="search" class="mui-input-clear mui-indexed-list-search-input" placeholder="手机号码或身份证">
        </div>
    </div>
    <div class="user-size">
        <span>添加好友</span>
    </div>
</div>

<!--下拉刷新容器-->
<div id="pullrefreshUser" class="mui-content mui-scroll-wrapper">
    <div class="mui-scroll">
        <div class="not-data">暂无员工</div>
        <div class="user-bar" id="dataList">

        </div>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script>

    CC.reload(); //刷新一下上一页传回来的东西
    mui('body').on('tap','a',function(){document.location.href=this.href;});
    //初始化上拉容器
    mui('#pullrefreshUser').pullRefresh({
        container: '#pullrefreshUser',
        down: {
            contentdown: "", //可选，在下拉可刷新状态时，下拉刷新控件上显示的标题内容
            contentover: "", //可选，在释放可刷新状态时，下拉刷新控件上显示的标题内容
            contentrefresh: "", //可选，正在刷新状态时，下拉刷新控件上显示的标题内容
            callback: function() {
                mui('#pullrefreshUser').pullRefresh().endPulldownToRefresh(); //refresh completed
            }
        },
        up: {
            callback: pullrefreshUser
        }
    });

    //给搜索框绑定改变事件
    $('#search').bind('input propertychange', function() {
        var allHtml = getDataList(1, 10, $("#search").val());
        if (allHtml == ""){ $("#dataList").html(""); $(".not-data").show();}
        else {$("#dataList").html(allHtml);$(".not-data").hide();}
    });

    var pageNo1 = 1;
    var allHtml = getDataList(1, 10, $("#search").val());
    if (allHtml == "") $(".not-data").show();
    else $("#dataList").html(allHtml);

    function pullrefreshUser() {
        var html = getDataList(++pageNo1, 10, $("#search").val());
        mui('#pullrefreshUser').pullRefresh().scrollToBottom();
        setTimeout(function() {
            if(html == "") {
                mui('#pullrefreshUser').pullRefresh().endPullupToRefresh((true)); //参数为true代表没有更多数据了。
                $(".mui-pull-caption-nomore").html("没有更多数据了.");
                pageNo1--;
            } else {
                mui('#pullrefreshUser').pullRefresh().endPullupToRefresh((false));
                $("#dataList").append(html);
            }
        }, 1500);
    }

    //获取数据
    function getDataList (pageNO, pageSize, searchParam) {
        var parameter = {
            pageNO: pageNO,
            pageSize: pageSize,
            searchParam : searchParam
        }
        var dataList = null;
        CC.ajaxRequestData("post", false, "user/queryUserNoCompany", parameter, function (result) {
            dataList = result.data;
        });

        var html = "";
        for (var i = 0; i < dataList.length; i++) {
            var obj = dataList[i];
            var style = obj.avatar == null ? CC.ip + "resources/img/my/11.png" : CC.ipImg + obj.avatar;
            html += '<div class="user-item" onclick="addUser(' + obj.id + ', 0, event)">' +
                    '   <a href="javascript: addUser(' + obj.id + ', 0)">' +
                    '       <i class="head" style="background: url(' + style + ') 100%;"></i>' +
                    '       <div class="name">' + obj.showName + '</div>' +
                    '       <div class="phone">' + obj.phone + '</div>' +
                    '   </a>' +
                    '   <a class="add-bar" href="javascript: addUser(' + obj.id + ', 1)">' +
                    '       <img src="' + CC.ip + 'resources/img/study/11.png">' +
                    '       <p>添加</p>' +
                    '   </a>' +
                    '</div>';
        }
        return html;
    }

    //添加
    function addUser (userId, type) {
        if (type == 0) {
            location.href = CC.ip + "page/studyCompany/userInfo?userId=" + userId;
        }
        else {
            location.href = CC.ip + "page/studyCompany/addUser?pageType=1&userId=" + userId;
        }
    }

</script>

</body>
</html>
