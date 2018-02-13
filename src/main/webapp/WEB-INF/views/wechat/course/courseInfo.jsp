
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>课程详情</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/course/courseInfo.css">
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
<body ng-app="webApp" ng-controller="courseInfoController">

<div class="mui-content" style="display: block;">

    <div class="course-cover" style="background: url('{{imgUrl}}{{curriculum.cover}}')"></div>

    <div class="collect-icon">
        <img ng-click="collect()" src="<%=request.getContextPath()%>/resources/img/course/1.png" />
    </div>

    <div class="collect-info" ng-cloak>
        <div class="mui-row title-bar">
            <div class="row-left">
                <div class="course-title">{{curriculum.curriculumName}}</div>
                <span class="course-badge">{{curriculum.stageName}}</span>
                <span class="course-badge">{{curriculum.year | date:'yyyy'}}年</span>
                <div class="list-num">
                    <div class="mui-row">
                        <div class="mui-col-xs-6">
                            <img src="<%=request.getContextPath()%>/resources/img/course/2.png" />
                            {{curriculum.videoNum}}个视频课
                        </div>
                        <div class="mui-col-xs-6">
                            <img src="<%=request.getContextPath()%>/resources/img/course/3.png" />
                            {{curriculum.hdSeconds}}
                        </div>
                    </div>
                </div>
            </div>
            <div class="row-left">
                ￥{{curriculum.price}}
            </div>
        </div>
    </div>

    <div class="course-info">
        <div id="slider" class="mui-slider">
            <div id="sliderSegmentedControl" class="mui-slider-indicator mui-segmented-control mui-segmented-control-inverted">
                <a class="mui-control-item mui-active" href="#page1">
                    <img id="introduceImg" src="<%=request.getContextPath()%>/resources/img/course/4-4.png">
                    <span>介绍</span>
                </a>
                <a class="mui-control-item" href="#page2">
                    <img id="catalogueImg" src="<%=request.getContextPath()%>/resources/img/course/5.png">
                    <span>目录</span>
                </a>
                <a class="mui-control-item" href="#page3">
                    <img id="commentImg" src="<%=request.getContextPath()%>/resources/img/course/6.png">
                    <span>评论</span>
                </a>
            </div>
            <div id="sliderProgressBar" class="mui-slider-progress-bar mui-col-xs-4"></div>
            <div class="mui-slider-group" id="mui-slider-group">
                <!--介绍-->
                <div id="page1" class="mui-slider-item mui-control-content mui-active">
                    <div id="introduce" class="mui-content mui-scroll-wrapper">
                        <div class="mui-scroll">
                            <div class="introduce-title">
                                <span class="perch"></span>
                                <span class="title">课程介绍</span>
                                <div class="introduce-context" ng-bind-html="curriculum.curriculumDescribe | trustHtml"></div>
                            </div>
                            <div class="introduce-title">
                                <span class="perch"></span>
                                <span class="title">讲师名称</span>
                                <div class="introduce-context" ng-bind-html="curriculum.teacherName | trustHtml"></div>
                            </div>
                            <div class="introduce-title">
                                <span class="perch"></span>
                                <span class="title">讲师介绍</span>
                                <div class="introduce-context" ng-bind-html="curriculum.teacherIntroduce | trustHtml"></div>
                            </div>
                            <div class="introduce-title">
                                <span class="perch"></span>
                                <span class="title">适用人群</span>
                                <div class="introduce-context" ng-bind-html="curriculum.applyPerson | trustHtml"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!--目录-->
                <div id="page2" class="mui-slider-item mui-control-content">
                    <div id="pullrefreshCatalogue" class="mui-content mui-scroll-wrapper">
                        <div class="mui-scroll">
                            <div class="not-data" style="display: block;" ng-show="curriculum.courseWares.length == 0">暂无目录.</div>
                            <ul class="mui-table-view mui-table-view-chevron" id="catalogueList">
                                <li ng-repeat="course in curriculum.courseWares">
                                    <div class="mui-ellipsis catalogue" ng-repeat="video in course.videos">
                                        {{course.courseWareName}}：{{video.name}}
                                        <span class="catalogue-time">{{video.lowDefinitionSeconds}}</span>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!--评论-->
                <div id="page3" class="mui-slider-item mui-control-content">
                    <div id="pullrefreshComment" class="mui-content mui-scroll-wrapper">
                        <div class="mui-scroll">
                            <ul class="mui-table-view mui-table-view-chevron" id="commentList">
                                <div class="not-data">暂无评论.</div>
                            </ul>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <div class="fix-div" ng-show="userInfo == null || userInfo.roleId == 3 || userInfo.roleId == 4 || userInfo.roleId == 5">
        <div class="purchase-btn">
            <a class="mui-btn mui-btn-block fix-btn" ng-if="curriculum.price <= 0" ng-click="purchase()">免费购买</a>
            <a class="mui-btn mui-btn-block fix-btn" ng-if="curriculum.price > 0" ng-click="purchase()">立即购买</a>
        </div>
    </div>

