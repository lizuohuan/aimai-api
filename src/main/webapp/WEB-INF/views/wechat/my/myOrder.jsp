
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>我的订单</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/my/myOrder.css">
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
            全部订单
        </a>
        <a class="mui-control-item" href="#page2">
            待付款
        </a>
        <a class="mui-control-item" href="#page3">
            已完成
        </a>
    </div>
    <div id="sliderProgressBar" class="mui-slider-progress-bar mui-col-xs-4"></div>
    <div class="mui-slider-group" id="mui-slider-group">
        <!--全部订单-->
        <div id="page1" class="mui-slider-item mui-control-content mui-active">
            <div id="pullrefreshAll" class="mui-content mui-scroll-wrapper">
                <div class="mui-scroll">
                    <div class="mui-table-view mui-table-view-chevron" id="allList">
                        <div class="not-data">没有订单.</div>
                    </div>
                </div>
            </div>
        </div>

        <!--待付款-->
        <div id="page2" class="mui-slider-item mui-control-content">
            <div id="pullrefreshNonPayment" class="mui-content mui-scroll-wrapper">
                <div class="mui-scroll">
                    <div class="mui-table-view mui-table-view-chevron" id="nonPaymentList">
                        <div class="not-data">没有订单.</div>
                    </div>
                </div>
            </div>
        </div>

        <!--已完成-->
        <div id="page3" class="mui-slider-item mui-control-content">
            <div id="pullrefreshComplete" class="mui-content mui-scroll-wrapper">
                <div class="mui-scroll">
                    <div class="mui-table-view mui-table-view-chevron" id="completeList">
                        <div class="not-data">没有订单.</div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<!-- 支付弹窗 -->
<div id="paymentPicture" class="mui-popover mui-popover-action mui-popover-bottom">
    <ul class="mui-table-view">
        <li class="mui-table-view-cell">
            <div class="reg-way">
                <div>选择支付方式</div>
            </div>
            <div class="mui-row">
                <div class="mui-col-xs-12 mode_of_payment">
                    <a href="javascript: weChatPayment()">
                        <img src="<%=request.getContextPath()%>/resources/img/course/9.png">
                        <p>微信</p>
                    </a>
                </div>
            </div>
        </li>
    </ul>
</div>

