
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>课程播放</title>
    <meta http-equiv="cache-control" content="max-age=0" />
    <meta http-equiv="cache-control" content="no-cache" />
    <meta http-equiv="expires" content="0" />
    <meta http-equiv="expires" content="Tue, 01 Jan 1980 1:00:00 GMT" />
    <meta http-equiv="pragma" content="no-cache" />
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/course/video.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/course/courseVideo.css">
    <style>
        /*隐藏下拉样式*/
        .mui-pull-top-pocket .mui-pull-loading:before,
        .mui-pull-top-pocket .mui-pull-loading:after,
        .mui-pull-top-pocket .mui-spinner:after {
            content: '' !important;
            background: none !important;
        }
        /*图片预览css*/
        .mui-preview-image.mui-fullscreen {
            position: fixed;
            z-index: 1001;
            background-color: #000;
        }
        .mui-preview-header,
        .mui-preview-footer {
            position: absolute;
            width: 100%;
            left: 0;
            z-index: 10;
        }
        .mui-preview-header {
            height: 44px;
            top: 0;
        }
        .mui-preview-footer {
            height: 50px;
            bottom: 0px;
        }
        .mui-preview-header .mui-preview-indicator {
            display: block;
            line-height: 25px;
            color: #fff;
            text-align: center;
            margin: 15px auto 4px !important;
            background-color: rgba(0, 0, 0, 0.4);
            border-radius: 12px;
            font-size: 16px;
        }
        .mui-preview-image {
            display: none;
            -webkit-animation-duration: 0.5s;
            animation-duration: 0.5s;
            -webkit-animation-fill-mode: both;
            animation-fill-mode: both;
        }
        .mui-preview-image.mui-preview-in {
            -webkit-animation-name: fadeIn;
            animation-name: fadeIn;
        }
        .mui-preview-image.mui-preview-out {
            background: none;
            -webkit-animation-name: fadeOut;
            animation-name: fadeOut;
        }
        .mui-preview-image.mui-preview-out .mui-preview-header,
        .mui-preview-image.mui-preview-out .mui-preview-footer {
            display: none;
        }
        .mui-zoom-scroller {
            position: absolute;
            display: -webkit-box;
            display: -webkit-flex;
            display: flex;
            -webkit-box-align: center;
            -webkit-align-items: center;
            align-items: center;
            -webkit-box-pack: center;
            -webkit-justify-content: center;
            justify-content: center;
            left: 0;
            right: 0;
            bottom: 0;
            top: 0;
            width: 100%;
            height: 100%;
            margin: 0;
            -webkit-backface-visibility: hidden;
        }
        .mui-zoom {
            -webkit-transform-style: preserve-3d;
            transform-style: preserve-3d;
        }
        #page3 .mui-slider .mui-slider-group .mui-slider-item img {
            width: auto;
            height: auto;
            max-width: 100%;
            max-height: 100%;
        }
        .mui-android-4-1 .mui-slider .mui-slider-group .mui-slider-item img {
            width: 100%;
        }
        .mui-android-4-1 .mui-slider.mui-preview-image .mui-slider-group .mui-slider-item {
            display: inline-table;
        }
        .mui-android-4-1 .mui-slider.mui-preview-image .mui-zoom-scroller img {
            display: table-cell;
            vertical-align: middle;
        }
        .mui-preview-loading {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            display: none;
        }
        .mui-preview-loading.mui-active {
            display: block;
        }
        .mui-preview-loading .mui-spinner-white {
            position: absolute;
            top: 50%;
            left: 50%;
            margin-left: -25px;
            margin-top: -25px;
            height: 50px;
            width: 50px;
        }
        .mui-preview-image img.mui-transitioning {
            -webkit-transition: -webkit-transform 0.5s ease, opacity 0.5s ease;
            transition: transform 0.5s ease, opacity 0.5s ease;
        }
        @-webkit-keyframes fadeIn {
            0% {
                opacity: 0;
            }
            100% {
                opacity: 1;
            }
        }
        @keyframes fadeIn {
            0% {
                opacity: 0;
            }
            100% {
                opacity: 1;
            }
        }
        @-webkit-keyframes fadeOut {
            0% {
                opacity: 1;
            }
            100% {
                opacity: 0;
            }
        }
        @keyframes fadeOut {
            0% {
                opacity: 1;
            }
            100% {
                opacity: 0;
            }
        }
        p img {
            max-width: 100%;
            height: auto;
        }
        body{overflow: hidden}
    </style>
</head>
<body ng-app="webApp" ng-controller="courseVideoController">

