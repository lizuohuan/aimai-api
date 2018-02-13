
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>忘记密码</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/login/registerPhone.css">
</head>
<body ng-app="webApp" ng-controller="settingPhoneController" ng-cloak>

<div class="mui-content">
    <form class="mui-input-group">
        <div class="mui-input-row">
            <input id='phone' type="text" class="mui-input-clear mui-input" placeholder="输入您的手机号" maxlength="11" onKeypress="return (/[\d.]/.test(String.fromCharCode(event.keyCode)))">
        </div>
        <div class="mui-input-row">
            <input id='qr' type="text" class="mui-input" placeholder="输入验证码" maxlength="4" onKeypress="return (/[\d.]/.test(String.fromCharCode(event.keyCode)))">
            <button type="button" class="mui-btn qr-btn" ng-click="sendCode()">
                获取验证码
            </button>
        </div>
    </form>
    <div class="mui-content-padded">
        <button class="mui-btn mui-btn-block" ng-click="nextStep()">下一步</button>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script>
    var webApp = angular.module('webApp', []);
    webApp.controller('settingPhoneController', function($scope, $http, $timeout) {
        $scope.phone = null; //存放获取验证码手机号码--以免手机号被篡改
        $scope.isPhone = false; //存放手机号是否存在状态
        $scope.qrCode = "";

        //下一步
        $scope.nextStep = function() {
            var $phone = $('#phone').val();
            var $qr = $('#qr').val();
            if($phone == '') {
                mui.toast("手机号不能为空.");
                return false;
            } else if(!CC.isMobile.test($phone)) {
                mui.toast("请输入一个正确的手机号.");
                return false;
            } else if($scope.qrCode == "") {
                mui.toast("请获取验证码.");
                return false;
            } else if($qr == "") {
                mui.toast("验证码不能为空.");
                return false;
            } else if($scope.qrCode != $qr) {
                mui.toast("验证码错误，请重新输入.");
                return false;
            } else if($scope.phone != $phone) {
                mui.toast("您的手机号与验证码不匹配.");
                return false;
            }

            //验证手机号是否存在
            if($scope.isPhone) {
                location.href = CC.ip + "page/settingUpdatePassword?type=0&phone=" + $scope.phone;
            } else {
                mui.alert("手机号错误.");
            }

        }

        //获取验证码
        $scope.sendCode = function() {
            var $phone = $('#phone').val();
            if($phone == '') {
                mui.toast('手机号不能为空.');
                return false;
            } else if(!CC.isMobile.test($phone)) {
                mui.toast("请输入一个正确的手机号.");
                return false;
            }
            $(".qr-btn").attr("disabled", true);
            $scope.phone = $phone;
            $.ajax({
                type: "POST",
                url: CC.ip + "user/sendMessageForgetPwd",
                data: {
                    phone: $phone
                },
                success: function(result) {
                    if(result.flag == 0 && result.code == 200) {
                        var count = 60;
                        var resend;
                        resend = setInterval(function() {
                            count--;
                            if(count > 0) {
                                //console.log(count);
                                $(".qr-btn").html(count + '秒后可重新获取').attr('disabled', true).css('cursor', 'not-allowed');
                            } else {
                                clearInterval(resend);
                                $(".qr-btn").html("获取验证码").removeClass('disabled').removeAttr('disabled style');
                            }
                        }, 1000);
                        $scope.qrCode = result.data;
                        if (CC.isDebug) {
                            mui.toast("验证码:" + result.data);
                        }
                        $scope.isPhone = true;
                    } else {
                        $(".qr-btn").html("获取验证码").removeClass('disabled').removeAttr('disabled style');
                        mui.alert(result.msg);
                    }
                }
            });
        }
    });
</script>
</body>
</html>
