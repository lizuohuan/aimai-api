<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>考试题</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/swiper.min.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/study/examList.css">
</head>
<body ng-app="webApp" ng-controller="controller">

<div class="mui-content">
    <div class="title-bar">
        <div class="mui-row">
            <div class="mui-col-xs-4">
                <div ng-show="type != 0">
                    <img ng-show="isPause && type == 1" class="exam-icon-start" ng-click="startTime()" src="<%=request.getContextPath()%>/resources/img/study/10-1.png">
                    <img ng-show="!isPause && type == 1" class="exam-icon-start exam-icon-end" ng-click="endTime()" src="<%=request.getContextPath()%>/resources/img/study/10.png">
                    <span id="examTime" class="exam-time">00:00:00</span>
                </div>
            </div>
            <div class="mui-col-xs-8 exam-icon-bar">
                <span class="exam-icon-font" ng-click="collect()">收藏</span>
                <div class="exam-icon">
                    <span id="updateFont" class="font-icon-max">Aa</span>
                    <div class="update-font">
                        <div id="fontIconMax" class="font-icon-max">Aa</div>
                        <div id="fontIconMin" class="font-icon-min">Aa</div>
                    </div>
                </div>
                <a href="#answerSheetPicture"><span class="exam-icon-font">答题卡</span></a>
            </div>
        </div>
    </div>
    <ul class="mui-table-view mui-table-view-chevron option-bar">
        <li class="mui-table-view-cell mui-media">
            <span class="list-title">单选题</span>
            <span class="page-number">
                <span class="page-current"></span>
                <span class="page-total"></span>
            </span>
            <span class="button-next">下一题</span>
            <span class="button-prev">上一题</span>
        </li>
    </ul>
    <div class="swiper-container">
        <div class="swiper-wrapper">

            <div class="swiper-slide examination_{{$index}}" ng-repeat="examination in paper">
                <input type="hidden" name="examinationId" value="{{examination.id}}">
                <input type="hidden" name="examinationType" value="{{examination.type}}">
                <ul class="mui-table-view mui-table-view-chevron">
                    <li class="mui-table-view-cell mui-media" ng-cloak>
                        <div class="await-font topic-title">{{examination.title}}（）</div>
                        <div ng-class="{true:'mui-input-row mui-radio mui-left', false:'mui-input-row mui-checkbox mui-left'}[examination.type != 1]"
                             ng-repeat="item in examination.examinationItemsList">
                            <input ng-show="examination.type != 1" type="radio"
                                   name="topic_{{examination.id}}"
                                   value="{{examination.id}}"
                                   ng-click="selectAnswer(examination.id, item.id, $index, examination.type, $event)"
                            >
                            <input ng-show="examination.type == 1" type="checkbox"
                                   name="topic_{{examination.id}}"
                                   value="{{item.id}}"
                                   index="{{$index}}"
                                   ng-click="selectAnswer(examination.id, item.id, $index, examination.type, $event)"
                            >
                            <label class="await-font">
                                <span ng-show="$index == 0">A</span>
                                <span ng-show="$index == 1">B</span>
                                <span ng-show="$index == 2">C</span>
                                <span ng-show="$index == 3">D</span>
                                <span ng-show="$index == 4">E</span>
                                <span ng-show="$index == 5">F</span>
                                <span ng-show="$index == 6">G</span>
                                <span ng-show="$index == 7">H</span>
                                <span ng-show="$index == 8">I</span>
                                <span ng-show="$index == 9">J</span>
                                <span ng-show="$index == 10">K</span>
                                、{{item.itemTitle}}
                            </label>
                        </div>
                    </li>
                </ul>
            </div>

        </div>
    </div>

</div>

<!-- 弹窗 -->
<div id="picture" class="mui-popover mui-popover-action mui-popover-bottom">
    <div class="bg-popover">
        <div ng-show="!isWriteUp">
            <div class="popover-title">
                您的答题时间已到!
            </div>
            <div class="popover-time">
                5
            </div>
            <div class="popover-hint">
                <span>5</span>
                秒之后我们将自动为您提交答案
            </div>
        </div>

        <div class="popover-title" ng-show="isWriteUp">
            您已完成所有考题，是否提交考卷？
        </div>

        <div class="popover-btn">
            <div class="mui-row">
                <div class="mui-col-xs-6" style="text-align: right;padding-right: 5px">
                    <button class="mui-btn return-btn" ng-click="submitPaper()">提交并查看</button>
                </div>
                <div class="mui-col-xs-6" style="text-align: left;padding-left: 5px">
                    <a href="#picture" class="mui-btn yellow-btn">返回检阅</a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 答题卡弹窗 -->
