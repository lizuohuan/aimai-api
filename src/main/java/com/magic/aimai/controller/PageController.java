package com.magic.aimai.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 *  页面控制器
 */
@Controller
@RequestMapping("/page")
@Api(hidden = true)
public class PageController {


    /***************************************登录模块**************************************/

    /**
     * 登录页面
     * @return
     */
    @RequestMapping("/login")
    @ApiOperation(value = "",hidden = true)
    public String login () { return "/wechat/login/login"; }

    /**
     * 注册 -- 1
     * @return
     */
    @RequestMapping("/registerPhone")
    @ApiOperation(value = "",hidden = true)
    public String registerPhone () { return "/wechat/login/registerPhone"; }

    /**
     * 注册 -- 2
     * @return
     */
    @RequestMapping("/registerPassword")
    @ApiOperation(value = "",hidden = true)
    public String registerPassword () { return "/wechat/login/registerPassword"; }

    /**
     * 注册 -- 3
     * @return
     */
    @RequestMapping("/registerData")
    @ApiOperation(value = "",hidden = true)
    public String registerData () { return "/wechat/login/registerData"; }

    /**
     * 选择地址
     * @return
     */
    @RequestMapping("/address")
    @ApiOperation(value = "",hidden = true)
    public String address () { return "/wechat/login/address"; }

    /**
     * 选择行业
     * @return
     */
    @RequestMapping("/tradeList")
    @ApiOperation(value = "",hidden = true)
    public String tradeList () { return "/wechat/login/tradeList"; }

    /**
     * 信息补全页面
     * @return
     */
    @RequestMapping("/complementData")
    @ApiOperation(value = "",hidden = true)
    public String complementData () { return "/wechat/login/complementData"; }


    /***************************************登录模块**************************************/




    /***************************************首页模块**************************************/

    /**
     * 首页页面
     * @return
     */
    @RequestMapping("/index")
    @ApiOperation(value = "",hidden = true)
    public String index () { return "/wechat/index/home"; }

    /**
     * 新闻
     * @return
     */
    @RequestMapping("/news")
    @ApiOperation(value = "",hidden = true)
    public String news () { return "/wechat/index/news"; }

    /**
     * 新闻列表
     * @return
     */
    @RequestMapping("/newsList")
    @ApiOperation(value = "",hidden = true)
    public String newsList () { return "/wechat/index/newsList"; }

    /**
     * 新闻详情
     * @return
     */
    @RequestMapping("/newsInfo")
    @ApiOperation(value = "",hidden = true)
    public String newsInfo () { return "/wechat/index/newsInfo"; }

    /**
     * banner详情
     * @return
     */
    @RequestMapping("/bannerInfo")
    @ApiOperation(value = "",hidden = true)
    public String bannerInfo () { return "/wechat/index/bannerInfo"; }

    /**
     * 关于我们
     * @return
     */
    @RequestMapping("/aboutUs")
    @ApiOperation(value = "",hidden = true)
    public String aboutUs () { return "/wechat/index/aboutUs"; }

    /**
     * 资质
     * @return
     */
    @RequestMapping("/aptitude")
    @ApiOperation(value = "",hidden = true)
    public String aptitude () { return "/wechat/index/aptitude"; }

    /**
     * 巡检
     * @return
     */
    @RequestMapping("/polling")
    @ApiOperation(value = "",hidden = true)
    public String polling () { return "/wechat/index/polling"; }

    /**
     * 网点
     * @return
     */
    @RequestMapping("/branch")
    @ApiOperation(value = "",hidden = true)
    public String branch () { return "/wechat/index/branch"; }

    /***************************************首页模块**************************************/


    /***************************************APP端页面**************************************/

    /**
     * 新闻详情
     * @return
     */
    @RequestMapping("/app/newsInfo")
    @ApiOperation(value = "",hidden = true)
    public String appNewsInfo () { return "/app/newsInfo"; }

    /**
     * banner详情
     * @return
     */
    @RequestMapping("/app/bannerInfo")
    @ApiOperation(value = "",hidden = true)
    public String appBannerInfo () { return "/app/bannerInfo"; }

    /**
     * 使用协议
     * @return
     */
    @RequestMapping("/app/agreement")
    @ApiOperation(value = "",hidden = true)
    public String agreement () { return "/app/agreement"; }

    /**
     * 下载
     * @return
     */
    @RequestMapping("/app/download")
    @ApiOperation(value = "",hidden = true)
    public String download () { return "/app/download"; }

    /***************************************APP端页面**************************************/


    /***************************************我的模块**************************************/

    /**
     * 我的
     * @return
     */
    @RequestMapping("/my")
    @ApiOperation(value = "",hidden = true)
    public String my () { return "/wechat/my/my"; }

    /**
     * 个人资料
     * @return
     */
    @RequestMapping("/personInfo")
    @ApiOperation(value = "",hidden = true)
    public String personInfo () { return "/wechat/my/personInfo"; }

