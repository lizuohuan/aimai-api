
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>课程</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/swiper.min.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/course/course.css">
</head>
<body ng-app="webApp" ng-controller="courseController">

<div class="mui-content">

    <div class="search-div">
        <div class="mui-input-row mui-search">
            <a class="search-input" href="<%=request.getContextPath()%>/page/searchCourseList">
                <span class="mui-icon mui-icon-search"></span>
                点击搜索相关课程
            </a>
        </div>
        <a href="<%=request.getContextPath()%>/page/searchCourseList" class="search-btn">搜索</a>
    </div>
    <div style="height: 54px;"></div>


    <div class="title">试听课程</div>
    <div class="not-data" ng-show="curriculumByAudition.length == 0">暂无试听课程.</div>
    <div class="swiper-container">
        <div class="swiper-wrapper" id="swiperWrapper">
            <div class="swiper-slide" ng-repeat="curriculum in curriculumByAudition">
                <div class="video-cover" ng-cloak>
                    <a href="<%=request.getContextPath()%>/page/courseVideo?curriculumId={{curriculum.id}}&isAudition=1">
                        <div class="cover-img" style="background: url('{{imgUrl}}{{curriculum.cover}}')"></div>
                    </a>
                </div>
                <div class="video-title" ng-cloak>
                    {{curriculum.curriculumName}}
                </div>
            </div>
        </div>
    </div>

    <div class="title course-title">推荐课程
        <a class="course-more" href="<%=request.getContextPath()%>/page/courseList?isRecommend=1">查看全部 <i class="fa fa-caret-right"></i></a>
    </div>
    <div class="not-data" ng-show="recommendCurriculumList.length == 0">暂无推荐课程.</div>
    <div class="mui-row">
        <div class="mui-col-xs-6" ng-repeat="curriculum in recommendCurriculumList" ng-cloak>
            <div ng-click="isBuy(curriculum.id)" class="course-cover" style="background: url('{{imgUrl}}{{curriculum.cover}}')"></div>
            <div class="video-title">
                {{curriculum.curriculumName}}
            </div>
            <div class="list-num">
						<span class="num-title">
                            <img src="<%=request.getContextPath()%>/resources/img/my/3.png" />
							<span class="num">{{curriculum.videoNum}}</span> 个视频课
						</span>
            </div>
            <div class="money">￥{{curriculum.price}}</div>
        </div>
    </div>

    <div ng-repeat="type in curriculumTypes" ng-cloak>
        <div class="title course-title">{{type.curriculumTypeName}}
            <a class="course-more" href="<%=request.getContextPath()%>/page/courseList?curriculumTypeId={{type.id}}">查看全部 <i class="fa fa-caret-right"></i></a>
        </div>
        <div class="not-data" ng-show="type.curriculumList.length == 0">暂无课程.</div>
        <div class="mui-row margin-bottom">
            <div class="mui-col-xs-6" ng-repeat="curriculum in type.curriculumList">
                <div ng-click="isBuy(curriculum.id)" class="course-cover" style="background: url('{{imgUrl}}{{curriculum.cover}}')"></div>
                <div class="video-title">
                    {{curriculum.curriculumName}}
                </div>
                <div class="list-num">
						<span class="num-title">
                            <img src="<%=request.getContextPath()%>/resources/img/my/3.png" />
							<span class="num">{{curriculum.videoNum}}</span> 个视频课
						</span>
                </div>
                <div class="money">￥{{curriculum.price}}</div>
            </div>
        </div>
    </div>
    <div style="height: 65px"></div>

</div>

<!--底部tab切换-->
<nav class="mui-bar mui-bar-tab tab-bottom" id="tabBottom">
    <a class="mui-tab-item" href="<%=request.getContextPath()%>/page/index">
        <div class="tab-icon"><img src="<%=request.getContextPath()%>/resources/img/tab/1.png"></div>
        <span class="mui-tab-label">首页</span>
    </a>
    <a class="mui-tab-item mui-active" href="javascript:void(0)">
        <div class="tab-icon"><img src="<%=request.getContextPath()%>/resources/img/tab/2-2.png"></div>
        <span class="mui-tab-label">课程</span>
    </a>
    <a class="mui-tab-item studyJurisdiction" href="<%=request.getContextPath()%>/page/study">
        <div class="tab-icon"><img src="<%=request.getContextPath()%>/resources/img/tab/3.png"></div>
        <span class="mui-tab-label">学习</span>
    </a>
    <a class="mui-tab-item" href="<%=request.getContextPath()%>/page/my">
        <div class="tab-icon"><img src="<%=request.getContextPath()%>/resources/img/tab/4.png"></div>
        <span class="mui-tab-label">我的</span>
    </a>
</nav>

<%@include file="../common/js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/swiper.min.js"></script>
<script>
    var swiper = new Swiper('.swiper-container', {
        slidesPerView: 'auto',
        paginationClickable: true,
        spaceBetween: 0,
        freeMode: true,
        observer:true,//修改swiper自己或子元素时，自动初始化swiper
        observeParents:true,//修改swiper的父元素时，自动初始化swiper
    });

    var webApp = angular.module('webApp', []);
    webApp.controller('courseController', function($scope, $http, $timeout) {
        $scope.userInfo = CC.getUserInfo(); //登录人信息
        $scope.imgUrl = CC.ipImg; //图片IP
        $scope.curriculumByAudition = null; //试听课程
        $scope.recommendCurriculumList = null; //推荐课程
        $scope.curriculumTypes = null; //类型课程
        var parameter = {
            pageNO : 1,
            pageSize : 2
        }
        CC.ajaxRequestData("post", false, "curriculum/queryCurriculumByItems", parameter, function (result) {
            $scope.curriculumByAudition = result.data.curriculumByAudition;
            $scope.recommendCurriculumList = result.data.recommendCurriculumList;
            $scope.curriculumTypes = result.data.curriculumTypes;
        });

        /**判断是否已经购买过了**/
        $scope.isBuy = function (id) {
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
    });

    mui('body').on('tap','a',function(){document.location.href=this.href;});

</script>

</body>
</html>
