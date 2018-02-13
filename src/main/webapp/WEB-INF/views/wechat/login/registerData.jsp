
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>个人信息</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/login/registerData.css">
    <script src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>
</head>
<body ng-app="webApp" ng-controller="registerDataController" ng-cloak>

<!-- 个人注册信息 -->
<div class="mui-content" id="personData" ng-show="registerInfo.registerType == 0">
    <form class="mui-input-group" id="formPerson">
        <div class="mui-input-row">
            <label>姓名</label>
            <input type="text" name="showName" class="mui-input-clear mui-input" placeholder="请输入您的姓名" maxlength="20">
        </div>
        <div class="mui-input-row">
            <label>身份证号</label>
            <input type="text" name="pid" class="mui-input-clear mui-input" placeholder="请输入您的身份证号" maxlength="20">
        </div>
        <div class="mui-input-row">
            <a class="mui-navigate-right" ng-click="address()">
                <label>所在地</label>
                <input type="text" class="mui-input" value="{{selectAddress.mergerName}}" placeholder="请输入您的所在地" maxlength="50" readonly>
            </a>
        </div>
        <div class="mui-input-row" onclick="photograph()">
            <a class="mui-navigate-right">
                <label>人像采集</label>
                <img class="camera-icon" src="<%=request.getContextPath()%>/resources/img/login/4.png">
            </a>
        </div>
        <input name="cityId" type="hidden" value="{{selectAddress.cityId}}">
        <input name="veriFaceImages" type="hidden">
        <input name="faceId" type="hidden">

    </form>
    <div class="hint">实名采集用于您观看视频时进行头像验证,所以必须采集。</div>
    <div class="mui-content-padded">
        <button class="mui-btn mui-btn-block" ng-click="confirm()">提交个人资料</button>
    </div>
</div>

<!-- 企业注册信息 -->
<div class="mui-content" id="personData" ng-show="registerInfo.registerType == 1">
    <form class="mui-input-group" id="formCompany">
        <div class="mui-input-row">
            <label>企业名称</label>
            <input type="text" name="showName1" class="mui-input-clear mui-input" placeholder="请输入企业名称" maxlength="50">
        </div>
        <div class="mui-input-row">
            <label>营业执照编号</label>
            <input type="text" name="pid1" class="mui-input-clear mui-input" placeholder="请输入营业执照编号" maxlength="20">
        </div>
        <div class="mui-input-row">
            <a class="mui-navigate-right" ng-click="tradeList()">
                <label>行业</label>
                <input type="text" class="mui-input" value="{{tradeInfo.tradeName}}" placeholder="请选择所属行业" readonly>
            </a>
        </div>
        <div class="mui-input-row">
            <a class="mui-navigate-right" ng-click="address()">
                <label>所在地</label>
                <input type="text" class="mui-input" value="{{selectAddress.mergerName}}" placeholder="请选择您的所在地" maxlength="50" readonly>
            </a>
        </div>
        <div class="mui-input-row" onclick="photograph()">
            <a class="mui-navigate-right">
                <label>上传营业执照</label>
                <img class="camera-icon" src="<%=request.getContextPath()%>/resources/img/login/5.png">
            </a>
        </div>
        <input name="cityId" type="hidden" value="{{selectAddress.cityId}}">
        <input name="tradeId" type="hidden" value="{{tradeInfo.tradeId}}">
        <input name="licenseFile" type="hidden">
    </form>
    <div class="mui-content-padded">
        <button class="mui-btn mui-btn-block bg-color" ng-click="confirm()">提交资料</button>
    </div>
</div>

<!-- 政府注册信息 -->
<div class="mui-content" id="personData" ng-show="registerInfo.registerType == 2">
    <form class="mui-input-group" id="formGovernment">
        <div class="mui-input-row">
            <label>机构名称</label>
            <input type="text" name="showName2" class="mui-input-clear mui-input" placeholder="请输入机构名称" maxlength="50">
        </div>
        <div class="mui-input-row">
            <label>机构代码</label>
            <input type="text" name="pid2" class="mui-input-clear mui-input" placeholder="请输入机构代码" maxlength="20">
        </div>
        <div class="mui-input-row">
            <a class="mui-navigate-right" ng-click="address()">
                <label>所在地</label>
                <input type="text" class="mui-input" value="{{selectAddress.mergerName}}" placeholder="请输入您的所在地" maxlength="50" readonly>
            </a>
        </div>
        <div class="mui-input-row" onclick="photograph()">
            <a class="mui-navigate-right">
                <label>上传单位介绍信</label>
                <img class="camera-icon" src="<%=request.getContextPath()%>/resources/img/login/5.png">
            </a>
        </div>
        <input name="cityId" type="hidden" value="{{selectAddress.cityId}}">
        <input name="licenseFile" type="hidden">
    </form>
    <div class="mui-content-padded">
        <button class="mui-btn mui-btn-block bg-color" ng-click="confirm()">提交资料</button>
    </div>
