
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>绑定邮箱</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/login/registerPhone.css">
</head>
<body ng-app="webApp" ng-controller="settingEmailController" ng-cloak>

<div class="mui-content">
    <form class="mui-input-group">
        <div class="mui-input-row">
            <input id='email' type="text" class="mui-input-clear mui-input" placeholder="输入您的邮箱" maxlength="30">
        </div>
        <div class="mui-input-row">
            <input id='qr' type="text" class="mui-input" placeholder="输入验证码" maxlength="4" onKeypress="return (/[\d.]/.test(String.fromCharCode(event.keyCode)))">
            <button type="button" class="mui-btn qr-btn" ng-click="sendCode()">
                获取验证码
            </button>
        </div>
    </form>
    <div class="mui-content-padded">
        <button class="mui-btn mui-btn-block" ng-click="confirm()">确定</button>
    </div>
</div>

<%@include file="../common/js.jsp" %>
<script>
    var webApp = angular.module('webApp', []);
    webApp.controller('settingEmailController', function($scope, $http, $timeout) {
        $scope.email = null;
        $scope.isEmail = false;
        $scope.qrCode = false;

        //完成
        $scope.confirm = function() {
            var $email = $('#email').val();
            var $qr = $('#qr').val();
            if($email == '') {
                mui.toast("邮箱不能为空.");
                return false;
            } else if(!CC.isEmail.test($email)) {
                mui.toast("请输入一个正确的邮箱.");
                return false;
            } else if(!$scope.qrCode) {
                mui.toast("请获取验证码.");
                return false;
            } else if($qr == "") {
                mui.toast("验证码不能为空.");
                return false;
            } else if($scope.email != $email) {
                mui.toast("您的邮箱与验证码不匹配.");
                return false;
            }

            //验证手机号是否存在
            if($scope.isEmail) {
                CC.ajaxRequestData("post", false, "user/updateEmail", {
                    email : $email,
                    code : $qr
                }, function () {
                    CC.ajaxRequestData("post", false, "user/getInfo", null, function (result) {
                        localStorage.setItem("userInfo", JSON.stringify(result.data));
                        window.history.back();
                    });
                });
            } else {
                mui.alert("邮箱错误.");
            }

        }

        //获取验证码
        $scope.sendCode = function() {
            var $email = $('#email').val();
            if($email == '') {
                mui.toast('邮箱不能为空.');
                return false;
            } else if(!CC.isEmail.test($email)) {
                mui.toast("请输入一个正确的邮箱.");
                return false;
            }
            $(".qr-btn").attr("disabled", true);
            $scope.email = $email;
            $.ajax({
                type: "POST",
                url: CC.ip + "user/sendEmailCode",
                data: {
                    email: $email,
                    flag: 0
                },
                headers: {
                    "token" : CC.getUserInfo() == null ? null : CC.getUserInfo().token,
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
                        $scope.qrCode = true;
                        $scope.isEmail = true;
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
