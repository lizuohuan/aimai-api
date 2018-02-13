
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>查看学习列表</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/studyCompany/studyUserList.css">
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
<div class="top-bar">
    <a href="javascript:history.back()"><img src="<%=request.getContextPath()%>/resources/img/study/14.png"></a>
    <div class="title">查看学习列表</div>
    <div class="hint">共<span id="userNumber">0</span>位同事<span id="userType">学习</span></div>
</div>
<div id="pullrefreshPerson" class="mui-content">
    <div class="mui-scroll">
        <div class="not-data">暂无同事</div>
        <ul class="mui-table-view mui-table-view-chevron" id="dataList">
            <%--<li class="mui-table-view-cell mui-media">
                <a href="javascript:;">
                    <img class="mui-media-object mui-pull-left" src="<%=request.getContextPath()%>/resources/img/test5.jpeg">
                    <div class="mui-media-body">
                        <div class="mui-row">
                            <div class="mui-col-xs-8">
                                <div class="name">周星驰</div>
                                <div class="course-name mui-ellipsis">
                                    152000000001
                                </div>
                            </div>
                            <div class="mui-col-xs-4">
                                <span class="pass-Exam">考试通过</span>
                            </div>
                        </div>
                    </div>
                </a>
            </li>
            <li class="mui-table-view-cell mui-media">
                <a href="javascript:;">
                    <img class="mui-media-object mui-pull-left" src="<%=request.getContextPath()%>/resources/img/test5.jpeg">
                    <div class="mui-media-body">
                        <div class="mui-row">
                            <div class="mui-col-xs-8">
                                <div class="name">周星驰</div>
                                <div class="course-name mui-ellipsis">
                                    152000000001
                                </div>
                            </div>
                            <div class="mui-col-xs-4">
                                <span class="pass-not-Exam">考试未通过</span>
                            </div>
                        </div>
                    </div>
                </a>
            </li>
            <li class="mui-table-view-cell mui-media">
                <a href="javascript:;">
                    <img class="mui-media-object mui-pull-left" src="<%=request.getContextPath()%>/resources/img/test5.jpeg">
                    <div class="mui-media-body">
                        <div class="mui-row">
                            <div class="mui-col-xs-8">
                                <div class="name">周星驰</div>
                                <div class="course-name mui-ellipsis">
                                    152000000001
                                </div>
                            </div>
                            <div class="mui-col-xs-4">
                                <span class="hasBeenLearning">已学习<span>16</span>课时</span>
                            </div>
                        </div>
                    </div>
                </a>
            </li>--%>
        </ul>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script>
    mui.init();
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

    var allHtml = getDataList(1, 10)
    if (allHtml == "") $(".not-data").show();
    else $("#dataList").html(allHtml);

    var pageNo1 = 1;
    //课程上拉
    function pullrefreshPerson() {
        var html = getDataList(++pageNo1, 10);
        setTimeout(function() {
            if(html == "") {
                mui('#pullrefreshPerson').pullRefresh().endPullupToRefresh((true)); //参数为true代表没有更多数据了。
                $(".mui-pull-caption-nomore").html("没有更多数据了.");
                pageNo1--;
            } else {
                mui('#pullrefreshPerson').pullRefresh().endPullupToRefresh((false));
                $("#dataList").append(html);
            }
        }, 1500);
    }

    $("#userType").html(CC.getUrlParam("flag") == 0 ? "学习" : "考核");

    //获取数据
    function getDataList (pageNO, pageSize) {

        var dataList = null;
        var parameter = {
            pageNO : pageNO,
            pageSize : pageSize,
            orderId : CC.getUrlParam("orderId"),
            flag : CC.getUrlParam("flag"),
        }
        CC.ajaxRequestData("post", false, "user/queryUserStudyStatus", parameter, function (result) {
            dataList = result.data;
        });
        var html = "";
        for (var i = 0; i < dataList.length; i++) {
            var obj = dataList[i];
            $("#userNumber").html(obj.peopleNum);
            var typeHtml = '<span class="hasBeenLearning">已学习<span>' + obj.finishCourseWareNum + '</span>课时</span>';
            if (CC.getUrlParam("flag") == 1) {
                if (obj.isPass > 0) {
                    typeHtml = '<span class="pass-Exam">考试通过</span>';
                }
                else {
                    typeHtml = '<span class="pass-not-Exam">考试未通过</span>';
                }
            }
            obj.avatar = obj.avatar == null ? CC.ip + "resources/img/my/11.png" : CC.ipImg + obj.avatar;
            html += '<li class="mui-table-view-cell mui-media">' +
                    '   <a href="javascript:;">' +
                    '   <i class="mui-media-object mui-pull-left head" style="background: url(' + obj.avatar + ');"></i>' +
                    '       <div class="mui-media-body">' +
                    '           <div class="mui-row">' +
                    '               <div class="mui-col-xs-8">' +
                    '                   <div class="name">' + obj.showName + '</div>' +
                    '                       <div class="course-name mui-ellipsis">' + obj.phone + '</div>' +
                    '                   </div>' +
                    '               <div class="mui-col-xs-4">' +
                    typeHtml +
                    '               </div>' +
                    '           </div>' +
                    '       </div>' +
                    '   </a>' +
                    '</li>';
        }
        return html;
    }

</script>

</body>
</html>