<div class="mui-content" style="display: block">

    <!-- 播放器开始 -->
    <div class="video-wrap">
        <!-- 视频 -->
        <video id="video" class="video" src=""
               x5-playsinline
               webkit-playsinline="true"
               playsinline="true"
               x-webkit-airplay="true"
               x5-video-player-type="h5"
               x5-video-player-fullscreen="true"
               x5-video-ignore-metadata="true"
        ></video>
        <!--控制栏-->
        <div class="video-control-bar">
            <div class="theLeft">
                <input id="startBtn" ng-click="clickPlay()" class="start-or-end-btn" type="image" src="<%=request.getContextPath()%>/resources/img/video/start.png" />
                <input id="endBtn" ng-click="clickPause()" class="start-or-end-btn hide" type="image" src="<%=request.getContextPath()%>/resources/img/video/pause.png" />
                <span id="totalTime" class="video-time">00:00</span>
            </div>
            <div class="progress-out">
                <div id="progressBar" class="progress-bar">
                    <!-- 滑条 -->
                    <div id="range" class="range">
                        <!-- 缓冲进度条 -->
                        <div id="bufferProgress" class="buffer-progress"></div>

                        <!-- 已播放进度 -->
                        <div id="cashProgress" class="cash-progress"></div>

                        <!-- 滑动物 -->
                        <span id="glider" class="glider"></span>
                    </div>
                </div>
            </div>
            <div class="theRight">
                <span id="currentTime" class="video-time">00:00</span>
            </div>
        </div>

        <!-- 视频遮罩 -->
        <div class="video-shade">
            <img id="videoCover" class="video-cover">
            <img class="video-loading" src="<%=request.getContextPath()%>/resources/img/video/loading.png" ng-click="clickPlay()"/>
        </div>

    </div>
    <!-- 播放器结束 -->


    <div class="course-info">
        <div id="slider" class="mui-slider">
            <div id="sliderSegmentedControl" class="mui-slider-indicator mui-segmented-control mui-segmented-control-inverted">
                <a class="mui-control-item mui-active" href="#page1">
                    <span>介绍</span>
                </a>
                <a class="mui-control-item" href="#page2">
                    <span>目录</span>
                </a>
                <a class="mui-control-item" href="#page3">
                    <span>讲义</span>
                </a>
                <a class="mui-control-item" href="#page4">
                    <span>评论</span>
                </a>
            </div>
            <div id="sliderProgressBar" class="mui-slider-progress-bar mui-col-xs-3"></div>
            <div class="mui-slider-group" id="mui-slider-group">
                <!--介绍-->
                <div id="page1" class="mui-slider-item mui-control-content mui-active">
                    <div id="introduce" class="mui-content mui-scroll-wrapper">
                        <div class="mui-scroll">
                            <div class="introduce-title">
                                <span class="perch"></span>
                                <span class="title">课程介绍</span>
                                <div id="number"></div>
                                <img id="imgUrl" style="width: 60px">
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
                    <div id="catalogue" class="mui-content mui-scroll-wrapper">
                        <div class="mui-scroll">
                            <ul class="mui-table-view mui-table-view-chevron" id="catalogueList">
                                <li class="mui-ellipsis catalogue" ng-repeat="video in videoList">
                                    <!-- 收费课程 -->
                                    <button type="button" ng-show="(video.videoStatus != null || $index == 0) && curriculum.type != 0" href="javascript:void(0)" ng-click="clickVideo(video, $index, false)">
                                        {{video.courseWare.courseWareName}}：{{video.name}}
                                        <span class="catalogue-time" ng-if="userInfo == null ||userInfo.definition == 0">
                                            {{video.lowDefinitionSeconds}}
                                        </span>
                                        <span class="catalogue-time" ng-if="userInfo.definition == 1">
                                            {{video.highDefinitionSeconds}}
                                        </span>
                                    </button>
                                    <button type="button" ng-show="(video.videoStatus == null && $index != 0) && curriculum.type != 0" class="not-study" ng-click="notClickVideo()">
                                        {{video.courseWare.courseWareName}}：{{video.name}}
                                        <span class="catalogue-time" ng-if="userInfo == null ||userInfo.definition == 0">
                                            {{video.lowDefinitionSeconds}}
                                        </span>
                                        <span class="catalogue-time" ng-if="userInfo.definition == 1">
                                            {{video.highDefinitionSeconds}}
                                        </span>
                                    </button>

                                    <!-- 免费课程 -->
                                    <button type="button" ng-show="curriculum.type == 0" ng-click="clickVideo(video, $index, false)">
                                        {{video.courseWare.courseWareName}}：{{video.name}}
                                        <span class="catalogue-time" ng-if="userInfo == null ||userInfo.definition == 0">
                                            {{video.lowDefinitionSeconds}}
                                        </span>
                                        <span class="catalogue-time" ng-if="userInfo.definition == 1">
                                            {{video.highDefinitionSeconds}}
                                        </span>
                                    </button>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!--讲义-->
                <div id="page3" class="mui-slider-item mui-control-content">
                    <div id="handouts" class="mui-content mui-scroll-wrapper">
                        <div class="mui-scroll">
                            <div class="not-data" ng-if="pptList.length == 0">没有讲义.</div>
                            <div id="ppt">
                                <img ng-repeat="ppt in pptList" src="{{ipImg}}{{ppt}}" data-preview-src="" data-preview-group="1">
                            </div>
                        </div>
                    </div>
                </div>

                <!--评论-->
                <div id="page4" class="mui-slider-item mui-control-content">
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

    <!-- 发表评论 -->
    <div class="comment-bar">
        <div ng-show="userInfo == null || userInfo.avatar == null" class="user-avatar" style="background: url('<%=request.getContextPath()%>/resources/img/my/11.png')"></div>
        <div ng-show="userInfo.avatar != null" class="user-avatar" style="background: url('{{ipImg}}{{userInfo.avatar}}')"></div>
        <input type="text" maxlength="200" placeholder="在这里评论···" ng-model="content">
        <button type="button" style="background: #2E75B5;" ng-click="comment()">发送</button>
    </div>
</div>

<!-- 练习弹窗 -->
<div id="pictureExercise" class="mui-popover mui-popover-action mui-popover-bottom">
    <div class="bg-popover">
        <div class="popover-title">
            本课时已看完
        </div>
        <div class="popover-hint">
            您可以选择开始考核该课时，或者观看下个课时
        </div>
        <div class="popover-btn">
            <div class="mui-row">
                <div class="mui-col-xs-6" style="text-align: right;padding-right: 5px">
                    <button class="mui-btn return-btn" ng-click="nextVideo()">观看下个视频</button>
                </div>
                <div class="mui-col-xs-6" style="text-align: left;padding-left: 5px">
                    <button ng-click="startEvaluation(0)" class="mui-btn yellow-btn">去练习</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 模拟弹窗 -->
