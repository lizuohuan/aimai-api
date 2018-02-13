
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>添加同事</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/my/personInfo.css">
</head>
<body ng-app="webApp" ng-controller="personController" ng-cloak>

<div class="mui-content">
    <form class="mui-input-group" id="formData">
        <div class="mui-input-row" onclick="$('#fileBtn').click()">
            <label>头像</label>
            <i class="head" ng-if="user.avatar == null" style="background: url('<%=request.getContextPath()%>/resources/img/my/11.png') 100%"></i>
            <i class="head" ng-if="user.avatar != null" style="background: url('{{imgUrl}}{{user.avatar}}') 100%"></i>
        </div>
        <div class="mui-input-row">
            <label>姓名</label>
            <input type="text" class="mui-input-clear mui-input" placeholder="请输入您的姓名" name="showName" value="{{user.showName}}">
        </div>
        <div class="mui-input-row">
            <label>部门</label>
            <input type="text" name="departmentName" class="mui-input" placeholder="请添加该同事的部门">
        </div>
        <div class="mui-input-row">
            <label>职位</label>
            <input type="text" name="jobTitle" class="mui-input" placeholder="请添加该同事的职位">
        </div>
        <input type="hidden" name="avatar" value="{{userInfo.avatar}}">
    </form>
    <div class="mui-content-padded">
        <button class="mui-btn mui-btn-block bg-color" ng-click="accomplish()">完成 </button>
    </div>
</div>

<form id="uploadImg" method="post" enctype="multipart/form-data">
    <div class="imgUpload">
        <input id="fileBtn" type="file" name="file" accept="image/*" class="hide">
    </div>
    <!--后台需要的参数-->
    <input type="hidden" name="type" value="1">
</form>

<div class="shade-hint">
    <div class="shade-bg">
        <img src="<%=request.getContextPath()%>/resources/img/study/18.png">
        <span>添加成功</span>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script src="<%=request.getContextPath()%>/resources/js/jquery.form.js" type="text/javascript" charset="UTF-8"></script>

<script>

    CC.reload(); //刷新一下上一页传回来的东西

    var webApp = angular.module('webApp', []);
    webApp.controller('personController', function($scope, $http, $timeout) {
        $scope.imgUrl = CC.ipImg; //获取图片服务器IP
        $scope.userId = CC.getUrlParam("userId");
        $scope.pageType = CC.getUrlParam("pageType");
        $scope.user = null;
        //员工课程详情
        CC.ajaxRequestData("post", false, "user/queryUserDetail", {userId : $scope.userId}, function (result) {
            $scope.user = result.data;
        });

        //提交
        $scope.accomplish = function () {
            var data = {};
            $("#formData").serializeArray().map(function(x){
                if (data[x.name] !== undefined) {
                    if (!data[x.name].push) {
                        data[x.name] = [data[x.name]];
                    }
                    data[x.name].push(x.value || '');
                } else {
                    data[x.name] = x.value || '';
                }
            });

            if (data.showName == "") {
                mui.toast("请输入姓名.");
                return false;
            }
            if (CC.isEmoji.test(data.showName)) {
                mui.toast("姓名不支持Emoji表情.");
                return false;
            }
            if (data.departmentName == "") {
                mui.toast("请添加该同事的部门.");
                return false;
            }
            if (CC.isEmoji.test(data.departmentName)) {
                mui.toast("部门不支持Emoji表情.");
                return false;
            }
            if (data.jobTitle == "") {
                mui.toast("请添加该同事的部门.");
                return false;
            }
            if (CC.isEmoji.test(data.jobTitle)) {
                mui.toast("职位不支持Emoji表情.");
                return false;
            }
            data.userId = $scope.userId;
            CC.ajaxRequestData("post", false, "user/addColleague", data, function () {
                $(".shade-hint").show();
                setTimeout(function () {
                    if ($scope.pageType == 0) {
                        history.back();
                    }
                    else {
                        history.go(-2);
                    }
                }, 1000);
            });
        }
    });

    //头像
    $('#fileBtn').change(function(){
        $("body").append(CC.showShade("正在上传,请稍等..."));
        if ($('#fileBtn').val() == null || $('#fileBtn').val() == "") {
            return false;
        }
        var file = this.files[0];
        //判断是否是图片类型
        if (!/image\/\w+/.test(file.type)) {
            mui.toast("只能选择图片");
            return false;
        }
        var fr = new FileReader();
        if(window.FileReader) {
            fr.onloadend = function(e) {
                $("#uploadImg").ajaxSubmit({
                    type: "POST",
                    url:CC.ipImg + 'res/upload',
                    success: function(json) {
                        CC.print(json);
                        if (json.code == 200) {
                            CC.hideShade();
                            $(".head").attr("src", CC.ipImg + json.data.url);
                            $("input[name='avatar']").val(json.data.url);
                        } else {
                            mui.toast(json.msg);
                            CC.hideShade();
                        }
                    }
                });
            };
            fr.readAsDataURL(file);
        }
    });
</script>

</body>
</html>