</div>

<!-- 弹窗 -->
<div id="picture" class="mui-popover mui-popover-action mui-popover-bottom">
    <ul class="mui-table-view">
        <li class="mui-table-view-cell">
            <div class="reg-way">
                <div>购买数量</div>
            </div>
            <div class="mui-row">
                <div class="mui-col-xs-12" style="padding-top: 15px">
                    <input class="number-btn" type="image" src="<%=request.getContextPath()%>/resources/img/course/7.png" ng-click="minusNum()">
                    <input type="number" ng-model="number" placeholder="请输入您需要购买的数量" class="number">
                    <input class="number-btn" type="image" src="<%=request.getContextPath()%>/resources/img/course/8.png" ng-click="plusNum()">
                </div>
            </div>
            <div class="mui-row">
                <div class="mui-col-xs-12">
                    <div class="mui-content-padded">
                        <a class="mui-btn mui-btn-block" ng-click="submitNumber()">确定</a>
                    </div>
                </div>
            </div>
        </li>
    </ul>
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
                    <a ng-click="weChatPayment()">
                        <img src="<%=request.getContextPath()%>/resources/img/course/9.png">
                        <p>微信</p>
                    </a>
                </div>
                <%--<div class="mui-col-xs-6 mode_of_payment">
                    <a href="<%=request.getContextPath()%>/page/paymentResult">
                        <img src="<%=request.getContextPath()%>/resources/img/course/10.png">
                        <p>支付宝</p>
                    </a>
                </div>--%>
            </div>
        </li>
    </ul>
</div>