<div id="answerSheetPicture" class="mui-popover mui-popover-action mui-popover-bottom">
    <div class="title">
        <a href="#answerSheetPicture"><i class="fa fa-close"></i></a>
            {{curriculumName}}
    </div>
    <div class="answer-sheet">
        <div class="answer-sheet-bg">
            <div id="answerSheetPictureScroll" class="mui-scroll-wrapper">
                <div class="mui-scroll">
                    <div class="answer-item" ng-click="setSwiperIndex($index)" ng-repeat="examination in paper">
                        <span class="sort-num">{{$index + 1}}</span>
                        <span id="answer_{{examination.id}}"></span>
                        <input type="hidden" examinationId="{{examination.id}}">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="fix-div">
        <a ng-click="submitPaper()" class="mui-btn mui-btn-block fix-btn">提交并查看</a>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/swiper.min.js"></script>

<script>
    var examination_index = 0; //题索引
    mui("#answerSheetPictureScroll").scroll();
    var swiper = new Swiper('.swiper-container', {
        nextButton: '.button-next',
        prevButton: '.button-prev',
        pagination: '.page-number',
        autoHeight: true, //自适应高度
        paginationType : 'fraction',
        observer:true,//修改swiper自己或子元素时，自动初始化swiper
        observeParents:true,//修改swiper的父元素时，自动初始化swiper
        //设置页码
        paginationCustomRender: function (swiper, currentClassName, totalClassName) {
            return '<span class="' + currentClassName + '"></span>' +
                    '<span class="' + totalClassName + '"></span>';
        },
        //拖动获取当前页码
        onSlideChangeStart: function(swiper){
            examination_index = swiper.activeIndex;
            if ($(".examination_" + examination_index).find("input[name='examinationType']").val() == 0) {
                $(".list-title").text("单选题");
            }
            else if ($(".examination_" + examination_index).find("input[name='examinationType']").val() == 1) {
                $(".list-title").text("多选题");
            }
            else if ($(".examination_" + examination_index).find("input[name='examinationType']").val() == 2) {
                $(".list-title").text("判断题");
            }
            CC.print(swiper.activeIndex);
        }
    });

    var webApp = angular.module('webApp', []);
    webApp.controller('controller', function($scope) {
        $scope.curriculumName = sessionStorage.getItem("curriculumName"); //获取传过来的名字
        $scope.paperId = CC.getUrlParam("paperId"); //试卷ID
        $scope.type = CC.getUrlParam("type"); //类型
        $scope.useTime = CC.getUrlParam("useTime"); //考试时间
        $scope.orderId = CC.getUrlParam("orderId"); //订单ID
        $scope.paper = null; //试卷
        $scope.seconds = 0; //考试计时器
        $scope.isSelfMotion = false; //是否是自动提交
        $scope.isWriteUp = true; //判断是否填写完

        CC.ajaxRequestData("post", false, "paper/queryPaperById", {paperId : $scope.paperId}, function (result) {
            $scope.paper = result.data;
        });

        //收藏
        $scope.collect = function () {
            var parameter = {
                type : 2,
                targetId : $(".examination_" + examination_index).find("input[name='examinationId']").val()
            }
            CC.ajaxRequestData("post", false, "collect/addCollect", parameter, function () {
                mui.alert("收藏成功.");
            });
        }

        //添加答案
        $scope.selectAnswer = function (examinationId, examinationItemsId, sortNum, type, $event) {
            var obj = event.target;
            if (type == 1) {
                $scope.answers = [];
                $scope.answerLetter = [];
                $(obj).parent().parent().parent().find("input[type='checkbox']").each(function () {
                    if ($(this).is(':checked')) {
                        $scope.answers.push($(this).val());
                        $scope.answerLetter.push(letter($(this).attr("index")));
                    }
                });
                $("#answer_" + examinationId).html($scope.answerLetter.toString());
                $("#answer_" + examinationId).next().val($scope.answers.toString());
            }
            else {
                $("#answer_" + examinationId).html(letter(sortNum));
                $("#answer_" + examinationId).next().val(examinationItemsId);
            }
            $("#answer_" + examinationId).parent().addClass("answer-active");

            var isWriteUp = true;
            $("#answerSheetPictureScroll").find("input").each(function () {
                if ($(this).val() == "") {
                    $scope.isWriteUp = false;
                    isWriteUp = false;
                }
            });
            //表示填完了
            if (isWriteUp) {
                $scope.isWriteUp = true;
                mui('#picture').popover('toggle');
            }

        }

        //跳转题
        $scope.setSwiperIndex = function (index) {
            swiper.slideTo(index, 1000, false);//切换到第一个slide，速度为1秒
            mui('#answerSheetPicture').popover('toggle');
        }

        //提交答案
        $scope.submitPaper = function () {
            $scope.answers = [];
            $scope.isFinish = false;
            $("#answerSheetPictureScroll").find("input").each(function () {
                if ($(this).val() == "") {
                    $scope.isFinish = true;
                }
                var ids = $(this).val().split(",");
                for (var i = 0; i < ids.length; i++) {
                    if (!isNaN(parseInt(ids[i]))) {
                        ids[i] = parseInt(ids[i]);
                    }
                }
                $scope.answers.push({
                    examinationId : $(this).attr("examinationId"),
                    answers : ids
                });
            });

            $scope.parameter = {
                answers : JSON.stringify($scope.answers),
                paperId : $scope.paperId,
                orderId : $scope.orderId,
                seconds : $scope.seconds
            }
            CC.print($scope.parameter);
            if ($scope.isFinish && !$scope.isSelfMotion) {
                mui.confirm('系统检查到您有未做题,您确认要提交？', '', ["确认","取消"], function(e) {
                    if (e.index == 0) {
                        CC.ajaxRequestData("post", false, "paper/submitPaper", $scope.parameter, function () {
                            mui.toast("提交成功.");
                            location.href = CC.ip + "page/submitAnswer?paperId=" + $scope.paperId + "&orderId=" + $scope.orderId;
                        });
                    }
                });
            }
            else {
                CC.ajaxRequestData("post", false, "paper/submitPaper", $scope.parameter, function () {
                    mui.toast("提交成功.");
                    location.href = CC.ip + "page/submitAnswer?paperId=" + $scope.paperId + "&orderId=" + $scope.orderId;
                });
            }
        }

        $scope.countDown = $scope.useTime - 1; //存放倒计时总时间
        /*$("#examTime").html(CC.getFormatTime($scope.useTime));
        if (sessionStorage.getItem("countDown") == null || sessionStorage.getItem("countDown") == "NaN") {
            sessionStorage.setItem("countDown", $scope.countDown); //存本地倒计时
        }
        else {
            $scope.countDown = sessionStorage.getItem("countDown") == "NaN" ? $scope.useTime : sessionStorage.getItem("countDown");
            $scope.seconds = sessionStorage.getItem("seconds") == null ? 0 : sessionStorage.getItem("seconds");
        }*/

        $scope.timerId = 0; //定时器ID
        $scope.isPause = true; //是否暂停
        $scope.startTime = function () {
            $scope.isPause = false;
            $scope.timerId = setInterval(function () {
                if ($scope.countDown == 5) {
                    mui('#picture').popover('toggle');
                }
                else if ($scope.countDown < 5 && $scope.countDown > 0) {
                    $(".popover-time").html($scope.countDown);
                    //sessionStorage.setItem("countDown", $scope.countDown);
                    $("#examTime").html(CC.getFormatTime($scope.countDown));
                    //$scope.seconds++;
                    //sessionStorage.setItem("seconds", $scope.seconds);
                }
                else if ($scope.countDown == 0) {
                    mui('#picture').popover('toggle');
                    clearInterval($scope.timerId);
                    if($scope.type != 0) $scope.endTime();
                    $scope.isSelfMotion = true;
                    $scope.isWriteUp = false;
                    $scope.submitPaper();
                }
                else {
                    //sessionStorage.setItem("countDown", $scope.countDown);
                    $("#examTime").html(CC.getFormatTime($scope.countDown));
                    //$scope.seconds++;
                    //sessionStorage.setItem("seconds", $scope.seconds);
                }
                $scope.countDown--;
            }, 1000);
        }
        if ($scope.type != 0) $scope.startTime(); //判断是否是默认启动

        $scope.endTime = function () {
            clearInterval($scope.timerId);
            $scope.isPause = true;
        }

    });

    //字母
    function letter (sortNum) {
        if (sortNum == 0) return "A";
        if (sortNum == 1) return "B";
        if (sortNum == 2) return "C";
        if (sortNum == 3) return "D";
        if (sortNum == 4) return "E";
        if (sortNum == 5) return "F";
        if (sortNum == 6) return "G";
        if (sortNum == 7) return "H";
        if (sortNum == 8) return "I";
        if (sortNum == 9) return "J";
        if (sortNum == 10) return "K";
    }


    //防止页面后退
    /*history.pushState(null, null, document.URL);
    window.addEventListener('popstate', function () {
        alert("不准返回.");
        history.pushState(null, null, document.URL);
    });*/

    $(function() {
        var height = document.body.clientHeight;
        $(".answer-sheet-bg").css("minHeight", (height - 130) + "px");

        //更改字体
        $("#updateFont").click(function (event) {
            event.stopPropagation();
            $(".update-font").slideToggle();
        });
        $("#fontIconMax").click(function (event) {
            event.stopPropagation();
            $(".await-font").addClass("max-font").removeClass("min-font");
            $(".update-font").slideToggle();
        });
        $("#fontIconMin").click(function (event) {
            event.stopPropagation();
            $(".await-font").addClass("min-font").removeClass("max-font");
            $(".update-font").slideToggle();
        });
        $("body").click(function () {
            $(".update-font").slideUp();
        });
    });

</script>

</body>
</html>