</div>

<input id="File" type="file" name="File" accept="image/*" capture="camera" class="hide">

<%@include file="../common/js.jsp" %>

<script>
    CC.reload(); //刷新一下上一页传回来的东西
    var type = 0;
    var webApp = angular.module('webApp', []);
    webApp.controller('registerDataController', function($scope, $http, $timeout) {
        $scope.registerInfo = JSON.parse(localStorage.getItem("registerInfo")); //获取上级页面的信息
        $scope.selectAddress = JSON.parse(sessionStorage.getItem("selectAddress")); //获取已选择的地址
        if ($scope.selectAddress != null) $("input[name='cityId']").val($scope.selectAddress.cityId);
        $scope.tradeInfo = JSON.parse(sessionStorage.getItem("tradeInfo")); //获取已选择的行业
        if ($scope.tradeInfo != null) $("input[name='tradeId']").val($scope.tradeInfo.tradeId);
        if (sessionStorage.getItem("veriFaceImages") != null){//获取缓存图片
            $(".camera-icon").attr("src", CC.ipImg + sessionStorage.getItem("veriFaceImages"));
            $("input[name='veriFaceImages']").val(sessionStorage.getItem("veriFaceImages"));
        }
        if (sessionStorage.getItem("licenseFile") != null){
            $(".camera-icon").attr("src", CC.ipImg + sessionStorage.getItem("licenseFile"));
            $("input[name='licenseFile']").val(sessionStorage.getItem("licenseFile"));
        }
        if (sessionStorage.getItem("faceId") != null){
            $("input[name='faceId']").val(sessionStorage.getItem("faceId"));
        }

        if ($scope.registerInfo.registerType == 0) {
            $("input[name='showName']").val(sessionStorage.getItem("showName"));
            $("input[name='pid']").val(sessionStorage.getItem("pid"));
        }
        else if ($scope.registerInfo.registerType == 1) {
            $("input[name='showName1']").val(sessionStorage.getItem("showName1"));
            $("input[name='pid1']").val(sessionStorage.getItem("pid1"));
        }
        else if ($scope.registerInfo.registerType == 2) {
            $("input[name='showName2']").val(sessionStorage.getItem("showName2"));
            $("input[name='pid2']").val(sessionStorage.getItem("pid2"));
        }

        //跳转地址
        $scope.address = function () {
            if ($scope.registerInfo.registerType == 0) {
                sessionStorage.setItem("showName", $("input[name='showName']").val());
                sessionStorage.setItem("pid", $("input[name='pid']").val());
                location.href = CC.ip + "page/address";
            }
            else if ($scope.registerInfo.registerType == 1) {
                sessionStorage.setItem("showName1", $("input[name='showName1']").val());
                sessionStorage.setItem("pid1", $("input[name='pid1']").val());
                location.href = CC.ip + "page/address";
            }
            else if ($scope.registerInfo.registerType == 2) {
                sessionStorage.setItem("showName2", $("input[name='showName2']").val());
                sessionStorage.setItem("pid2", $("input[name='pid2']").val());
                location.href = CC.ip + "page/address?roleId=2";
            }
        }
        //跳转行业
        $scope.tradeList = function () {
            location.href = CC.ip + "page/tradeList?tradeId=" + $scope.tradeInfo.tradeId;
        }

        type = $scope.registerInfo.registerType;
        //判断注册类型
        if (Number($scope.registerInfo.registerType) != 0) {
            $("#File").removeAttr("capture");
        }
        //提交资料
        $scope.confirm = function() {
            if ($scope.registerInfo.registerType == 0) $scope.roleId = 4;
            if ($scope.registerInfo.registerType == 1) $scope.roleId = 3;
            if ($scope.registerInfo.registerType == 2) $scope.roleId = 2;
            switch (Number($scope.registerInfo.registerType)) {
                case 0:
                    var $showName = $("input[name='showName']").val(); //展示名称 个人：姓名 政府：机构名称 企业：企业名称
                    var $pid = $("input[name='pid']").val(); //个人：身份证 政府：机构代码 企业：营业执照编码
                        var data = {};
                        $("#formPerson").serializeArray().map(function(x){
                            if (data[x.name] !== undefined) {
                                if (!data[x.name].push) {
                                    data[x.name] = [data[x.name]];
                                }
                                data[x.name].push(x.value || '');
                            } else {
                                data[x.name] = x.value || '';
                            }
                        });

                        if ($showName == "") {
                            mui.toast("请输入您的姓名.");
                            return false;
                        }
                        if (CC.isEmoji.test($showName)) {
                            mui.toast("姓名不支持Emoji表情.");
                            return false;
                        }
                        if ($pid == "") {
                            mui.toast("请输入您的身份证号.");
                            return false;
                        }
                        if (!CC.isIdentityCard.test($pid)) {
                            mui.toast("请输入正确的身份证号.");
                            return false;
                        }
                        if (data.cityId == "") {
                            mui.toast("请选择所在地.");
                            return false;
                        }
                        if (data.veriFaceImages == "") {
                            mui.toast("请上传人像采集.");
                            return false;
                        }
                        if (data.faceId == "") {
                            mui.toast("请上传人像采集.");
                            return false;
                        }
                        data.roleId = $scope.roleId;
                        data.phone = $scope.registerInfo.phone;
                        data.pwd = $scope.registerInfo.password;
                        CC.print(data);
                        CC.ajaxRequestData("post", false, "user/register", data, function (result) {
                            mui.alert("注册成功.", "", function () {
                                sessionStorage.removeItem("selectAddress");
                                sessionStorage.removeItem("tradeInfo");
                                sessionStorage.removeItem("veriFaceImages");
                                window.history.go(-3);
                            });
                        });
                    break;
                case 1:
                    var $showName = $("input[name='showName1']").val(); //展示名称 个人：姓名 政府：机构名称 企业：企业名称
                    var $pid = $("input[name='pid1']").val(); //个人：身份证 政府：机构代码 企业：营业执照编码
                    var data = {};
                    $("#formCompany").serializeArray().map(function(x){
                        if (data[x.name] !== undefined) {
                            if (!data[x.name].push) {
                                data[x.name] = [data[x.name]];
                            }
                            data[x.name].push(x.value || '');
                        } else {
                            data[x.name] = x.value || '';
                        }
                    });

                    if ($showName == "") {
                        mui.toast("请输入企业名称.");
                        return false;
                    }
                    if (CC.isEmoji.test($showName)) {
                        mui.toast("企业名称不支持Emoji表情.");
                        return false;
                    }
                    if ($pid == "") {
                        mui.toast("请输入营业执照编码.");
                        return false;
                    }
                    if (CC.isEmoji.test($pid)) {
                        mui.toast("营业执照编码不支持Emoji表情.");
                        return false;
                    }
                    if (data.cityId == "") {
                        mui.toast("请选择所在地.");
                        return false;
                    }
                    if (data.licenseFile == "") {
                        mui.toast("请上传营业执照.");
                        return false;
                    }
                    data.showName = $showName;
                    data.pid = $pid;
                    data.roleId = $scope.roleId;
                    data.phone = $scope.registerInfo.phone;
                    data.pwd = $scope.registerInfo.password;
                    CC.print(data);
                    CC.ajaxRequestData("post", false, "user/register", data, function (result) {
                        mui.alert("注册成功.", "", function () {
                            sessionStorage.removeItem("selectAddress");
                            sessionStorage.removeItem("licenseFile");
                            sessionStorage.removeItem("tradeInfo");
                            window.history.go(-3);
                        });
                    });
                    break;
                case 2:
                    var $showName = $("input[name='showName2']").val(); //展示名称 个人：姓名 政府：机构名称 企业：企业名称
                    var $pid = $("input[name='pid2']").val(); //个人：身份证 政府：机构代码 企业：营业执照编码
                    var data = {};
                    $("#formCompany").serializeArray().map(function(x){
                        if (data[x.name] !== undefined) {
                            if (!data[x.name].push) {
                                data[x.name] = [data[x.name]];
                            }
                            data[x.name].push(x.value || '');
                        } else {
                            data[x.name] = x.value || '';
                        }
                    });

                    if ($showName == "") {
                        mui.toast("请输入机构名称.");
                        return false;
                    }
                    if (CC.isEmoji.test($showName)) {
                        mui.toast("机构名称不支持Emoji表情.");
                        return false;
                    }
                    if ($pid == "") {
                        mui.toast("请输入机构代码.");
                        return false;
                    }
                    if (CC.isEmoji.test($pid)) {
                        mui.toast("机构代码不支持Emoji表情.");
                        return false;
                    }
                    if (data.cityId == "") {
                        mui.toast("请选择所在地.");
                        return false;
                    }
                    if (data.licenseFile == "") {
                        mui.toast("请上传单位介绍信.");
                        return false;
                    }
                    data.showName = $showName;
                    data.pid = $pid;
                    data.roleId = $scope.roleId;
                    data.phone = $scope.registerInfo.phone;
                    data.pwd = $scope.registerInfo.password;
                    CC.print(data);
                    CC.ajaxRequestData("post", false, "user/register", data, function (result) {
                        mui.alert("注册成功.", "", function () {
                            sessionStorage.removeItem("selectAddress");
                            sessionStorage.removeItem("tradeInfo");
                            sessionStorage.removeItem("licenseFile");
                            window.history.go(-3);
                        });
                    });
                    break;
            }

        }

    });

    //人脸采集/上传营业执照
    $('#File').change(function(event){
        $("body").append(CC.showShade("正在上传,请稍等..."));
        if ($('#File').val() == null || $('#File').val() == "") {
            return false;
        }
        var file = this.files[0];
        if (!/image\/\w+/.test(file.type)) {
            mui.alert("只能选择图片");
            return false;
        }
        var imageUrl = CC.getObjectURL($(this)[0].files[0]);
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
                //人脸采集
                if (type == 0) {
                    checkFace(base64.split(",")[1], base64);
                }else {
                    license(base64);
                }
            };
        };
        oReader.readAsDataURL(file);
        event.preventDefault();
    });

    /** 创建faceId **/
    function checkFace (base64, base64Img) {
        $.ajax({
            type: "POST",
            url: "http://api.eyekey.com/face/Check/checking",
            data: {
                app_id: CC.eyeKeyAppId,
                app_key: CC.eyeKeyAppKey,
                img: base64,
            },
            success: function (json) {
                json = JSON.parse(json);
                CC.print(json);
                if (json.res_code == "0000") {
                    $("input[name='faceId']").val(json.face[0].face_id);
                    $.ajax({
                        type: "POST",
                        url : CC.ipImg + 'res/uploadBase64',
                        data: { base64: base64Img },
                        success: function (data) {
                            CC.print(data);
                            if (data.code == 200) {
                                $('#File').val("");
                                CC.hideShade();
                                $(".camera-icon").attr("src", CC.ipImg + data.data.url);
                                $("input[name='veriFaceImages']").val(data.data.url);
                                sessionStorage.setItem("veriFaceImages", data.data.url);
                                sessionStorage.setItem("faceId", json.face[0].face_id);
                            }
                            else {
                                CC.hideShade();
                                $('#File').val("");
                                mui.toast(data.msg);
                            }
                        }
                    });
                }
                else if(json.res_code == "1067"){
                    CC.hideShade();
                    $('#File').val("");
                    mui.alert(json.message);
                }
                else{
                    CC.hideShade();
                    $('#File').val("");
                    mui.alert(json.message);
                }
            }
        });
    }

    /** 上传介绍信或者营业执照 **/
    function license (base64) {
        $.ajax({
            type: "POST",
            url: CC.ipImg + 'res/uploadBase64',
            data: { base64: base64 },
            success: function (data) {
                CC.print(data);
                if (data.code == 200) {
                    $('#File').val("");
                    CC.hideShade();
                    $(".camera-icon").attr("src", CC.ipImg + data.data.url);
                    $("input[name='licenseFile']").val(data.data.url);
                    sessionStorage.setItem("licenseFile", data.data.url);
                }
                else {
                    CC.hideShade();
                    $('#File').val("");
                    mui.toast(data.msg);
                }
            }
        });
    }

   /* //微信
    var jsSignList = CC.getWxJsSign();
    wx.config({
        debug: true, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
        appId: jsSignList.appId, // 必填，公众号的唯一标识
        timestamp: jsSignList.timestamp, // 必填，生成签名的时间戳
        nonceStr: jsSignList.noncestr, // 必填，生成签名的随机串
        signature: jsSignList.signature,// 必填，签名，见附录1
        jsApiList: ["chooseImage", "previewImage", "uploadImage"] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
    });*/

    //拍照
    function photograph () {

        $('#File').click();

        return false;

        wx.ready(function(){
            //微信拍照
            wx.chooseImage({
                count: 1, // 默认9
                sizeType: ['original', 'compressed'], // 可以指定是原图还是压缩图，默认二者都有
                sourceType: ['camera'], // 可以指定来源是相册还是相机，默认二者都有
                success: function (res) {
                    alert(res.localIds);
                    var localIds = res.localIds; // 返回选定照片的本地ID列表，localId可以作为img标签的src属性显示图片
                    if (localIds.length == 0) {
                        alert('请先使用 chooseImage 接口选择图片');
                        return;
                    }
                    $(".camera-icon").attr("src", localIds);
                    //上传图片接口
                    wx.uploadImage({
                        localId: localIds, // 需要上传的图片的本地ID，由chooseImage接口获得
                        isShowProgressTips: 1,// 默认为1，显示进度提示
                        success: function (res) {
                            var serverId = res.serverId; // 返回图片的服务器端ID
                            wx.downloadImage({
                                serverId: serverId, // 需要下载的图片的服务器端ID，由uploadImage接口获得
                                isShowProgressTips: 1, // 默认为1，显示进度提示
                                success: function (res) {
                                    var localId = res.localId; // 返回图片下载后的本地ID
                                }
                            });
                        }
                    });
                }
            });

        });
    }

</script>
</body>
</html>
