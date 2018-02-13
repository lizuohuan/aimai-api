
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登录</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/page/login/login.css">
</head>
<body ng-app="webApp" ng-controller="loginController" ng-cloak>

<div class="mui-content">
    <h2 class="title color">登录</h2>
    <h4 class="title-sub color-p">欢迎使用爱麦415APP</h4>
    <form id='login-form' class="mui-input-group">
        <div class="mui-input-row">
            <label>账号</label>
            <input id='account' type="text" class="mui-input-clear mui-input"
                   placeholder="手机号"
                   maxlength="11"
                   onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9-]+/,'');}).call(this)">
        </div>
        <div class="mui-input-row">
            <label>验证码</label>
            <input id='qr' type="text" class="mui-input" placeholder="输入验证码" maxlength="4" onKeypress="return (/[\d.]/.test(String.fromCharCode(event.keyCode)))">
            <button type="button" class="mui-btn qr-btn" ng-click="sendCode()">
                获取验证码
            </button>
        </div>
        <div class="mui-input-row">
            <label>密码</label>
            <input id='password' type="password" class="mui-input-clear mui-input" placeholder="输入密码" maxlength="32">
        </div>
    </form>
    <div class="mui-content-padded">
        <button class="mui-btn mui-btn-block" ng-click="confirm()">登录</button>
        <div class="link-area">
            <a class='forgetPassword color-p' href="<%=request.getContextPath()%>/page/settingPhone">忘记密码</a>
            <a class='reg color-p' href="#picture">立即注册</a>
        </div>
    </div>
</div>

<!-- 弹窗 -->
<div id="picture" class="mui-popover mui-popover-action mui-popover-bottom">
    <ul class="mui-table-view">
        <li class="mui-table-view-cell">
            <div class="reg-way">
                <div>选择注册身份</div>
            </div>
            <div class="mui-row">
                <div class="mui-col-xs-4 mui-col-sm-4 reg-mode" ng-click="register(0)">
                    <img src="<%=request.getContextPath()%>/resources/img/login/1.png">
                    <p class="reg-mode-title">个人</p>
                </div>
                <div class="mui-col-xs-4 mui-col-sm-4 reg-mode" ng-click="register(1)">
                    <img src="<%=request.getContextPath()%>/resources/img/login/2.png">
                    <p class="reg-mode-title">公司</p>
                </div>
                <div class="mui-col-xs-4 mui-col-sm-4 reg-mode" ng-click="register(2)">
                    <img src="<%=request.getContextPath()%>/resources/img/login/3.png">
                    <p class="reg-mode-title">政府</p>
                </div>
            </div>
        </li>
    </ul>
</div>

<%@include file="../common/js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/jQuery.md5.js"></script>

<script>

    CC.reload(); //刷新一下上一页传回来的东西

    var webApp = angular.module('webApp', []);
    webApp.controller('loginController', function($scope, $http, $timeout) {

        $scope.phone = null; //存放获取验证码手机号码--以免手机号被篡改
        $scope.isPhone = false; //存放手机号是否存在状态
        $scope.qrCode = "";

        //提交资料
        $scope.confirm = function() {
            //账号
            var $account = $("#account").val();
            //验证码
            var $qr = $('#qr').val();
            //密码
            var $password = $("#password").val();

            if ($account.trim() == "") {
                mui.toast("请输入手机号.");
                $("#account").focus();
                $("#account").val("");
                return false;
            }
            else if($scope.qrCode == "") {
                mui.toast("请获取验证码.");
                return false;
            } else if($qr == "") {
                mui.toast("验证码不能为空.");
                return false;
            } else if($scope.qrCode != $qr) {
                mui.toast("验证码错误，请重新输入.");
                return false;
            }
            if ($password.trim() == "") {
                mui.toast("请输入密码.");
                $("#password").focus();
                $("#password").val("");
                return false;
            }
            else if($password.trim().length < 6 || $password.trim().length > 32) {
                mui.toast("请输入6-32位的密码.");
                $("#password").focus();
                return false;
            }

            var parameter = {
                phone : $account,
                password : $.md5($password),
                code : $scope.qrCode
            }

            CC.ajaxRequestData("post", false, "user/login", parameter, function (result) {
                //清空一些缓存信息
                sessionStorage.removeItem("faceId");
                sessionStorage.removeItem("selectAddress");
                sessionStorage.removeItem("tradeInfo");
                sessionStorage.removeItem("veriFaceImages");
                sessionStorage.removeItem("licenseFile");

                if (sessionStorage.getItem("url") != null && sessionStorage.getItem("url") != "") {
                    localStorage.setItem("userInfo", JSON.stringify(result.data));
                    sessionStorage.removeItem("url");
                    window.history.back();
                }
                else {
                    var userInfo = result.data;
                    CC.print(userInfo);
                    var userInfo = result.data;
                    if (userInfo.roleId == 4) {
                        if (userInfo.faceId == null || userInfo.faceId == "") {
                            sessionStorage.setItem("complementUser", JSON.stringify(result.data));
                            location.href = CC.ip + "page/complementData";
                        }
                        else {
                            localStorage.setItem("userInfo", JSON.stringify(result.data));
                            location.href = CC.ip + "page/my";
                        }
                    }
                    else if (userInfo.roleId == 3) {

                        if (userInfo.cityId == null || userInfo.licenseFile == "" || userInfo.licenseFile == null || userInfo.tradeId == null) {
                            sessionStorage.setItem("complementUser", JSON.stringify(result.data));
                            location.href = CC.ip + "page/complementData";
                        }
                        else {
                            localStorage.setItem("userInfo", JSON.stringify(result.data));
                            location.href = CC.ip + "page/my";
                        }
                    }
                    else if (userInfo.roleId == 2) {
                        if (userInfo.cityId == null || userInfo.licenseFile == "" || userInfo.licenseFile == null) {
                            sessionStorage.setItem("complementUser", JSON.stringify(result.data));
                            location.href = CC.ip + "page/complementData";
                        }else {
                            localStorage.setItem("userInfo", JSON.stringify(result.data));
                            location.href = CC.ip + "page/my";
                        }
                    }
                }
            });

        }

        //获取验证码
        $scope.sendCode = function() {
            var $phone = $('#account').val();
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
                url: CC.ip + "user/getLoginCode",
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

        //去注册
        $scope.register = function (type) {
            location.href = CC.ip + "page/registerPhone?registerType=" + type;
        }

    });
</script>
</body>
</html>