<div id="pictureSimulate" class="mui-popover mui-popover-action mui-popover-bottom">
    <div class="bg-popover">
        <div class="popover-title">
            本课程已看完
        </div>
        <div class="popover-hint">
            您可以选择去练习，或者去模拟
        </div>
        <div class="popover-btn">
            <div class="mui-row">
                <div class="mui-col-xs-6" style="text-align: right;padding-right: 5px">
                    <button ng-click="startEvaluation(0)" class="mui-btn return-btn">去练习</button>
                </div>
                <div class="mui-col-xs-6" style="text-align: left;padding-left: 5px">
                    <button ng-click="startEvaluation(1)" class="mui-btn yellow-btn">去模拟</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 考试通过弹窗--没有题的情况下 -->
<div id="picturePass" class="mui-popover mui-popover-action mui-popover-bottom">
    <div class="bg-popover">
        <div class="popover-title">
            本课程已看完
        </div>
        <div class="popover-hint">
            恭喜您已通过考试!
        </div>
        <div class="popover-btn">
            <div class="mui-row">
                <div class="mui-col-xs-12" style="text-align: center;">
                    <button ng-click="picturePass()" class="mui-btn return-btn">确认</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 人脸识别提示窗 -->
<div class="face-shade" id="faceShade">
    <div class="face-shade-bg">
        <div class="face-shade-title">是否进行人脸对比</div>
        <div class="face-shade-hint">人脸对比成功了才能继续往下看.</div>
        <div class="face-shade-btn">
            <div class="mui-row">
                <div class="mui-col-xs-6" style="text-align: right;padding-right: 5px">
                    <button class="mui-btn return-btn" ng-click="affirmFace()">确认对比</button>
                </div>
                <div class="mui-col-xs-6" style="text-align: left;padding-left: 5px">
                    <button ng-click="cancelFace()" class="mui-btn yellow-btn">取消对比</button>
                </div>
            </div>
        </div>
    </div>
</div>

<input id="File" type="file" name="File" accept="image/*" capture="camera" class="hide">

<%@include file="../common/js.jsp" %>
<script src="<%=request.getContextPath()%>/resources/js/video.js"></script>
<script src="<%=request.getContextPath()%>/resources/js/mui.zoom.js"></script>
<script src="<%=request.getContextPath()%>/resources/js/mui.previewimage.js"></script>