    /**
     * 我的订单
     * @return
     */
    @RequestMapping("/myOrder")
    @ApiOperation(value = "",hidden = true)
    public String myOrder () { return "/wechat/my/myOrder"; }

    /**
     * 我的收藏
     * @return
     */
    @RequestMapping("/myCollect")
    @ApiOperation(value = "",hidden = true)
    public String myCollect () { return "/wechat/my/myCollect"; }

    /**
     * 我的消息
     * @return
     */
    @RequestMapping("/myNews")
    @ApiOperation(value = "",hidden = true)
    public String myNews () { return "/wechat/my/myNews"; }

    /**
     * 意见反馈
     * @return
     */
    @RequestMapping("/feedback")
    @ApiOperation(value = "",hidden = true)
    public String feedback () { return "/wechat/my/feedback"; }

    /**
     * 设置
     * @return
     */
    @RequestMapping("/setting")
    @ApiOperation(value = "",hidden = true)
    public String setting () { return "/wechat/my/setting"; }

    /**
     * 设置清晰度
     * @return
     */
    @RequestMapping("/settingDefinition")
    @ApiOperation(value = "",hidden = true)
    public String settingDefinition () { return "/wechat/my/settingDefinition"; }

    /**
     * 设置邮箱
     * @return
     */
    @RequestMapping("/settingEmail")
    @ApiOperation(value = "",hidden = true)
    public String settingEmail () { return "/wechat/my/settingEmail"; }

    /**
     * 更换邮箱
     * @return
     */
    @RequestMapping("/settingUpdateEmail")
    @ApiOperation(value = "",hidden = true)
    public String settingUpdateEmail () { return "/wechat/my/settingUpdateEmail"; }

    /**
     * 忘记密码
     * @return
     */
    @RequestMapping("/updatePassword")
    @ApiOperation(value = "",hidden = true)
    public String updatePassword () { return "/wechat/my/updatePassword"; }

    /**
     * 验证手机号
     * @return
     */
    @RequestMapping("/settingPhone")
    @ApiOperation(value = "",hidden = true)
    public String settingPhone () { return "/wechat/my/settingPhone"; }

    /**
     * 设置新密码
     * @return
     */
    @RequestMapping("/settingUpdatePassword")
    @ApiOperation(value = "",hidden = true)
    public String settingUpdatePassword () { return "/wechat/my/settingUpdatePassword"; }

    /**
     * 我的证书
     * @return
     */
    @RequestMapping("/certificate")
    @ApiOperation(value = "",hidden = true)
    public String certificate () { return "/wechat/my/certificate"; }

    /***************************************我的模块**************************************/


    /***************************************课程模块**************************************/

    /**
     * 课程
     * @return
     */
    @RequestMapping("/course")
    @ApiOperation(value = "",hidden = true)
    public String course () { return "/wechat/course/course"; }

    /**
     * 课程列表
     * @return
     */
    @RequestMapping("/courseList")
    @ApiOperation(value = "",hidden = true)
    public String courseList () { return "/wechat/course/courseList"; }

    /**
     * 课程列表--搜索
     * @return
     */
    @RequestMapping("/searchCourseList")
    @ApiOperation(value = "",hidden = true)
    public String searchCourseList () { return "/wechat/course/searchCourseList"; }

    /**
     * 课程详情
     * @return
     */
    @RequestMapping("/courseInfo")
    @ApiOperation(value = "",hidden = true)
    public String courseInfo () { return "/wechat/course/courseInfo"; }

    /**
     * 课程播放
     * @return
     */
    @RequestMapping("/courseVideo")
    @ApiOperation(value = "",hidden = true)
    public String courseVideo () { return "/wechat/course/courseVideo"; }

    /**
     * 支付结果
     * @return
     */
    @RequestMapping("/paymentResult")
    @ApiOperation(value = "",hidden = true)
    public String paymentResult () { return "/wechat/course/paymentResult"; }

    /***************************************课程模块**************************************/


    /***************************************学习个人模块**************************************/

    /**
     * 学习个人
     * @return
     */
    @RequestMapping("/study")
    @ApiOperation(value = "",hidden = true)
    public String study () { return "/wechat/study/study"; }

    /**
     * 练习题库
     * @return
     */
    @RequestMapping("/exerciseBank")
    @ApiOperation(value = "",hidden = true)
    public String exerciseBank () { return "/wechat/study/exerciseBank"; }

    /**
     * 练习列表
     * @return
     */
    @RequestMapping("/exerciseList")
    @ApiOperation(value = "",hidden = true)
    public String exerciseList () { return "/wechat/study/exerciseList"; }

    /**
     * 错题库
     * @return
     */
    @RequestMapping("/errorBank")
    @ApiOperation(value = "",hidden = true)
    public String errorBank () { return "/wechat/study/errorBank"; }

    /**
     * 错题列表
     * @return
     */
    @RequestMapping("/errorList")
    @ApiOperation(value = "",hidden = true)
    public String errorList () { return "/wechat/study/errorList"; }