<%@include file="../common/js.jsp" %>
<script>
    //初始化上拉容器
    mui('#pullrefreshAll').pullRefresh({
        container: '#pullrefreshAll',
        down: {
            contentdown: "", //可选，在下拉可刷新状态时，下拉刷新控件上显示的标题内容
            contentover: "", //可选，在释放可刷新状态时，下拉刷新控件上显示的标题内容
            contentrefresh: "", //可选，正在刷新状态时，下拉刷新控件上显示的标题内容
            callback: function() {
                mui('#pullrefreshAll').pullRefresh().endPulldownToRefresh(); //refresh completed
            }
        },
        up: {
            callback: pullrefreshAll
        }
    });
    mui('#pullrefreshNonPayment').pullRefresh({
        container: '#pullrefreshNonPayment',
        down: {
            contentdown: "", //可选，在下拉可刷新状态时，下拉刷新控件上显示的标题内容
            contentover: "", //可选，在释放可刷新状态时，下拉刷新控件上显示的标题内容
            contentrefresh: "", //可选，正在刷新状态时，下拉刷新控件上显示的标题内容
            callback: function() {
                mui('#pullrefreshNonPayment').pullRefresh().endPulldownToRefresh(); //refresh completed
            }
        },
        up: {
            callback: pullrefreshNonPayment
        }
    });
    mui('#pullrefreshComplete').pullRefresh({
        container: '#pullrefreshComplete',
        down: {
            contentdown: "", //可选，在下拉可刷新状态时，下拉刷新控件上显示的标题内容
            contentover: "", //可选，在释放可刷新状态时，下拉刷新控件上显示的标题内容
            contentrefresh: "", //可选，正在刷新状态时，下拉刷新控件上显示的标题内容
            callback: function() {
                mui('#pullrefreshComplete').pullRefresh().endPulldownToRefresh(); //refresh completed
            }
        },
        up: {
            callback: pullrefreshComplete
        }
    });

    var pageNo1 = 1;
    var pageNo2 = 1;
    var pageNo3 = 1;

    //默认加载一次
    var allHtml = getDataList(1, 10, null)
    if (allHtml == "") $("#allList .not-data").show();
    else $("#allList").html(allHtml);

    var isComeNo1 = 0;
    var isComeNo2 = 0; //判断是否换过
    var nonPaymentList = $("#nonPaymentList");
    var completeList = $("#completeList");
    //左右却换加载
    (function($) {
        document.getElementById('slider').addEventListener('slide', function(e) {
            if (e.detail.slideNumber == 0) {

            }
            else if (e.detail.slideNumber == 1 && isComeNo1 == 0) {
                var html = getDataList(1, 10, 0);
                if (html == "") nonPaymentList.find(".not-data").show();
                else nonPaymentList.html(html);
                isComeNo1 = 1;
            }
            else if (e.detail.slideNumber == 2 && isComeNo2 == 0) {
                var html = getDataList(1, 10, 1);
                if (html == "") completeList.find(".not-data").show();
                else completeList.html(html);
                isComeNo2 = 1;
            }
        });
    })(mui);

    //全部上拉
    function pullrefreshAll() {
        var html = getDataList(++pageNo1, 10, null);
        mui('#pullrefreshAll').pullRefresh().scrollToBottom();
        setTimeout(function() {
            if(html == "") {
                mui('#pullrefreshAll').pullRefresh().endPullupToRefresh((true)); //参数为true代表没有更多数据了。
                $(".mui-pull-caption-nomore").html("没有更多订单了.");
                pageNo1--;
            } else {
                mui('#pullrefreshAll').pullRefresh().endPullupToRefresh((false));
                $("#allList").append(html);
            }
        }, 1500);
    }

    //待付款上拉
    function pullrefreshNonPayment() {
        var html = getDataList(++pageNo2, 10, 0);
        mui('#pullrefreshNonPayment').pullRefresh().scrollToBottom();
        setTimeout(function() {
            if(html == "") {
                mui('#pullrefreshNonPayment').pullRefresh().endPullupToRefresh((true)); //参数为true代表没有更多数据了。
                $(".mui-pull-caption-nomore").html("没有更多订单了.");
                pageNo2--;
            } else {
                mui('#pullrefreshNonPayment').pullRefresh().endPullupToRefresh((false));
                $("#nonPaymentList").append(html);
            }
        }, 1500);
    }

    //已完成上拉
    function pullrefreshComplete() {
        var html = getDataList(++pageNo3, 10, 1);
        mui('#pullrefreshComplete').pullRefresh().scrollToBottom();
        setTimeout(function() {
            if(html == "") {
                mui('#pullrefreshComplete').pullRefresh().endPullupToRefresh((true)); //参数为true代表没有更多数据了。
                $(".mui-pull-caption-nomore").html("没有更多订单了.");
                pageNo3--;
            } else {
                mui('#pullrefreshComplete').pullRefresh().endPullupToRefresh((false));
                $("#completeList").append(html);
            }
        }, 1500);
    }

    //获取数据
    function getDataList (pageNO, pageSize, payStatus) {
        CC.print("传入的页码：" + pageNO);
        var parameter = {
            pageNO: pageNO,
            pageSize: pageSize,
            payStatus : payStatus
        }
        var dataList = null;
        CC.ajaxRequestData("post", false, "order/queryOrder", parameter, function (result) {
            dataList = result.data;
        });

        //全部订单
        var html = "";
        for (var i = 0; i < dataList.length; i++) {
            var msg = "";
            var btns = "";
            var url = "";
            if (dataList[i].payStatus == 0) {
                msg = "<span class=\"list-title-stay\">待付款</span>";
                btns = '<button class="mui-btn payment-btn" onclick="purchase(' + dataList[i].id + ')">去付款</button>' +
                        '<button onclick="deleteOrder(' + dataList[i].id + ', this, event)" class="mui-btn delete-btn">删除订单</button>';
                //url = CC.ip + "page/courseInfo?&curriculumId=" + dataList[i].curriculumId;
                url = "javascript:void(0)";
            }
            else{
                msg = "<span class=\"list-title-ok\">已完成</span>";
                url = CC.ip + "page/courseVideo?orderId=" + dataList[i].id + "&isAudition=0&curriculumId=" + dataList[i].curriculumId;
            }
            html += '<div class="mui-table-view" style="margin-top: 10px">' +
                    '   <div class="mui-table-view-cell mui-media">' + msg + '</div>' +
                    '   <div class="mui-table-view-cell mui-media">' +
                    '       <div class="courseUrl">' +
                    '           <a href="' + url + '"><i class="mui-media-object mui-pull-left" style="background: url(' + CC.ipImg + dataList[i].cover + ')"></i></a>' +
                    '           <div class="mui-media-body">' +
                    '               <p class="list-title mui-ellipsis">' + dataList[i].curriculumName + '</p>' +
                    '               <p class="list-price">' +
                    '                   <span>￥' + Number(dataList[i].price * dataList[i].number).toFixed(2) + '</span>' +
                    '                   <span class="list-num">x' + dataList[i].number + '</span>' +
                    '               </p>' +
                    '               <div class="">' + btns + '</div>' +
                    '           </div>' +
                    '       </div>' +
                    '   </div>'+
                    '</div>';
        }
        return html;
    }
    //消息外联跳转
    mui('.completeList').on('tap', function() {
        var href = this.getAttribute("href");
        location.href = href;
    });

    //删除订单
    function deleteOrder (id, obj, event) {
        event.stopPropagation();
        mui.confirm('是否确认删除订单？', '', ["确认","取消"], function(e) {
            if (e.index == 0) {
                CC.ajaxRequestData("post", false, "order/delOrder", {orderId : id}, function () {
                    $(obj).parent().parent().parent().parent().parent().fadeOut();
                });
            } else {
            }
        });
    }

    var payOrderId = 0;
    function purchase (orderId) {
        payOrderId = orderId;
        mui('#paymentPicture').popover('toggle');
    }
    //微信支付
    function weChatPayment() {
        CC.ajaxRequestData("post", false, "jsPay/sign", {orderId : payOrderId}, function (result) {
            CC.wechatPay(result.data.appId, result.data.timeStamp, result.data.nonceStr, result.data.package, result.data.signType, result.data.sign, function (json) {
                if(json.err_msg == "get_brand_wcpay_request:ok" ) {
                    mui.alert("支付成功.", "支付结果", function () {
                        location.reload();
                    });
                }
                else {
                    mui.alert("支付失败.");
                }
                mui('#paymentPicture').popover('toggle');
            });
        });
    }

    mui("#mui-slider-group").on('tap','a',function(){document.location.href=this.href;});

    $(function() {
        var height = document.body.clientHeight;
        $(".mui-slider-item").css("minHeight", (height - 50) + "px");
    });
</script>

</body>
</html>
