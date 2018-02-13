var $document = $(document);
var video = document.getElementById("video");
/******************滑条使用范围*******************/
var range = $("#range"); //滑条
var bufferProgress = $("#bufferProgress"); //缓冲进度条
var cashProgress = $("#cashProgress"); //已播放进度
var glider = $("#glider"); //滑动物
var isDown = false; //表示是是否按下
var min = 0; //滑条最小值
var max = 100; //滑条最大值
var value = 10; //当前值
var isDrag = false; //是否可拖动
/******************滑条使用范围*******************/

/******************控制台操作*******************/
var startBtn = $("#startBtn"); //播放按钮
var endBtn = $("#endBtn"); //暂停按钮
var totalTime = $("#totalTime"); //总时间
var currentTime = $("#currentTime"); //当前播放时间
/******************控制台操作*******************/

/*********************逻辑变量*************************/
var isBuffer = false; //是否设置缓冲进度--跟网络有关
var bodyLeft = $("#progressBar").offset().left; //获取父级距离body的位置
var seconds = 0; //存放播放时长
/*********************逻辑变量*************************/

//封装video控制台
var initVideo = {
    //播放
    play: function() {
        endBtn.show();
        startBtn.hide();
        if(video.paused) {
            video.play();
        }
    },
    //暂停
    pause: function() {
        endBtn.hide();
        startBtn.show();
        initVideo.shadeHide();
        if(!video.paused){
            video.pause();
        }
    },
    //开始播放
    startPlay: function() {
        //initVideo.shadeHide();
        initVideo.setTotalTime();
        //0.此元素未初始化 1.正常但没有使用网络 2.正在下载数据 3.没有
        CC.print("initVideo.getNetworkState()：" + initVideo.getNetworkState());
        //设置当前播放时间
        currentTime.html(initVideo.getFormatTime(initVideo.getCurrentTime()));
        //设置播放进度条
        initVideo.setCashProgress(initVideo.countPercent(initVideo.getCurrentTime()));
        //设置缓冲进度条
        if(!isBuffer) {
            initVideo.setBufferProgress(initVideo.countPercent(initVideo.getBufferTime()));
        }
        if(initVideo.getTotalTime() == initVideo.getBufferTime() && !isBuffer) {
            isBuffer = true;
        }
        //设置托动物位置
        initVideo.setDrag();

        return false;
        //以下是判断视频播放状态：可是每个浏览器的状态不一样所以暂无用
        switch(initVideo.getNetworkState()) {
            case 0:

                break;
            case 1:
                //设置当前播放时间
                currentTime.html(initVideo.getFormatTime(initVideo.getCurrentTime()));
                //设置播放进度条
                initVideo.setCashProgress(initVideo.countPercent(initVideo.getCurrentTime()));
                //设置缓冲进度条
                if(!isBuffer) {
                    initVideo.setBufferProgress(initVideo.countPercent(initVideo.getBufferTime()));
                }
                if(initVideo.getTotalTime() == initVideo.getBufferTime() && !isBuffer) {
                    isBuffer = true;
                }
                //设置托动物位置
                initVideo.setDrag();
                break;
            case 2:
                initVideo.shadeHide();
                break;
            case 3:

                break;
        }
    },
    //获取总时间 -- 单位:秒
    getTotalTime: function() {
        return video.duration;
    },
    //获取已缓冲时间 -- 单位:秒
    getBufferTime: function() {
        try {
            return video.buffered.end(0); //结束时间
        }
        catch (error){
            return 0;
        }
    },
    //获取网络状态  0.此元素未初始化 1.正常但没有使用网络 2.正在下载数据 3.没有
    getNetworkState: function() {
        return video.networkState;
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
        if (h == "00") {
            return m + ":" + s;
        }
        return h + ":" + m + ":" + s;
    },
    //获取当前播放时间
    getCurrentTime: function() {
        return parseInt(video.currentTime);
    },
    //赋值总时间
    setTotalTime: function () {
        var timer = setInterval(function() {
            if(!isNaN(initVideo.getTotalTime())) {
                //初始化总时间
                totalTime.html(initVideo.getFormatTime(initVideo.getTotalTime()));
                clearInterval(timer);
            }
        }, 500);
    },
    //赋值播放位置时间
    setCurrentTime: function(value) {
        video.currentTime = value;
    },
    //时间改变事件
    onTimeUpdate: function(callback) {
        video.addEventListener("timeupdate", callback);
    },
    //计算百分比
    countPercent: function(currentTime) {
        return(currentTime / initVideo.getTotalTime()) * max;
    },
    //计算秒数
    countSecond: function(value) {
        return value * initVideo.getTotalTime() / max;
    },
    //计算滑动条value值： 最大100
    countValue: function(x, width) {
        return Math.floor(x / width * max);
    },
    //计算滑动物的left
    countLeft: function() {
        return initVideo.countPercent(initVideo.getCurrentTime()) * range.width() / max - 7;
    },
    //移动滑动物
    payDrag: function(event) {
        var x = event.originalEvent.targetTouches[0].clientX; //获取距离父级的位置 -- (移动端)
        x = x - bodyLeft; // 减去距离body的宽度
        var value = initVideo.countValue(x + 5, range.width()); // + 5 避免错位
        if(value >= min && value <= max) {
            //判断是否可快进
            if(isDrag) {
                //赋值滑动物的坐标
                glider.css({
                    left: x - 7 //减去滑动物的一半宽度
                });
                //设置播放进度条
                initVideo.setCashProgress(value);
                //设置播放时间
                initVideo.setCurrentTime(initVideo.countSecond(value));
            } else {
                if(value <= initVideo.countPercent(initVideo.getCurrentTime()) || value <= initVideo.countPercent(seconds)) {
                    //赋值滑动物的坐标
                    glider.css({
                        left: x - 7 //减去滑动物的一半宽度
                    });
                    //设置播放进度条
                    initVideo.setCashProgress(value);
                    //设置播放时间
                    initVideo.setCurrentTime(initVideo.countSecond(value));
                }
            }

        }
    },
    //赋值托动物位置
    setDrag: function() {
        glider.css({
            left: initVideo.countLeft()
        });
    },
    //赋值已播放进度
    setCashProgress: function(width) {
        cashProgress.css("width", width + "%");
    },
    //赋值缓冲进度
    setBufferProgress: function(width) {
        bufferProgress.css("width", width + "%");
    },
    //还原进度条
    restore: function () {
        glider.css({
            left: 0
        });
        initVideo.setCashProgress(0);
        initVideo.setBufferProgress(0);
    },
    //显示视频遮罩
    shadeShow: function() {
        $(".video-shade").css({
            "background": "rgba(0, 0, 0, 1)",
            "z-index" : 1,
        });
        $(".video-shade .video-cover").show();
        $(".video-shade .video-loading").show();
    },
    //隐藏视频遮罩
    shadeHide: function() {
        $(".video-shade").css({
            "background":"rgba(0, 0, 0, 0)",
            "z-index" : 0,
        });
        $(".video-shade .video-cover").hide();
        $(".video-shade .video-loading").hide();
    },
    //更换视频地址
    setSrc: function (url) {
        video.src = url;
        initVideo.pause();
        initVideo.shadeShow();
    },
    //判断是否播放完成
    isEnded: function () {
        if (video.ended) {
            endBtn.hide();
            startBtn.show();}
        return video.ended;
    },
    //全屏播放
    openFullscreen: function() {
        video.webkitEnterFullScreen();
    },
    //退出全屏播放
    outFullscreen: function() {

    },

}

//定时器--定时获取视频时间 --获取到了表示视频已就绪好
initVideo.setTotalTime();

/*
//按下事件
$document.on("mousedown", "#range", function(event) {
    alert("按下了");
    isDown = true;
    //判断是否已经按下
    if(isDown) {
        initVideo.pause();
        initVideo.payDrag(event); //调用拖动
    }
});

//松开事件
$document.on('mouseup', "#range", function(event) {
    alert("松开了");
    isDown = false;
    initVideo.play();
});

//拖动
$document.on('mousemove', "#range", function(event) {
    alert("开始拖动.");
    //判断是否已经按下
    if(isDown) {
        initVideo.payDrag(event); //调用拖动
    }
});*/

//按下事件
$("#range").bind("touchstart", function (event) {
    isDown = true;
    event.preventDefault();
});

//拖动
$("#range").bind("touchmove", function (event) {
    //判断是否已经按下
    if(isDown) {
        initVideo.payDrag(event); //调用拖动
    }
});

//松开事件
$("#range").bind("touchend", function (event) {
    isDown = false;
    //initVideo.play();
    event.preventDefault();
});