    /**
     * 错题解析
     * @return
     */
    @RequestMapping("/errorInfo")
    @ApiOperation(value = "",hidden = true)
    public String errorInfo () { return "/wechat/study/errorInfo"; }

    /**
     * 模拟库
     * @return
     */
    @RequestMapping("/simulationBank")
    @ApiOperation(value = "",hidden = true)
    public String simulationBank () { return "/wechat/study/simulationBank"; }

    /**
     * 考试套题
     * @return
     */
    @RequestMapping("/examBank")
    @ApiOperation(value = "",hidden = true)
    public String examBank () { return "/wechat/study/examBank"; }

    /**
     * 考试列表
     * @return
     */
    @RequestMapping("/examList")
    @ApiOperation(value = "",hidden = true)
    public String examList () { return "/wechat/study/examList"; }

    /**
     * 提交答案
     * @return
     */
    @RequestMapping("/submitAnswer")
    @ApiOperation(value = "",hidden = true)
    public String submitAnswer () { return "/wechat/study/submitAnswer"; }

    /***************************************学习个人模块**************************************/





    /***************************************学习公司模块**************************************/

    /**
     * 学习（公司）
     * @return
     */
    @RequestMapping("/studyCompany/study")
    @ApiOperation(value = "",hidden = true)
    public String studyCompany () { return "/wechat/studyCompany/study"; }

    /**
     * 搜索员工（公司）
     * @return
     */
    @RequestMapping("/studyCompany/searchUser")
    @ApiOperation(value = "",hidden = true)
    public String searchUser () { return "/wechat/studyCompany/searchUser"; }

    /**
     * 课程详情（公司）
     * @return
     */
    @RequestMapping("/studyCompany/studyCompanyCourseInfo")
    @ApiOperation(value = "",hidden = true)
    public String studyCompanyCourseInfo () { return "/wechat/studyCompany/studyCompanyCourseInfo"; }

    /**
     * 员工学习列表（公司）
     * @return
     */
    @RequestMapping("/studyCompany/studyUserList")
    @ApiOperation(value = "",hidden = true)
    public String studyUserList () { return "/wechat/studyCompany/studyUserList"; }

    /**
     * 员工分配列表（公司）
     * @return
     */
    @RequestMapping("/studyCompany/allotUserList")
    @ApiOperation(value = "",hidden = true)
    public String allotUserList () { return "/wechat/studyCompany/allotUserList"; }

    /**
     * 员工详情（公司）
     * @return
     */
    @RequestMapping("/studyCompany/userDetail")
    @ApiOperation(value = "",hidden = true)
    public String userDetail () { return "/wechat/studyCompany/userDetail"; }

    /**
     * 员工学习课程详情（公司）
     * @return
     */
    @RequestMapping("/studyCompany/userCourseInfo")
    @ApiOperation(value = "",hidden = true)
    public String userCourseInfo () { return "/wechat/studyCompany/userCourseInfo"; }

    /**
     * 分配课程详情（公司）
     * @return
     */
    @RequestMapping("/studyCompany/allotCourse")
    @ApiOperation(value = "",hidden = true)
    public String allotCourse () { return "/wechat/studyCompany/allotCourse"; }

    /**
     * 添加同事（公司）
     * @return
     */
    @RequestMapping("/studyCompany/addUser")
    @ApiOperation(value = "",hidden = true)
    public String addUser () { return "/wechat/studyCompany/addUser"; }

    /**
     * 员工详情（公司）
     * @return
     */
    @RequestMapping("/studyCompany/userInfo")
    @ApiOperation(value = "",hidden = true)
    public String userInfo () { return "/wechat/studyCompany/userInfo"; }

    /***************************************学习公司模块**************************************/


    /***************************************学习政府模块**************************************/

    /**
     * 学习（政府）
     * @return
     */
    @RequestMapping("/studyGovernment/study")
    @ApiOperation(value = "",hidden = true)
    public String studyGovernment () { return "/wechat/studyGovernment/study"; }

    /**
     * 课程详情（政府）
     * @return
     */
    @RequestMapping("/studyGovernment/companyCourseInfo")
    @ApiOperation(value = "",hidden = true)
    public String companyCourseInfo () { return "/wechat/studyGovernment/companyCourseInfo"; }

    /**
     * 公司详情（政府）
     * @return
     */
    @RequestMapping("/studyGovernment/companyDetail")
    @ApiOperation(value = "",hidden = true)
    public String companyDetail () { return "/wechat/studyGovernment/companyDetail"; }

    /**
     * 公司课程员工信息（政府）
     * @return
     */
    @RequestMapping("/studyGovernment/companyCourseUser")
    @ApiOperation(value = "",hidden = true)
    public String companyCourseUser () { return "/wechat/studyGovernment/companyCourseUser"; }

    /***************************************学习政府模块**************************************/


}