<%@include file="../common/js.jsp" %>
<script>
    CC.reload(); //刷新一下上一页传回来的东西
    var curriculumId = CC.getUrlParam("curriculumId");

    var webApp = angular.module('webApp', []);
    webApp.controller('courseInfoController', function($scope, $http, $timeout) {
        $scope.userInfo = CC.getUserInfo(); //登录人信息
        $scope.imgUrl = CC.ipImg; //图片IP
        $scope.curriculum = null; //课程对象
        $scope.orderId = 0; // 存放订单ID
        CC.ajaxRequestData("post", false, "curriculum/queryCurriculumById", {curriculumId : curriculumId}, function (result) {
            $scope.curriculum = result.data;
            $scope.curriculum.hdSeconds = CC.getFormat($scope.curriculum.hdSeconds);
            for (var i = 0; i < $scope.curriculum.courseWares.length; i++) {
                var courseWares = $scope.curriculum.courseWares[i];
                for (var j = 0; j < courseWares.videos.length; j++) {
                    var video = courseWares.videos[j];
                    video.highDefinitionSeconds = CC.getFormatTime(video.highDefinitionSeconds);
                    video.lowDefinitionSeconds = CC.getFormatTime(video.lowDefinitionSeconds);
                }
            }
        });

        //购买
        $scope.purchase = function () {
            if ($scope.userInfo == null) {
                mui.confirm('登录已失效，是否登录？', '', ["确认","取消"], function(e) {
                    if (e.index == 0) {
                        location.href = CC.ip + "page/login";
                        sessionStorage.setItem("url", window.location.href);
                    } else {

                    }
                });
                return false;
            }

            CC.ajaxRequestData("post", false, "curriculum/isBuy", {curriculumId : curriculumId}, function (result) {
                if (result.data == 0) {
                    if (CC.getUserInfo().roleId == 3 || CC.getUserInfo().roleId == 5) {
                        mui('#picture').popover('toggle');
                    }
                    else {
                        //创建订单
                        var parameter = {
                            curriculumId : curriculumId,
                            number : 1
                        }
                        if ($scope.orderId == 0) {
                            CC.ajaxRequestData("post", false, "order/addOrder", parameter, function (result) {
                                $scope.orderId = result.data;
                                if ($scope.curriculum.price <= 0) {
                                    if (CC.getUserInfo().roleId == 4) {
                                        location.href = CC.ip + "page/study";
                                    }
                                    else {
                                        location.href = CC.ip + "page/studyCompany/study";
                                    }
                                }
                                else {
                                    mui('#paymentPicture').popover('toggle');
                                }
                            });
                        }
                        else {
                            if ($scope.curriculum.price > 0) {
                                mui('#paymentPicture').popover('toggle');
                            }
                        }
                    }
                }
                else if (result.data == -1) {
                    if (CC.getUserInfo().roleId == 4) {
                        mui.alert('您已经购买过该课程，可以直接观看', '温馨提示', function() {
                            location.href = CC.ip + "page/study";
                        });
                    }
                    else {
                        mui('#picture').popover('toggle');
                    }
                }
                else if (result.data == -2) {
                    mui.alert('该课程订单已存在，请直接付款', '温馨提示', function() {
                        location.href = CC.ip + "page/myOrder";
                    });
                }
            });
        }

        $scope.number = 0;
        //减
        $scope.minusNum = function () {
            if ($scope.number <= 0) {
                $scope.number = 0;
            }
            else {
                $scope.number = $scope.number - 1;
            }
        }

        //加
        $scope.plusNum = function () {
            $scope.number = $scope.number + 1;
        }

        //收藏
        $scope.collect = function () {
            var parameter = {
                type : 1,
                targetId : curriculumId
            }
            CC.ajaxRequestData("post", false, "collect/addCollect", parameter, function (result) {
                mui.alert("收藏成功.");
            });
        }

        //提交数量
        $scope.submitNumber = function () {
            if ($scope.number == 0) {
                mui.alert("请输入购买数量.");
                return false;
            }

            //创建订单
            var parameter = {
                curriculumId : curriculumId,
                number : $scope.number
            }
            if ($scope.orderId == 0) {
                CC.ajaxRequestData("post", false, "order/addOrder", parameter, function (result) {
                    $scope.orderId = result.data;
                    if ($scope.curriculum.price <= 0) {
                        if (CC.getUserInfo().roleId == 4) {
                            location.href = CC.ip + "page/study";
                        }
                        else {
                            location.href = CC.ip + "page/studyCompany/study";
                        }
                    }
                    else {
                        mui('#paymentPicture').popover('toggle');
                    }
                });
            }
        }

        //支付
        $scope.weChatPayment = function () {
            CC.ajaxRequestData("post", false, "jsPay/sign", {orderId : $scope.orderId}, function (result) {
                CC.wechatPay(result.data.appId, result.data.timeStamp, result.data.nonceStr, result.data.package, result.data.signType, result.data.sign, function (json) {
                    if(json.err_msg == "get_brand_wcpay_request:ok" ) {
                        mui.alert("支付成功.");
                        location.href = CC.ip + "page/paymentResult?isSucceed=1&orderId=" + $scope.orderId;
                    }
                    else {
                        mui.alert("支付失败.");
                        location.href = CC.ip + "page/paymentResult?isSucceed=0&orderId=" + $scope.orderId;
                    }
                });
            });
        }
    });
    //富文本过滤器
    webApp.filter('trustHtml', ['$sce',function($sce) {
        return function(val) {
            return $sce.trustAsHtml(val);
        };
    }]);

    var $introduceImg = $("#introduceImg");
    var $catalogueImg = $("#catalogueImg");
    var $commentImg = $("#commentImg");
    (function($) {
        //左右却换加载
        document.getElementById('slider').addEventListener('slide', function(e) {
            console.log(e.detail.slideNumber);
            if (e.detail.slideNumber == 0) {
                $introduceImg.attr("src", CC.ip + "resources/img/course/4-4.png");
                $catalogueImg.attr("src", CC.ip + "resources/img/course/5.png");
                $commentImg.attr("src", CC.ip + "resources/img/course/6.png");
            }
            else if (e.detail.slideNumber == 1) {
                $introduceImg.attr("src", CC.ip + "resources/img/course/4.png");
                $catalogueImg.attr("src", CC.ip + "resources/img/course/5-5.png");
                $commentImg.attr("src", CC.ip + "resources/img/course/6.png");
            }
            else if (e.detail.slideNumber == 2) {
                $introduceImg.attr("src", CC.ip + "resources/img/course/4.png");
                $catalogueImg.attr("src", CC.ip + "resources/img/course/5.png");
                $commentImg.attr("src", CC.ip + "resources/img/course/6-6.png");
            }
        });
    })(mui);

    //初始化上拉容器
    mui('#introduce').pullRefresh({
        container: '#introduce',
    });
    mui('#pullrefreshCatalogue').pullRefresh({
        container: '#pullrefreshCatalogue',
    });
    mui('#pullrefreshComment').pullRefresh({
        container: '#pullrefreshComment',
        down: {
            contentdown: "", //可选，在下拉可刷新状态时，下拉刷新控件上显示的标题内容
            contentover: "", //可选，在释放可刷新状态时，下拉刷新控件上显示的标题内容
            contentrefresh: "", //可选，正在刷新状态时，下拉刷新控件上显示的标题内容
            callback: function() {
                mui('#pullrefreshComment').pullRefresh().endPulldownToRefresh(); //refresh completed
            }
        },
        up: {
            callback: pullrefreshComment
        }
    });

    var pageNo1 = 1; // 评论分页页码

    //评论上拉
    function pullrefreshComment() {
        var html = getDataList(++pageNo1, 10, 1);
        mui('#pullrefreshComment').pullRefresh().scrollToBottom();
        setTimeout(function() {
            if(html == "") {
                mui('#pullrefreshComment').pullRefresh().endPullupToRefresh((true)); //参数为true代表没有更多数据了。
                $(".mui-pull-caption-nomore").html("没有更多数据了.");
                pageNo1--;
            } else {
                mui('#pullrefreshComment').pullRefresh().endPullupToRefresh((false));
                $("#commentList").append(html);
            }
        }, 1500);
    }

    var allHtml = getDataList(1, 10, 1);
    if (allHtml == "") $(".not-data").show();
    else $("#commentList").html(allHtml);

    //获取数据
    function getDataList (pageNO, pageSize) {
        CC.print("传入的页码：" + pageNO);
        var parameter = {
            pageNO: pageNO,
            pageSize: pageSize,
            curriculumId : curriculumId
        }

        var html = "";
        var dataList = null;
        CC.ajaxRequestData("post", false, "evaluate/queryEvaluate", parameter, function (result) {
            dataList = result.data;
        });
        for (var i = 0; i < dataList.length; i++) {
            var avatar = dataList[i].avatar == null ? CC.ip + "resources/img/my/11.png" : CC.ipImg + dataList[i].avatar;
            var dateTime = CC.getCountTime(dataList[i].createTime, dataList[i].timeStamp);
            var userName = dataList[i].userName;
            var startName = "";
            var endName = "";
            if (userName.length > 2) {
                startName = userName.substring(0, 1);
                endName = userName.substring(userName.length - 1, userName.length);
            }
            else {
                startName = userName.substring(0, 1);
            }
            userName = startName + "*" + endName;
            html += '<li class="mui-table-view-cell mui-media">' +
                    '<i class="mui-media-object mui-pull-left head" style="background: url(' + avatar + ');"></i>' +
                    '<div class="mui-media-body">' +
                    '<p class="mui-ellipsis">' + userName + '</p>' +
                    '<p class="mui-ellipsis comment-time">' + dateTime + '</p>' +
                    '<div class="comment-context">' + dataList[i].content + '</div>' +
                    '</div>' +
                    '</li>';
        }
        return html;

    }
</script>

</body>
</html>
