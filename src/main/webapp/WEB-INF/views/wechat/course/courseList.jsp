
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title id="title">课程列表</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/course/courseList.css">
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
        <div class="mui-row" id="dataList">
            <div class="not-data">暂无课程.</div>
        </div>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script>

    var curriculumTypeId = CC.getUrlParam("curriculumTypeId"); //课程类型ID
    var isRecommend = CC.getUrlParam("isRecommend"); //是否推荐

    //默认调用一次
    if (getDataList(1, 10) == "") $(".not-data").show();
    else $("#dataList").html(getDataList(1, 10));

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
        CC.print("传入的页码：" + pageNO);
        var parameter = {
            pageNO: pageNO,
            pageSize: pageSize,
            curriculumTypeId : curriculumTypeId,
            isRecommend : isRecommend

        }
        CC.print(parameter);
        var html = "";
        CC.ajaxRequestData("post", false, "curriculum/queryCurriculumByType", parameter, function (result) {
            html = bindData(result.data);
        });
        return html;
    }

    //拼装数据
    function bindData(jsonData) {
        var html = "";
        for(var i = 0; i < jsonData.length; i++) {
            html += '<div class="mui-col-xs-6">' +
                    '   <div class="course-list">' +
                    '       <a href="javascript: isBuy(' + jsonData[i].id + ')">' + //'+ CC.ip +'page/courseInfo?curriculumId=' + jsonData[i].id + '
                    '           <div class="course-cover" style="background: url(' + CC.ipImg + jsonData[i].cover +  ')"></div>' +
                    '       </a>' +
                    '       <div class="course-info">' +
                    '           <div class="video-title">' + jsonData[i].curriculumName + '</div>' +
                    '           <div class="list-num">' +
                    '               <span class="num-title">' +
                    '                   <img src="' + CC.ip + 'resources/img/my/3.png" />' +
                    '                   <span class="num">' + jsonData[i].videoNum + '</span> 个视频课' +
                    '               </span>' +
                    '           </div>' +
                    '           <div class="money">￥' + jsonData[i].price + '</div>' +
                    '       </div>' +
                    '   </div>' +
                    '</div>';
        }
        return html;
    }

    /**判断是否已经购买过了**/
    function isBuy (id) {
        CC.ajaxRequestData("post", false, "curriculum/isBuy", {curriculumId : id}, function (result) {
            if (result.data == 0) {
                location.href = CC.ip + "page/courseInfo?curriculumId=" + id;
            }
            else if (result.data == -1) {
                if (CC.getUserInfo().roleId == 4) {
                    mui.alert('您已经购买过该课程，可以直接观看', '温馨提示', function() {
                        location.href = CC.ip + "page/study";
                    });
                }
                else {
                    location.href = CC.ip + "page/courseInfo?curriculumId=" + id;
                }
            }
            else if (result.data == -2) {
                mui.alert('该课程订单已存在，请直接付款', '温馨提示', function() {
                    location.href = CC.ip + "page/myOrder";
                });
            }
        });
    }

</script>

</body>
</html>
