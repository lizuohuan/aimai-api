var CC = function () {};
CC.prototype = {
	ip: 'http://' + window.location.host + '/api/',
	//ipImg: 'http://multimedia.aimaiap.com/images/',
	//ipVideo: 'http://multimedia.aimaiap.com/video/',
	ipImg: 'http://192.168.31.110:8080/images/',
	ipVideo: 'http://192.168.31.110:8080/video/',
	//是否开启测试模式
	isDebug : true,
	ipUrl: location.href.split('#')[0],
	//手机号码正则表达式
	isMobile : /^(((13[0-9]{1})|(18[0-9]{1})|(17[6-9]{1})|(15[0-9]{1}))+\d{8})$/,
	//电话号码正则表达式
	isPhone : /[0-9-()（）]{7,18}/,
	//身份证正则表达式
	isIdentityCard :   /^\d{15}(\d{2}[\d|X])?$/,
	//6-16的密码
	isPwd : /[A-Za-z0-9]{6,16}/,
	//输入的是否为数字
	isNumber : /^[0-9]*$/,
	//检查小数
	isDouble : /^\d+(\.\d+)?$/,
	//输入的只能为数字和字母
	isNumberChar: /[A-Za-z0-9]{3,16}/,
	//用户名
	isUserName : /[\w\u4e00-\u9fa5]/,
	//emoji 表情正则
	isEmoji : /\uD83C[\uDF00-\uDFFF]|\uD83D[\uDC00-\uDE4F]/g,
	//验证邮箱
	isEmail : /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/,
	//只能输入汉字
	isChinese : /[\u4e00-\u9fa5]/gm,
	//EyeKey APP ID
	eyeKeyAppId : "290e756d69154ba4b82e88d99c7e4740",
	//EyeKey APP KEY
	eyeKeyAppKey : "e656befe4be64bd8836e707ab5cbc76d",
	//控制台打印输出
	print : function (obj) {
		if (CC.isDebug) console.log(obj);
	},
	//获取url中的参数
	getUrlParam : function(name) {
		var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
		var r = window.location.search.substr(1).match(reg); //匹配目标参数
		if(r != null){
			return unescape(r[2]);
		}else{
			return null; //返回参数值
		}
	},
	//时间戳转日期
	timeStampConversion : function (timestamp){
		var d = new Date(timestamp);    //根据时间戳生成的时间对象
		var date = (d.getFullYear()) + "-" +
			(d.getMonth() + 1) + "-" +
			(d.getDate())+ " " +
			(d.getHours()) + ":" +
			(d.getMinutes()) + ":" +
			(d.getSeconds());
		return date;
	},
	//日期转换为时间戳
	getTimeStamp : function (time){
		time=time.replace(/-/g, '/');
		var date=new Date(time);
		return date.getTime();
	},
	//秒计算出分钟数
	getFormatTime: function(time) {
		var time = time;
		var h = parseInt(time / 3600),
			m = parseInt(time % 3600 / 60),
			s = parseInt(time % 60);
		h = h < 10 ? "0" + h : h;
		m = m < 10 ? "0" + m : m;
		s = s < 10 ? "0" + s : s;

		h = h == NaN ? "00" : h;
		m = m == NaN ? "00" : m;
		s = s == NaN ? "00" : s;
		return h + ":" + m + ":" + s;
	},
	//秒计算出分钟数--汉字
	getFormat: function (value) {
		var theTime = parseInt(value);// 秒
		var theTime1 = 0;// 分
		var theTime2 = 0;// 小时
		if(theTime > 60) {
			theTime1 = parseInt(theTime/60);
			theTime = parseInt(theTime%60);
			if(theTime1 > 60) {
				theTime2 = parseInt(theTime1/60);
				theTime1 = parseInt(theTime1%60);
			}
		}
		var result = ""+parseInt(theTime)+"秒";
		if(theTime1 > 0) {
			result = ""+parseInt(theTime1)+"分"+result;
		}
		if(theTime2 > 0) {
			result = ""+parseInt(theTime2)+"小时"+result;
		}
		return result;
	},
	//获取时间格式
	getCountTime : function (createTime, dateTimeStamp) {
		var minute = 1000 * 60;
		var hour = minute * 60;
		var day = hour * 24;
		var halfamonth = day * 15;
		var month = day * 30;
		var result = "";
		var now = dateTimeStamp;
		var diffValue = now - createTime;
		/*if(diffValue < 0){
			alert("时间计算出错！");
		}*/
		var monthC =diffValue/month;
		var weekC =diffValue/(7*day);
		var dayC =diffValue/day;
		var hourC =diffValue/hour;
		var minC =diffValue/minute;
		if(monthC>=1){
			result = parseInt(monthC) + "个月前";
		}
		else if(weekC>=1){
			result = parseInt(weekC) + "周前";
		}
		else if(dayC>=1){
			result = parseInt(dayC) +"天前";
		}
		else if(hourC>=1){
			result = parseInt(hourC) +"小时前";
		}
		else if(minC>=1){
			result = parseInt(minC) +"分钟前";
		}else
			result="1分钟前";
		return result;

	},
	//自定义四舍五入
	getRound : function (floatvar) {
		var f_x = parseFloat(floatvar);
		if (isNaN(f_x)){
			return '0.00';
		}
		var f_x = Math.round(f_x*100)/100;
		var s_x = f_x.toString();
		var pos_decimal = s_x.indexOf('.');
		if (pos_decimal < 0){
			pos_decimal = s_x.length;
			s_x += '.';
		}
		while (s_x.length <= pos_decimal + 2){
			s_x += '0';
		}
		return s_x;
	},
	//返回上一页并刷新，在需要刷新的页面调用
	reload : function () {
		window.onpageshow = function(e){
			var a = e || window.event;
			if(a.persisted){
				window.location.reload();
			}
		}
		/*window.onpageshow = function (event) {
			if (event.persisted) {
				window.location.reload();
			}
		}*/
	},
	/** 图片压缩
	 * 调用：
	 * 	var imageUrl = CC.getObjectURL($(this)[0].files[0]);
	 	CC.convertImgToBase64(imageUrl, function(base64Img) {
            checkFace(base64Img.split(",")[1], base64Img);
        });
	 * **/
	convertImgToBase64 : function (url, callback, outputFormat) {
		var canvas = document.createElement('CANVAS');
		var ctx = canvas.getContext('2d');
		var img = new Image;
		img.crossOrigin = 'Anonymous';
		img.onload = function() {
			var width = img.width;
			var height = img.height;
			// 按比例压缩4倍
			var rate = (width < height ? width / height : height / width) / 4;
			canvas.width = width * rate;
			canvas.height = height * rate;
			ctx.drawImage(img, 0, 0, width, height, 0, 0, width * rate, height * rate);
			var dataURL = canvas.toDataURL(outputFormat || 'image/png');
			callback.call(this, dataURL);
			canvas = null;
		};
		img.src = url;
	},
	/** 获取图片路径 **/
	getObjectURL : function (file) {
		var url = null;
		if(window.createObjectURL != undefined) { // basic
			url = window.createObjectURL(file);
		} else if(window.URL != undefined) { // mozilla(firefox)
			url = window.URL.createObjectURL(file);
		} else if(window.webkitURL != undefined) { // web_kit or chrome
			url = window.webkitURL.createObjectURL(file);
		}
		return url;
	},
	/**选择文件处理文件流**/
	selectFileImage : function (file) {
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
				canvas.width = expectWidth;
				canvas.height = expectHeight;
				ctx.drawImage(this, 0, 0, expectWidth, expectHeight);
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
					var encoder = new JPEGEncoder();
					base64 = encoder.encode(ctx.getImageData(0, 0, expectWidth, expectHeight), 80);
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
				$("#tempBase64").val(base64);
			};
		};
		oReader.readAsDataURL(file);
	},
	/**对图片旋转处理**/
	rotateImg : function (img, direction,canvas) {
		//最小与最大旋转方向，图片旋转4次后回到原方向
		var min_step = 0;
		var max_step = 3;
		//var img = document.getElementById(pid);
		if (img == null)return;
		//img的高度和宽度不能在img元素隐藏后获取，否则会出错
		var height = img.height;
		var width = img.width;
		//var step = img.getAttribute('step');
		var step = 2;
		if (step == null) {
			step = min_step;
		}
		if (direction == 'right') {
			step++;
			//旋转到原位置，即超过最大值
			step > max_step && (step = min_step);
		} else {
			step--;
			step < min_step && (step = max_step);
		}
		//旋转角度以弧度值为参数
		var degree = step * 90 * Math.PI / 180;
		var ctx = canvas.getContext('2d');
		switch (step) {
			case 0:
				canvas.width = width;
				canvas.height = height;
				ctx.drawImage(img, 0, 0);
				break;
			case 1:
				canvas.width = height;
				canvas.height = width;
				ctx.rotate(degree);
				ctx.drawImage(img, 0, -height);
				break;
			case 2:
				canvas.width = width;
				canvas.height = height;
				ctx.rotate(degree);
				ctx.drawImage(img, -width, -height);
				break;
			case 3:
				canvas.width = height;
				canvas.height = width;
				ctx.rotate(degree);
				ctx.drawImage(img, -width, 0);
				break;
		}
	},
	/**显示遮罩**/
	showShade : function (context) {
		var loading = '<div class="loader-inner ball-clip-rotate-multiple"><div></div><div></div></div>';
		var html = 	"<div class=\"whiteMask\">" +
				"	<div class=\"loading-bar\">" +
				"		<div class=\"mui-row\">" +
				"			<div class=\"mui-col-xs-12 mui-col-sm-12\">" +
				"				<div class=\"loadingImg\">" + loading + "</div>" +
				"				<span class=\"loading-hint\">" + context + "</span>" +
				"			</div>" +
				"		</div>" +
				"	</div>" +
				"</div>";
		return html;

	},
	//关闭遮罩
	hideShade : function () {
		$(".whiteMask").remove();
	},
	//显示loading
	showLoading : function (context) {
		var loading = '<div class="ball-loading"><div></div><div></div></div>';
		var html = "<div class='loading-bg'>" +
			"			<div class='loading-content'>" +
			"				<div class='loading-object'>" + loading + "</div>" +
			"				<div class='loading-context'>" + context + "</div>" +
			"			</div>" +
			"		</div>";
		return html;
	},
	//隐藏loading
	hideLoading : function () {
		$("body .mui-content").show();
		$(".loading-bg").css("background", "rgba(0, 0, 0, 0)");
		$(".loading-content").css("background", "rgba(0, 0, 0, 0)");
		setTimeout(function () {
			$(".loading-bg").remove();
		}, 500);
	},
	//判断是否是json对象
	isJson : function (obj){
		var isjson = typeof(obj) == "object" && Object.prototype.toString.call(obj).toLowerCase() == "[object object]" && !obj.length;
		return isjson;
	},
	//获取登录人信息
	getUserInfo : function () {
		var userInfo = JSON.parse(localStorage.getItem("userInfo"));
		return userInfo;
	},
	//输入框输入只保留两位小数
	clearNoNum : function (obj) {
		//先把非数字的都替换掉，除了数字和.
		obj.value = obj.value.replace(/[^\d.]/g,"");
		//保证只有出现一个.而没有多个.
		obj.value = obj.value.replace(/\.{2,}/g,".");
		//必须保证第一个为数字而不是.
		obj.value = obj.value.replace(/^\./g,"");
		//保证.只出现一次，而不能出现两次以上
		obj.value = obj.value.replace(".","$#$").replace(/\./g,"").replace("$#$",".");
		//只能输入两个小数
		obj.value = obj.value.replace(/^(\-)*(\d+)\.(\d\d).*$/,'$1$2.$3');
	},
	//微信支付appId
	wxAppId : "wxc451c8ccd0926f75",
	//微信端--微信支付调起
	wechatPay : function (appId, timeStamp, nonceStr, prepayId, signType, paySign, callback) {
		if (typeof WeixinJSBridge == "undefined"){
			if( document.addEventListener ){
				document.addEventListener('WeixinJSBridgeReady', CC.onBridgeReady, false);
			}else if (document.attachEvent){
				document.attachEvent('WeixinJSBridgeReady', CC.onBridgeReady);
				document.attachEvent('onWeixinJSBridgeReady', CC.onBridgeReady);
			}
		}else{
			//CC.onBridgeReady(appId, timeStamp, nonceStr, prepayId, signType, paySign, jumpUrl, orderId);
			WeixinJSBridge.invoke(
				'getBrandWCPayRequest', {
					"appId" : appId,     //公众号名称，由商户传入
					"timeStamp" : timeStamp,         //时间戳，自1970年以来的秒数
					"nonceStr" : nonceStr, //随机串
					"package" : prepayId,
					"signType" : signType,         //微信签名方式：
					"paySign" : paySign //微信签名
				},
				function(res){
					callback(res);
				}
			);
		}
	},
	//微信端--微信支付签名
	onBridgeReady : function (appId, timeStamp, nonceStr, prepayId, signType, paySign, jumpUrl, orderId) {
		WeixinJSBridge.invoke(
			'getBrandWCPayRequest', {
				"appId" : appId,     //公众号名称，由商户传入
				"timeStamp" : timeStamp,         //时间戳，自1970年以来的秒数
				"nonceStr" : nonceStr, //随机串
				"package" : prepayId,
				"signType" : signType,         //微信签名方式：
				"paySign" : paySign //微信签名
			},
			function(res){
				if(res.err_msg == "get_brand_wcpay_request:ok" ) {// 使用以上方式判断前端返回,微信团队郑重提示：res.err_msg将在用户支付成功后返回    ok，但并不保证它绝对可靠。
					mui.alert("支付成功.");
					location.href = CC.ip + jumpUrl + "?isSucceed=1&orderId=" + orderId;
				}
				else {
					mui.alert("支付失败.");
					location.href = CC.ip + jumpUrl + "?isSucceed=0&orderId=" + orderId;
				}
			}
		);
	},
	//微信API签名
	getWxJsSign : function () {
		var jsSignList = null;
		CC.ajaxRequestData("get", false, "wxClient/jsSign", {url : this.ipUrl}, function(result){
			jsSignList = result.data;
		});
		return jsSignList;
	},
	//ajax请求数据  get/post方式
	ajaxRequestData : function(method, async, requestUrl, arr, callback){
		if (arr != null) arr.isWechat = 1;
		CC.print("************请求参数**************");
		CC.print(requestUrl);
		CC.print(arr);
		CC.print("************请求参数**************");
		$.ajax({
			type: "POST",
			async: async,
			url: CC.ip + requestUrl,
			data: arr,
			//dataType:"jsonp",    //跨域json请求一定是jsonp
			headers: {
				"token" : CC.getUserInfo() == null ? null : CC.getUserInfo().token,
			},
			success:function(json){
				if (!CC.isJson(json)) {
					json = JSON.parse(json);
				}
				CC.print("************config**************");
				CC.print(json);
				CC.print("************config**************");
				if(json.flag==0 && json.code ==200){
					if (callback) {
						callback(json);
					}
				}
				else if(json.code == 1005){
					localStorage.removeItem("userInfo");
					mui.confirm('登录已失效，是否登录？', '', ["确认","取消"], function(e) {
						if (e.index == 0) {
							location.href = CC.ip + "page/login";
							sessionStorage.setItem("url", window.location.href);
						} else {
							location.href = CC.ip + "page/index";
						}
					});
				}
				else if (json.code == 1010) {
					mui.alert(json.msg);
				}
				else {
					mui.toast(json.msg);
				}
			},
			error: function(json) {
				mui.toast(json.responseText);
			}
		})
	},
};

var CC = new CC();

//转时间戳
Date.prototype.format = function (fmt) { //author: meizz
	var o = {
		"M+": this.getMonth() + 1, //月份
		"d+": this.getDate(), //日
		"h+": this.getHours(), //小时
		"m+": this.getMinutes(), //分
		"s+": this.getSeconds(), //秒
		"q+": Math.floor((this.getMonth() + 3) / 3), //季度
		"S": this.getMilliseconds() //毫秒
	};
	if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
	for (var k in o)
		if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
	return fmt;
}
