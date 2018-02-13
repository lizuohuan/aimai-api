
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>个人信息</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/my/personInfo.css">
</head>
<body ng-app="webApp" ng-controller="personController" ng-cloak>

<div class="mui-content">
    <form class="mui-input-group" id="formData">
        <div class="mui-input-row">
            <label ng-if="userInfo.roleId == 4">姓名</label>
            <label ng-if="userInfo.roleId == 3">企业名称</label>
            <label ng-if="userInfo.roleId == 2">机构名称</label>
            <input ng-if="userInfo.roleId == 4" type="text" class="mui-input-clear mui-input" placeholder="请输入您的姓名" name="showName" value="{{userInfo.showName}}">
            <input ng-if="userInfo.roleId == 3" type="text" class="mui-input-clear mui-input" placeholder="请输入企业名称" name="showName" value="{{userInfo.showName}}">
            <input ng-if="userInfo.roleId == 2" type="text" class="mui-input-clear mui-input" placeholder="请输入机构名称" name="showName" value="{{userInfo.showName}}">
        </div>
        <div class="mui-input-row" onclick="$('#fileBtn').click()">
            <label>头像</label>
            <i class="head" ng-if="userInfo.avatar == null" style="background: url('<%=request.getContextPath()%>/resources/img/my/11.png') 100%"></i>
            <i class="head" ng-if="userInfo.avatar != null" style="background: url('{{imgUrl}}{{userInfo.avatar}}') 100%"></i>
        </div>
        <%--<div class="mui-input-row" onclick="$('#fileBtn').click()" ng-if="userInfo.roleId == 3">
            <label>营业执照</label>
            <img class="head" ng-if="userInfo.avatar == null" src="<%=request.getContextPath()%>/resources/img/my/11.png" />
            <img class="head" ng-if="userInfo.avatar != null" src="{{imgUrl}}{{userInfo.avatar}}" />
        </div>--%>
        <div class="mui-input-row">
            <label>电话</label>
            <input type="text" class="mui-input" placeholder="请输入您的电话" value="{{userInfo.phone}}" readonly>
        </div>
        <div class="mui-input-row">
            <a class="mui-navigate-right" href="<%=request.getContextPath()%>/page/address?roleId={{userInfo.roleId}}">
                <label>所在地</label>
                <input type="text" class="mui-input" ng-if="selectAddress != null" value="{{selectAddress.mergerName}}" placeholder="请选择您的所在地" readonly>
                <input type="text" class="mui-input" ng-if="selectAddress == null" value="{{userInfo.city.mergerName}}" placeholder="请选择您的所在地" readonly>
            </a>
        </div>
        <div class="mui-input-row" ng-if="userInfo.roleId == 3">
            <label>行业</label>
            <input type="text" class="mui-input" placeholder="暂无" readonly>
        </div>
        <div class="mui-input-row" ng-if="userInfo.roleId == 4">
            <label>所属公司</label>
            <input type="text" class="mui-input" placeholder="{{userInfo.companyName == null ? '暂无' : userInfo.companyName}}" readonly>
        </div>
        <div class="mui-input-row" ng-if="userInfo.roleId == 4">
            <label>所在部门</label>
            <input type="text" class="mui-input" placeholder="{{userInfo.departmentName == null ? '暂无' : userInfo.departmentName}}" readonly>
        </div>
        <div class="mui-input-row" ng-if="userInfo.roleId == 4">
            <label>职位</label>
            <input type="text" class="mui-input" placeholder="{{userInfo.jobTitle == null ? '暂无' : userInfo.jobTitle}}" readonly value="">
        </div>
        <div class="mui-input-row">
            <label ng-if="userInfo.roleId == 4">身份证号</label>
            <label ng-if="userInfo.roleId == 3">营业执照编码</label>
            <label ng-if="userInfo.roleId == 2">机构代码</label>
            <input type="text" class="mui-input" placeholder="请输入您的身份证号" readonly value="{{userInfo.pid}}">
        </div>
        <div class="mui-input-row" style="padding: 10px 0;height: inherit !important;" ng-show="userInfo.roleId == 3 || userInfo.roleId == 2">
            <label ng-if="userInfo.roleId == 3">营业执照</label>
            <label ng-if="userInfo.roleId == 2">介绍信</label>
            <div class="preview">
                <img src="{{imgUrl}}{{userInfo.licenseFile}}"/>
            </div>
        </div>
        <div class="mui-input-row">
            <label>介绍</label>
            <input type="text" class="mui-input-clear mui-input" placeholder="请输入介绍" name="introduce" value="{{userInfo.introduce}}" maxlength="200">
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

<%@include file="../common/js.jsp" %>
<script src="<%=request.getContextPath()%>/resources/js/jquery.form.js" type="text/javascript" charset="UTF-8"></script>

<script>

    CC.reload(); //刷新一下上一页传回来的东西

    var webApp = angular.module('webApp', []);
    webApp.controller('personController', function($scope, $http, $timeout) {
        $scope.userInfo = CC.getUserInfo(); //登录人信息
        $scope.imgUrl = CC.ipImg; //获取图片服务器IP
        $scope.selectAddress = JSON.parse(sessionStorage.getItem("selectAddress")); //获取已选择的地址
        console.log($scope.selectAddress);
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
            if (CC.isEmoji.test(data.introduce)) {
                mui.toast("介绍不支持Emoji表情.");
                return false;
            }
            if ($scope.selectAddress != null) {
                data.cityId = $scope.selectAddress.cityId;
            }

            CC.ajaxRequestData("post", false, "user/updateUser", data, function () {
                CC.ajaxRequestData("post", false, "user/getInfo", null, function (result) {
                    localStorage.setItem("userInfo", JSON.stringify(result.data));
                    sessionStorage.removeItem("selectAddress");
                    window.history.back();
                });
            });
        }
    });

    //人脸采集/上传营业执照
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
                uploadingImg(base64);
            };
        };
        oReader.readAsDataURL(file);

    });

    /** 上传头像 **/
    function uploadingImg (base64) {
        $.ajax({
            type: "POST",
            url: CC.ipImg + 'res/uploadBase64',
            data: { base64: base64 },
            success: function (data) {
                CC.print(data);
                if (data.code == 200) {
                    $('#File').val("");
                    CC.hideShade();
                    $(".head").css("background", "url(" + CC.ipImg + data.data.url + ")");
                    $("input[name='avatar']").val(data.data.url);
                }
                else {
                    mui.toast(data.msg);
                    CC.hideShade();
                }
            }
        });
    }
</script>

</body>
</html>