<script>
    CC.reload(); //刷新一下上一页传回来的东西
    var curriculumId = CC.getUrlParam("curriculumId"); //课程ID
    var orderId = CC.getUrlParam("orderId"); //订单ID
    var isAudition = CC.getUrlParam("isAudition"); //是否免费
    var webApp = angular.module('webApp', []);
    webApp.controller('courseVideoController', function($scope, $http, $timeout,$sce) {
        $scope.userInfo = CC.getUserInfo();
        $scope.ipImg = CC.ipImg; //图片IP
        $scope.ipVideo = CC.ipVideo; //视频IP
        $scope.content = ""; //存放评论内容

        $scope.curriculum = null; //课程对象
        $scope.video = null; //存放当前播放视频对象
        $scope.videoList = []; //存放所有的视频集合
        $scope.videoIndex = 0; //代表播放视频下标
        $scope.pptList = null; //存放ppt

        /** 获取课程信息 **/
        $scope.getCurriculum = function () {
            if (isAudition == 1) {
                isDrag = true; //免费课程可以拖动
                CC.ajaxRequestData("post", false, "curriculum/queryCurriculumById", {curriculumId : curriculumId}, function (result) {
                    $scope.curriculum = result.data;
                    //分割PPT
                    for (var i = 0; i < $scope.curriculum.courseWares.length; i++) {
                        var obj = $scope.curriculum.courseWares[i];
                        if (obj.ppt != null && obj != "") {
                            obj.ppts = obj.ppt.split(",");
                        }
                    }

                    //格式化时间
                    for (var i = 0; i < $scope.curriculum.courseWares.length; i++) {
                        var courseWares = $scope.curriculum.courseWares[i];
                        for (var j = 0; j < courseWares.videos.length; j++) {
                            var video = courseWares.videos[j];
                            video.highDefinitionSeconds = CC.getFormatTime(video.highDefinitionSeconds);
                            video.lowDefinitionSeconds = CC.getFormatTime(video.lowDefinitionSeconds);
                        }
                    }
                });
            }
            else {
                isDrag = false; //收费课程不可以拖动
                CC.ajaxRequestData("post", false, "curriculum/queryCurriculumByOrder", {orderId : orderId}, function (result) {
                    $scope.curriculum = result.data;
                    //分割PPT
                    for (var i = 0; i < $scope.curriculum.courseWares.length; i++) {
                        var obj = $scope.curriculum.courseWares[i];
                        if (obj.ppt != null && obj != "") {
                            obj.ppts = obj.ppt.split(",");
                        }
                    }

                    //格式化时间
                    for (var i = 0; i < $scope.curriculum.courseWares.length; i++) {
                        var courseWares = $scope.curriculum.courseWares[i];
                        for (var j = 0; j < courseWares.videos.length; j++) {
                            var video = courseWares.videos[j];
                            video.highDefinitionSeconds = CC.getFormatTime(video.highDefinitionSeconds);
                            video.lowDefinitionSeconds = CC.getFormatTime(video.lowDefinitionSeconds);
                        }
                    }
                });
            }
        }
        $scope.getCurriculum();

        /** 筛选视频集合 **/
        $scope.screenVideoList = function () {
            $scope.videoList = [];
            for (var i = 0; i < $scope.curriculum.courseWares.length; i++) {
                var courseWare = $scope.curriculum.courseWares[i];
                for (var j = 0; j < courseWare.videos.length; j++) {
                    var video = courseWare.videos[j];
                    video.courseWare = courseWare;
                    $scope.videoList.push(video);
                }
            }
        }
        $scope.screenVideoList();

        /** 筛选初始化视频**/
        $scope.firstVideo = function () {
            var isPayAll = false;
            for (var i = 0; i < $scope.videoList.length; i++) {
                var video = $scope.videoList[i];
                $scope.video = video; //赋值当前视频播放对象
                //寻找播放视频、判断是否有记录
                if (video.videoStatus == null) {
                    //设置播放清晰度
                    if ($scope.userInfo == null || $scope.userInfo.definition == 0) {
                        if (video.lowDefinition.indexOf("http") != -1 || video.lowDefinition.indexOf("https") != -1 ) {
                            initVideo.setSrc(video.lowDefinition);
                        }
                        else {
                            initVideo.setSrc($scope.ipVideo + video.lowDefinition);
                        }
                        initVideo.shadeShow();
                    }
                    else {
                        if (video.highDefinition.indexOf("http") != -1 || video.highDefinition.indexOf("https") != -1 ) {
                            initVideo.setSrc(video.highDefinition);
                        }
                        else {
                            initVideo.setSrc($scope.ipVideo + video.highDefinition);
                        }
                        initVideo.shadeShow();
                    }
                    $("#videoCover").attr("src", CC.ipImg + video.cover);
                    $scope.videoIndex = i; //赋值播放下标
                    $scope.pptList = video.courseWare.ppts; //赋值ppts
                    isPayAll = true;
                    break;
                }
                else if (video.videoStatus.status == 0 || video.videoStatus.status == 1) {
                    //设置播放清晰度
                    if ($scope.userInfo == null || $scope.userInfo.definition == 0) {
                        if (video.lowDefinition.indexOf("http") != -1 || video.lowDefinition.indexOf("https") != -1 ) {
                            initVideo.setSrc(video.lowDefinition);
                        }
                        else {
                            initVideo.setSrc($scope.ipVideo + video.lowDefinition);
                        }
                        initVideo.shadeShow();
                    }
                    else {
                        if (video.highDefinition.indexOf("http") != -1 || video.highDefinition.indexOf("https") != -1 ) {
                            initVideo.setSrc(video.highDefinition);
                        }
                        else {
                            initVideo.setSrc($scope.ipVideo + video.highDefinition);
                        }
                        initVideo.shadeShow();
                    }
                    $("#videoCover").attr("src", CC.ipImg + video.cover);
                    initVideo.setCurrentTime($scope.video.videoStatus.seconds);
                    $scope.videoIndex = i; //赋值播放下标
                    $scope.pptList = video.courseWare.ppts; //赋值ppts
                    isPayAll = true;
                    break;
                }
            }
            if (!isPayAll && $scope.videoList.length > 0) { //表示已经看完所有视频
                //设置播放清晰度
                if ($scope.userInfo == null || $scope.userInfo.definition == 0) {
                    if ($scope.videoList[0].lowDefinition.indexOf("http") != -1 || $scope.videoList[0].lowDefinition.indexOf("https") != -1 ) {
                        initVideo.setSrc($scope.videoList[0].lowDefinition);
                    }
                    else {
                        initVideo.setSrc($scope.ipVideo + $scope.videoList[0].lowDefinition);
                    }
                    initVideo.shadeShow();
                }
                else {
                    if ($scope.videoList[0].highDefinition.indexOf("http") != -1 || $scope.videoList[0].highDefinition.indexOf("https") != -1 ) {
                        initVideo.setSrc($scope.videoList[0].highDefinition);
                    }
                    else {
                        initVideo.setSrc($scope.ipVideo + $scope.videoList[0].highDefinition);
                    }
                    initVideo.shadeShow();
                }
                $scope.pptList = $scope.videoList[0].courseWare.ppts; //赋值ppts
                $("#videoCover").attr("src", CC.ipImg + $scope.videoList[0].cover);
                isDrag = true;
            }
        }
        $scope.firstVideo();

        /** 点击目录视频播放或者自动切换下一个 **/
        $scope.clickVideo = function (video, index, isSelfMotion) {
            $scope.video = video; //存入当前视频对象
            $scope.videoIndex = index; //存入下标
            //判断是否可以播放
            if ($scope.curriculum.type != 0 && !isSelfMotion) {
                var isBeBeing = false;
                var src = $("#video").attr("src");
                if ($scope.userInfo.definition == 0 && src.indexOf(video.lowDefinition) != -1) {
                    isBeBeing = true;
                }
                else if($scope.userInfo.definition == 1 && src.indexOf(video.highDefinition) != -1) {
                    isBeBeing = true;
                }
                if (video.videoStatus == null && !isBeBeing) {
                    mui.toast("该视频暂不能播放.");
                    return false;
                }
            }
            $timeout(function () { //更新PPT
                $scope.pptList = video.courseWare.ppts; //赋值ppts
            });
            CC.print(video);
            if ($scope.userInfo == null || $scope.userInfo.definition == 0) {
                if (video.lowDefinition.indexOf("http") != -1 || video.lowDefinition.indexOf("https") != -1 ) {
                    initVideo.setSrc(video.lowDefinition);
                }
                else {
                    initVideo.setSrc($scope.ipVideo + video.lowDefinition);
                }
            }
            else {
                if (video.highDefinition.indexOf("http") != -1 || video.highDefinition.indexOf("https") != -1 ) {
                    initVideo.setSrc(video.highDefinition);
                }
                else {
                    initVideo.setSrc($scope.ipVideo + video.highDefinition);
                }
            }
            $("#videoCover").attr("src", CC.ipImg + video.cover);
            initVideo.shadeShow();
            initVideo.restore(); //还原进度条
            seconds = 0; //播放完成把计时器清0
            initVideo.setTotalTime(); //重新给视频赋值总时间
            if ($scope.curriculum.type == 0 && isSelfMotion) {
                isDrag = true; //可拖动
                initVideo.play();
                initVideo.shadeHide();
            }
        }

        /**点击不能播放视频**/
        $scope.notClickVideo = function () {
            mui.toast("该视频暂不能播放.");
            return false;
        }

        /** 点击播放按钮 **/
        $scope.clickPlay = function () {
            if ($scope.video == null) {
                mui.toast("暂无播放视频.");
                return false;
            }
            if (initVideo.getNetworkState() == 3) {
                mui.toast("视频播放失败.");
                return false;
            }
            if ($scope.curriculum.type != 0 && seconds != 0) { //判断是否是免费
                if ($scope.isFace && seconds == initVideo.getCurrentTime() && $scope.curriculum.type != 0) {
                    var u = navigator.userAgent;
                    var isAndroid = u.indexOf('Android') > -1 || u.indexOf('Adr') > -1; //判断是否是安卓
                    if (!isAndroid) {
                        $("#faceShade").fadeIn(100); //非安卓显示自定义拍照
                    }
                    else {
                        var jsSignList = CC.getWxJsSign(); //微信api签名
                        wx.config({
                            debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
                            appId: jsSignList.appId, // 必填，公众号的唯一标识
                            timestamp: jsSignList.timestamp, // 必填，生成签名的时间戳
                            nonceStr: jsSignList.noncestr, // 必填，生成签名的随机串
                            signature: jsSignList.signature,// 必填，签名，见附录1
                            jsApiList: ["chooseImage", "previewImage", "uploadImage"] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
                        });
                        wx.ready(function(){
                            //微信拍照
                            wx.chooseImage({
                                count: 1, // 默认9
                                sizeType: ['compressed'], // 可以指定是原图还是压缩图，默认二者都有
                                sourceType: ['camera'], // 可以指定来源是相册还是相机，默认二者都有
                                success: function (res) {
                                    var localIds = res.localIds; // 返回选定照片的本地ID列表，localId可以作为img标签的src属性显示图片
                                    wx.uploadImage({
                                        localId: localIds[0], // 需要上传的图片的本地ID，由chooseImage接口获得
                                        isShowProgressTips: 1,// 默认为1，显示进度提示
                                        success: function (res) {
                                            var serverId = res.serverId; // 返回图片的服务器端ID
                                            CC.ajaxRequestData("post", false, "wxClient/downImage", { mediaId : serverId, accessToken : jsSignList.access_token }, function (result) {
                                                //$("#imgUrl").attr("src", result.data);
                                                $scope.checkFace(result.data.split(",")[1], result.data);
                                            });
                                        }
                                    });
                                }
                            });
                        });
                    }
                    return false;
                }
                //判断第一次开始播放插入记录
                else if ($scope.userInfo != null) {
                    CC.ajaxRequestData("post", false, "videoStatus/queryNewVideoStatus", { videoId : $scope.video.id, orderId : orderId }, function (result) {
                        if (result.data == undefined) {
                            $scope.addVideoStatus($scope.video.id, 0, 0);
                        }
                    });
                    initVideo.play();
                    initVideo.shadeHide();
                }
            }
            else {
                initVideo.play();
                initVideo.shadeHide();
            }
        }

        /** 点击暂停按钮 **/
        $scope.clickPause = function () {
            initVideo.pause();
        }

        $scope.isFirst = false;
        $scope.isFirstTwo = false;

        /** 播放事件 **/
        initVideo.onTimeUpdate(function() {
            initVideo.startPlay(); //改变进度条
            if (seconds <= initVideo.getCurrentTime()) {
                if ($scope.curriculum.type != 0 && ($scope.video.videoStatus == null || $scope.video.videoStatus.status == 0 || $scope.video.videoStatus.status == 1)) {
                    isDrag = false; //不可拖动

                    /*if (seconds == 240) { // TODO 判断四分钟人脸识别
                        $("#faceShade").fadeIn(100);
                        $scope.isFace = true;
                        initVideo.pause();
                    }*/

                    // TODO 安卓端特殊处理代码--处理强制视频弹窗全屏播放
                    if (!$scope.isFirst) {
                        seconds = initVideo.getCurrentTime();
                        $scope.isFirst = true;
                    }
                    if (initVideo.getCurrentTime() > seconds + 1) {
                        initVideo.setCurrentTime(seconds);
                    }

                    if (seconds == 240) { // TODO 判断四分钟人脸识别
                        $scope.isFace = true;
                        initVideo.pause();
                        //initVideo.setCurrentTime(seconds);
                        var u = navigator.userAgent;
                        var isAndroid = u.indexOf('Android') > -1 || u.indexOf('Adr') > -1; //判断是否是安卓
                        if (!isAndroid) {
                            $("#faceShade").fadeIn(100); //非安卓显示自定义拍照
                        }
                        else {
                            if (!$scope.isFirstTwo) {
                                $scope.isFirstTwo = true;
                                var jsSignList = CC.getWxJsSign(); //微信api签名
                                wx.config({
                                    debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
                                    appId: jsSignList.appId, // 必填，公众号的唯一标识
                                    timestamp: jsSignList.timestamp, // 必填，生成签名的时间戳
                                    nonceStr: jsSignList.noncestr, // 必填，生成签名的随机串
                                    signature: jsSignList.signature,// 必填，签名，见附录1
                                    jsApiList : [ 'chooseImage', 'previewImage', 'uploadImage'] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
                                });
                                wx.ready(function(){
                                    $scope.isFirstTwo = false;
                                    //微信拍照
                                    wx.chooseImage({
                                        count: 1, // 默认9
                                        sizeType: ['compressed'], // 可以指定是原图还是压缩图，默认二者都有
                                        sourceType: ['camera'], // 可以指定来源是相册还是相机，默认二者都有
                                        success: function (res) {
                                            var localIds = res.localIds; // 返回选定照片的本地ID列表，localId可以作为img标签的src属性显示图片
                                            wx.uploadImage({
                                                localId: localIds[0], // 需要上传的图片的本地ID，由chooseImage接口获得
                                                isShowProgressTips: 1,// 默认为1，显示进度提示
                                                success: function (res) {
                                                    var serverId = res.serverId; // 返回图片的服务器端ID
                                                    CC.ajaxRequestData("post", false, "wxClient/downImage", { mediaId : serverId, accessToken : jsSignList.access_token }, function (result) {
                                                        //$("#imgUrl").attr("src", result.data);
                                                        $scope.checkFace(result.data.split(",")[1], result.data);
                                                    });
                                                }
                                            });
                                        }
                                    });
                                });
                            }
                        }
                    }

                    /*var oneFace = parseInt(initVideo.getTotalTime() / 3); //第一次人脸识别值
                    var twoFace = parseInt(initVideo.getTotalTime() / 2); //第二次人脸识别值
                    if (initVideo.getTotalTime() < 180) {
                        if (oneFace == initVideo.getCurrentTime() && seconds != 0) {
                            if ($scope.getFace() == 0) {
                                $scope.isFace = true;
                                $("#faceShade").fadeIn(100);
                                initVideo.pause();
                            }
                        }
                        if (twoFace == initVideo.getCurrentTime() && seconds != 0) {
                            if ($scope.getFace() == 1) {
                                $scope.isFace = true;
                                $("#faceShade").fadeIn(100);
                                initVideo.pause();
                            }
                        }
                    }
                    else {
                        if (seconds == 60) { //TODO 纯属标记，比较关键
                            if ($scope.getFace() == 0) {
                                $scope.isFace = true;
                                $("#faceShade").fadeIn(100);
                                initVideo.pause();
                            }
                        }
                        if (oneFace == initVideo.getCurrentTime() && seconds != 0) {
                            if ($scope.getFace() == 1) {
                                $scope.isFace = true;
                                $("#faceShade").fadeIn(100);
                                initVideo.pause();
                            }
                        }
                        if (twoFace == initVideo.getCurrentTime() && seconds != 0) {
                            if ($scope.getFace() == 2) {
                                $scope.isFace = true;
                                $("#faceShade").fadeIn(100);
                                initVideo.pause();
                            }
                        }
                    }*/

                    seconds = initVideo.getCurrentTime();
                    CC.print("播放时间：" + seconds);
                }
                else {
                    isDrag = true; //可以拖动
                }
            }
            //判断是否播放结束
            if (initVideo.isEnded()) {
                if ($scope.userInfo != null && $scope.curriculum.type != 0) {
                    if ($scope.video.videoStatus == null || $scope.video.videoStatus.status == 0 || $scope.video.videoStatus.status == 1) {
                        var result = $scope.addVideoStatus($scope.video.id, 2, seconds);
                        $timeout(function () { //重新请求刷新状态
                            $scope.getCurriculum();
                            $scope.screenVideoList();
                        });
                        //有模拟 -- 表示看完 -- 暂无用
                        /*if (result.isShowExercises == 1 && result.isSimulationExercise == 1) {
                            mui('#pictureSimulate').popover('toggle');
                        }*/
                        if (result.isShowNote == 1) {
                            mui('#picturePass').popover('toggle');
                        }
                        //有练习题
                        else if (result.isShowExercises == 1) {
                            mui('#pictureExercise').popover('toggle');
                        }
                        else {
                            //此处播放下一个
                            $scope.videoIndex ++;
                            if ($scope.videoIndex < $scope.videoList.length) {
                                $scope.clickVideo($scope.videoList[$scope.videoIndex], $scope.videoIndex, true);
                            }
                        }
                    }
                    else {
                        //此处播放下一个
                        $scope.videoIndex ++;
                        if ($scope.videoIndex < $scope.videoList.length) {
                            $scope.clickVideo($scope.videoList[$scope.videoIndex], $scope.videoIndex, true);
                        }
                    }
                }
                else {
                    //此处播放下一个
                    $scope.videoIndex ++;
                    if ($scope.videoIndex < $scope.videoList.length) {
                        $scope.clickVideo($scope.videoList[$scope.videoIndex], $scope.videoIndex, true);
                    }
                }
            }
        });

        /** 获取人脸识别记录 **/
        $scope.getFace = function () {
            var faceSize = 0;
            CC.ajaxRequestData("post", false, "faceRecord/queryFaceRecord", { videoId : $scope.video.id, orderId : orderId }, function (result) {
                faceSize = result.data.length;
            });
            return faceSize;
        }

        /** 新增 播放记录 */
        $scope.addVideoStatus = function (videoId, status, second) {
            var parameter = {
                videoId : videoId,
                status : status,
                seconds : second,
                orderId : orderId
            }
            var data = null;
            if ($scope.userInfo != null) {
                CC.ajaxRequestData("post", false, "videoStatus/addVideoStatus", parameter, function (result) {
                    data = result.data;
                });
            }
            return data;
        }

        /** 弹窗点击播放下一个 **/
        $scope.nextVideo = function () {
            $scope.videoIndex ++;
            if ($scope.videoIndex < $scope.videoList.length) {
                $scope.clickVideo($scope.videoList[$scope.videoIndex], $scope.videoIndex, true);
            }
            else {
                mui.toast("已经看完全部视频.");
            }
            mui('#pictureExercise').popover('toggle');
        }

        /** 去练习或者模拟 **/
        $scope.startEvaluation = function (examType) {
            if (examType == 0) {
                location.href = CC.ip + "page/exerciseBank";
            }
            else if (examType == 1){
                location.href = CC.ip + "page/simulationBank";
            }
        }

        /** 确认人脸对比 **/
        $scope.affirmFace = function () {
            $("#File").click();
            $("#faceShade").fadeOut(100);
        }

        /** 取消人脸对比 **/
        $scope.cancelFace = function () {
            $scope.addVideoStatus($scope.video.id, 1, seconds);
            $("#faceShade").fadeOut(100);
        }

        /**通过考核--没有题的情况**/
        $scope.picturePass = function () {
            mui('#picturePass').popover('toggle');
        }

        /** 评论 **/
        $scope.comment = function () {
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
            if ($scope.content == "") {
                mui.toast("请输入评论内容.");
                return false;
            }
            var parameter = {
                content : $scope.content,
                curriculumId : curriculumId
            }
            CC.ajaxRequestData("post", false, "evaluate/addEvaluate", parameter, function (result) {
                mui.toast("发表成功.");
                $scope.avatar = $scope.userInfo.avatar == null ? CC.ip + "resources/img/my/11.png" : CC.ipImg + $scope.userInfo.avatar;
                var html = '<li class="mui-table-view-cell mui-media">' +
                        '<i class="mui-media-object mui-pull-left head" style="background: url(' + $scope.avatar + ');"></i>' +
                        '<div class="mui-media-body">' +
                        '<p class="mui-ellipsis">' + $scope.userInfo.showName + '</p>' +
                        '<p class="mui-ellipsis comment-time">1分钟前</p>' +
                        '<div class="comment-context">' + $scope.content + '</div>' +
                        '</div>' +
                        '</li>';
                var lis = $("#commentList").find("li");
                if (lis.length == 0) {
                    $("#commentList").html(html);
                }
                else {
                    $("#commentList li").eq(0).before(html);
                }
                $scope.content = "";
            });
        }

        /** 人脸采集/上传营业执照 **/
        $('#File').change(function(event){
            $("body").append(CC.showShade("正在识别,请稍等..."));
            if ($('#File').val() == null || $('#File').val() == "") {
                return false;
            }
            var file = this.files[0];
            if (!/image\/\w+/.test(file.type)) {
                mui.alert("只能是图片");
                return false;
            }
            //人脸采集
            //判断ios旋转代码
            var Orientation = null;
            //获取照片方向角属性，用户旋转控制
            EXIF.getData(file, function() {
                EXIF.getAllTags(this);
                Orientation = EXIF.getTag(this, 'Orientation');
            });
            var oReader = new FileReader();
            oReader.onload = function(e) {
                var image = new Image();
                image.src = e.target.result;
                image.onload = function() {
                    var expectWidth = this.naturalWidth;
                    var expectHeight = this.naturalHeight;
                    if (this.naturalWidth > this.naturalHeight && this.naturalWidth > 800) {
                        expectWidth = 800;
                        expectHeight = expectWidth * this.naturalHeight / this.naturalWidth;
                    } else if (this.naturalHeight > this.naturalWidth && this.naturalHeight > 1200) {
                        expectHeight = 1200;
                        expectWidth = expectHeight * this.naturalWidth / this.naturalHeight;
                    }
                    var canvas = document.createElement("canvas");
                    var ctx = canvas.getContext("2d");
                    var width = image.width;
                    var height = image.height;
                    // 按比例压缩4倍
                    var rate = (width < height ? width / height : height / width) / 4;
                    canvas.width = width * rate;
                    canvas.height = height * rate;
                    ctx.drawImage(image, 0, 0, width, height, 0, 0, width * rate, height * rate);
                    //canvas.width = expectWidth;
                    //canvas.height = expectHeight;
                    //ctx.drawImage(this, 0, 0, expectWidth, expectHeight);
                    var base64 = null;
                    //修复ios
                    if (navigator.userAgent.match(/iphone/i)) {
                        CC.print('iphone');
                        //alert(expectWidth + ',' + expectHeight);
                        //如果方向角不为1，都需要进行旋转 added by lzk
                        if(Orientation != "" && Orientation != 1){
                            //alert('旋转处理');
                            switch(Orientation){
                                case 6://需要顺时针（向左）90度旋转
                                    //alert('需要顺时针（向左）90度旋转');
                                    CC.rotateImg(this,'left',canvas);
                                    break;
                                case 8://需要逆时针（向右）90度旋转
                                    //alert('需要顺时针（向右）90度旋转');
                                    CC.rotateImg(this,'right',canvas);
                                    break;
                                case 3://需要180度旋转
                                    //alert('需要180度旋转');
                                    CC.rotateImg(this,'right',canvas);//转两次
                                    CC.rotateImg(this,'right',canvas);
                                    break;
                            }
                        }
                        base64 = canvas.toDataURL("image/jpeg", 0.8);
                    }else if (navigator.userAgent.match(/Android/i)) {// 修复android
                        base64 = canvas.toDataURL("image/jpeg", 0.8);
                    }else{
                        //alert(Orientation);
                        if(Orientation != "" && Orientation != 1){
                            //alert('旋转处理');
                            switch(Orientation){
                                case 6://需要顺时针（向左）90度旋转
                                    //alert('需要顺时针（向左）90度旋转');
                                    CC.rotateImg(this,'left',canvas);
                                    break;
                                case 8://需要逆时针（向右）90度旋转
                                    //alert('需要顺时针（向右）90度旋转');
                                    CC.rotateImg(this,'right',canvas);
                                    break;
                                case 3://需要180度旋转
                                    //alert('需要180度旋转');
                                    CC.rotateImg(this,'right',canvas);//转两次
                                    CC.rotateImg(this,'right',canvas);
                                    break;
                            }
                        }
                        base64 = canvas.toDataURL("image/jpeg", 0.8);
                    }
                    $scope.checkFace(base64.split(",")[1], base64);
                };
            };
            oReader.readAsDataURL(file);
            event.preventDefault();
        });

        /** 对比人脸 **/
        $scope.checkFace = function (result, base64Img) {
            $scope.isFirstTwo = false;
            var u = navigator.userAgent;
            var isAndroid = u.indexOf('Android') > -1 || u.indexOf('Adr') > -1; //判断是否是安卓
            $.ajax({
                type: "POST",
                url: "http://api.eyekey.com/face/Check/checking",
                data: {
                    app_id: CC.eyeKeyAppId,
                    app_key: CC.eyeKeyAppKey,
                    img: result,
                },
                success: function (json) {
                    json = JSON.parse(json);
                    CC.print(json);
                    if (json.res_code == "0000") {
                        var parameter = {
                            app_id : CC.eyeKeyAppId,
                            app_key : CC.eyeKeyAppKey,
                            face_id1 : $scope.userInfo.faceId,
                            face_id2 : json.face[0].face_id
                        }
                        CC.print(parameter);
                        $.ajax({
                            type : "GET",
                            url : "http://api.eyekey.com/face/Match/match_compare",
                            data : parameter,
                            success : function (result) {
                                result = JSON.parse(result);
                                CC.print(result);
                                if (Number(result.similarity) >= 80) {
                                    $.ajax({
                                        type: "POST",
                                        url : CC.ipImg + 'res/uploadBase64',
                                        data : {
                                            base64 : base64Img
                                        },
                                        success : function (data) {
                                            CC.print(data);
                                            if (data.code == 200) {
                                                parameter = {
                                                    videoId : $scope.video.id,
                                                    status : 1,
                                                    videoSecond : seconds,
                                                    orderId : orderId,
                                                    faceImage : data.data.url
                                                }
                                                CC.ajaxRequestData("post", false, "faceRecord/addRecord", parameter, function (result) {
                                                    //验证成功后重新获取识别次数
                                                    CC.ajaxRequestData("post", false, "faceRecord/queryFaceRecord", { videoId : $scope.video.id, orderId : orderId }, function (result) {
                                                        $scope.faceSize = result.data.length;
                                                    });
                                                    $scope.isFace = false; //成功之后表示人脸识别成功
                                                    initVideo.play(); //上传成功继续播放
                                                    $('#File').val("");
                                                    CC.hideShade();
                                                });
                                            } else {
                                                CC.hideShade();
                                                $('#File').val("");
                                                if (!isAndroid) {
                                                    mui.alert(json.msg);
                                                }
                                                else {
                                                    alert(json.msg);
                                                }
                                            }
                                        }
                                    });
                                }
                                else {
                                    CC.hideShade();
                                    $('#File').val("");
                                    if (!isAndroid) {
                                        mui.alert("人脸识别失败，请重试.", "", function () {
                                            $("#faceShade").fadeIn(100);
                                        });
                                    }
                                    else {
                                        alert("人脸识别失败，请重试.");
                                    }
                                }
                            }
                        });
                    }
                    else if(json.res_code == "1067"){
                        CC.hideShade();
                        $('#File').val("");
                        if (!isAndroid) {
                            mui.alert(json.message);
                        }
                        else {
                            alert(json.message);
                        }
                    }
                    else{
                        CC.hideShade();
                        $('#File').val("");
                        if (!isAndroid) {
                            mui.alert(json.message);
                        }
                        else {
                            alert(json.message);
                        }
                    }
                }
            });
        }

    });
    //富文本过滤器
    webApp.filter('trustHtml', ['$sce',function($sce) {
        return function(val) {
            return $sce.trustAsHtml(val);
        };
    }])

    var $commentBar = $(".comment-bar"); //评论栏对象
    (function($) {
        document.getElementById('slider').addEventListener('slide', function(e) {
            if (e.detail.slideNumber == 0) { $commentBar.hide(); }
            else if (e.detail.slideNumber == 1) { $commentBar.hide(); }
            else if (e.detail.slideNumber == 2) { $commentBar.hide(); }
            else if (e.detail.slideNumber == 3) { $commentBar.show(); }
        });
    })(mui);
    mui.previewImage();//开启图片预览
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
    //可滚动
    mui('#introduce').pullRefresh({
        container: '#introduce',
    });
    mui('#handouts').pullRefresh({
        container: '#handouts',
    });
    mui('#catalogue').pullRefresh({
        container: '#catalogue',
    });

    var pageNo1 = 1;
    var allHtml = getDataList(1, 10);
    if (allHtml == "") $("#pullrefreshComment .not-data").show();
    else $("#commentList").html(allHtml);
    //评论上拉
    function pullrefreshComment() {
        var html = getDataList(++pageNo1, 10);
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
        for (var i = 10; i > dataList.length; i--) {

        }
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

    $(function() {
        var height = document.body.clientHeight;
        $(".mui-slider-item").css("minHeight", (height - 260) + "px");
    });

    //进入全屏状态 -- 解决微信视频播放问题
    $('#video').on('x5videoenterfullscreen', function() {
        //alert("全屏");
        //延时修改video尺寸以占满全屏
        setTimeout(function() {
            $('video').css({
                height: (window.innerHeight) + 'px',
            });
            $(".mui-slider-item").css("minHeight", (document.body.clientHeight - 240) + "px");
        }, 200);
    });

    //退出全屏状态
    $('#video').on('x5videoexitfullscreen', function() {
        //alert("退出");
        //清除
        $(this).css({
            width: '',
            height: '',
        });
        initVideo.pause();
    });


</script>

</body>
</html>
