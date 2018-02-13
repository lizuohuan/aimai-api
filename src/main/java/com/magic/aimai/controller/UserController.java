package com.magic.aimai.controller;

import com.magic.aimai.business.entity.*;
import com.magic.aimai.business.enums.Common;
import com.magic.aimai.business.enums.RoleEnum;
import com.magic.aimai.business.exception.InterfaceCommonException;
import com.magic.aimai.business.face.EyeFaceUtil;
import com.magic.aimai.business.mail.Config;
import com.magic.aimai.business.mail.EmailUtil;
import com.magic.aimai.business.service.CityService;
import com.magic.aimai.business.service.LoginLogService;
import com.magic.aimai.business.service.TradeService;
import com.magic.aimai.business.service.UserService;
import com.magic.aimai.business.sms.SMSCode;
import com.magic.aimai.business.util.CommonUtil;
import com.magic.aimai.business.util.LoginHelper;
import com.magic.aimai.business.util.StatusConstant;
import com.magic.aimai.business.util.TextMessage;
import com.magic.aimai.util.ViewData;

import io.swagger.annotations.*;
import net.sf.json.JSONArray;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.View;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.text.MessageFormat;
import java.util.Date;

/**
 * Created by Eric Xie on 2017/7/12 0012.
 */
@RestController
@RequestMapping("/user")
@Api(value = "用户API",description = "用户相关API 列表")
public class UserController extends BaseController {

    @Resource
    private UserService userService;
    @Resource
    private CityService cityService;
    @Resource
    private TradeService tradeService;
    @Resource
    private LoginLogService loginLogService;



    @RequestMapping(value = "/getLoginCode",method = RequestMethod.POST)
    @ApiOperation(value = "移动端以及微信端 登录时候获取验证码接口")
    @ApiImplicitParam(name = "phone",value = "手机号",required = true)
    public ViewData getLoginCode(String phone){
        if(CommonUtil.isEmpty(phone)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"手机号不能为空");
        }
        User user = userService.queryBaseUserByPhone(phone);
        if(null == user){
            return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"手机号不存在");
        }
        if(RoleEnum.BUSINESS_USER.ordinal() == user.getRoleId()){
            return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
        }
        try {
            String code = userService.loginCode(phone);
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",code);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"发送失败");
        }
    }



    @RequestMapping(value = "/getIp",method = RequestMethod.POST)
    public ViewData getIp(HttpServletRequest request){
       return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",CommonUtil.getIpAddr(request));
    }


    @RequestMapping(value = "/sendEmailCode",method = RequestMethod.POST)
    @ApiOperation(value = "绑定邮箱发送验证码接口")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "email",value = "邮箱",required = true),
            @ApiImplicitParam(name = "flag",value = "0:绑定邮箱  1:换绑",required = true)
    })
    public ViewData sendEmailCode(String email,Integer flag){

        if(CommonUtil.isEmpty(email,flag)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(flag != 0 && flag != 1){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        try {
            User currentUser = LoginHelper.getCurrentUserOfAPI();
            User emailUser = userService.getUserByEmail(email,flag == 0 ? null : currentUser.getId());
            if(null != emailUser){
                return buildFailureJson(StatusConstant.Fail_CODE,"邮箱已经存在");
            }
            String code = SMSCode.createRandomCode();
            LoginHelper.del("email_"+email);
            LoginHelper.add("email_"+email,code,StatusConstant.VALID_CODE * 60);
            EmailUtil.sendEmail(new Email(email,"验证码",MessageFormat.format(Config.content,code,StatusConstant.VALID_CODE)));
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"发送成功");
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }

    @RequestMapping(value = "/updateEmail",method = RequestMethod.POST)
    @ApiOperation(value = "更新邮箱接口")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "email",value = "邮箱",required = true),
            @ApiImplicitParam(name = "code",value = "验证码",required = true)
    })
    public ViewData updateEmail(String email,String code){

        if(CommonUtil.isEmpty(email,code)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        Object o = LoginHelper.get("email_" + email);
        if(null == o){
            return buildFailureJson(StatusConstant.Fail_CODE,"验证码失效");
        }
        if(!code.equals(o.toString())){
            return buildFailureJson(StatusConstant.Fail_CODE,"验证码不匹配");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            User temp = new User();
            temp.setId(user.getId());
            temp.setEmail(email);
            userService.update(temp);
            user.setEmail(email);
            LoginHelper.replaceToken(user.getToken(),user);
            LoginHelper.del("email_" + email);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"验证失败");
        }
    }


    @RequestMapping(value = "/queryUserStudyStatus",method = RequestMethod.POST)
    @ApiOperation(value = "企业用户获取课程下 已观看  和 已考核 人列表")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "orderId",value = "订单ID",required = true,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "flag",value = "标记  0:查看已观看的人数 1:查看已考核人数",required = true,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "pageNO",value = "分页参数",required = true,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "pageSize",value = "分页参数",required = true,dataType = "path",paramType = "Integer.class")
    })
    public ViewData queryUserStudyStatus(Integer orderId,Integer flag,Integer pageNO,Integer pageSize){
        if(CommonUtil.isEmpty(orderId,flag,pageNO,pageSize)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(0 != flag && 1 != flag){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        try {
            User company = LoginHelper.getCurrentUserOfAPI();
            if(RoleEnum.COMPANY_USER.ordinal() != company.getRoleId()){
                return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    userService.queryUserStudyStatus(flag,company.getId(),orderId,pageNO,pageSize));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }


    /**
     *  政府个人中心 统计接口
     * @param cityId
     * @param levelType
     * @return
     */
    @RequestMapping(value = "/statistics",method = RequestMethod.POST)
    @ApiOperation(value = "政府学习中心 统计接口",response = WebStatistics.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "cityId",value = "城市ID,如果为null,则默认当前用户的cityId",required = false,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "levelType",value = "城市级别 1:省级,2:市级,3:区县级 当cityId不为空时,该字段必选",
            required = false,dataType = "path",paramType = "Integer.class")
    })
    public ViewData statistics(Integer cityId,Integer levelType){
        if(null != cityId && null == levelType){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            if(RoleEnum.GOVERNMENT_USER.ordinal() != user.getRoleId()){
                return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
            }
            if(null == cityId){
                cityId = user.getCityId();
                levelType = 3;
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    userService.webStatistics(null, null,cityId,levelType,null,null));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }

    }



    @RequestMapping(value = "/queryCompanyDetail",method = RequestMethod.POST)
    @ApiOperation(value = "获取公司详情")
    @ApiImplicitParam(name = "companyId",value = "公司ID",required = true,dataType = "path",paramType = "Integer.class")
    public ViewData queryCompanyDetail(Integer companyId){
        if(CommonUtil.isEmpty(companyId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            LoginHelper.getCurrentUserOfAPI();
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    userService.queryCompanyDetail(companyId));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }




    @RequestMapping(value = "/queryUserDetail",method = RequestMethod.POST)
    @ApiOperation(value = "公司用户列表，获取用户详情接口",notes = "包括 课程信息",response = User.class)
    @ApiImplicitParam(name = "userId",value = "用户ID",required = true,dataType = "path",paramType = "Integer.class")
    public ViewData queryUserDetail(Integer userId){
        if(CommonUtil.isEmpty(userId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                userService.queryUserDetail(userId));
    }


    @RequestMapping(value = "queryCompanyList",method = RequestMethod.POST)
    @ApiOperation(value = "政府学习中心获取公司列表",response = User.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "searchParams",value = "搜索参数",dataType = "path",paramType = "String.class"),
            @ApiImplicitParam(name = "cityId",value = "城市ID",dataType = "path",paramType = "String.class"),
            @ApiImplicitParam(name = "pageNO",value = "分页参数",required = true,dataType = "path",paramType = "String.class"),
            @ApiImplicitParam(name = "pageSize",value = "分页参数",required = true,dataType = "path",paramType = "String.class")
    })
    public ViewData queryCompanyList(String searchParams,Integer cityId,Integer pageNO,Integer pageSize){
        if(CommonUtil.isEmpty(pageNO,pageSize)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            if(RoleEnum.GOVERNMENT_USER.ordinal() != user.getRoleId()){
                return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    userService.queryUserForGovernment(searchParams,cityId,pageNO,pageSize));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }


    @RequestMapping(value = "/queryUserForAllocation",method = RequestMethod.POST)
    @ApiOperation(value = "公司用户获取公司下的用户列表",notes = "如果是课程分配时 获取用户列表 则 isAllocation 值为  1" +
            "同时 orderId不能为空,,其他情况，此两参数 可为null")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "searchParam",value = "搜索参数",dataType = "path",paramType = "String.class"),
            @ApiImplicitParam(name = "orderId",value = "订单ID",dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "isAllocation",value = "是否是课程分配时获取的用户列表 0:否  1：是",dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "pageNO",value = "分页参数", required = true ,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "pageSize",value = "分页参数", required = true ,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "curriculumId",value = "如果是课程分配时(必选) 将被分配课程的ID" ,dataType = "path",paramType = "Integer.class")
    })
    public ViewData queryUserByCompany(String searchParam,Integer orderId,Integer isAllocation,
                                       Integer pageNO,Integer pageSize,Integer curriculumId){
        if(CommonUtil.isEmpty(pageNO,pageSize)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(null != isAllocation && Common.YES.ordinal() == isAllocation && null == curriculumId){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        try {
            User companyUser = LoginHelper.getCurrentUserOfAPI();
            if(RoleEnum.COMPANY_USER.ordinal() != companyUser.getRoleId()){
                return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    userService.queryUserByCompany(companyUser.getId(),searchParam,
                            isAllocation,orderId,pageNO,pageSize,curriculumId));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }



    @RequestMapping(value = "/addColleague",method = RequestMethod.POST)
    @ApiOperation(value = "添加同事接口",notes = "只有公司用户才能对此操作，并且是游离状态的用户")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "userId",value = "被分配用户的ID",required = true,paramType = "Integer.class",dataType = "path"),
            @ApiImplicitParam(name = "departmentName",value = "部门名称",required = true,paramType = "String.class",dataType = "path"),
            @ApiImplicitParam(name = "jobTitle",value = "职位",required = true,paramType = "String.class",dataType = "path")
    })
    public ViewData addColleague(Integer userId,String departmentName,String jobTitle){

        if(CommonUtil.isEmpty(userId,departmentName,jobTitle)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();

            if(RoleEnum.COMPANY_USER.ordinal() != user.getRoleId()){
                return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
            }
            User temp = userService.queryBaseInfo(userId);
            if(null == temp){
                return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"用户不存在");
            }
            User wait = new User();
            wait.setId(userId);
            wait.setParentId(user.getId());
            wait.setDepartmentName(departmentName);
            wait.setJobTitle(jobTitle);
            wait.setTradeId(user.getTradeId());
            userService.updateUser(wait,null);
            // 更新缓存
            if(null != temp.getToken()){
                User tokenUser = LoginHelper.getCurrentUser(temp.getToken());
                if(null != tokenUser){
                    if(null != departmentName){tokenUser.setDepartmentName(departmentName);}
                    if(null != jobTitle){tokenUser.setJobTitle(jobTitle);}
                    LoginHelper.replaceToken(tokenUser.getToken(),tokenUser);
                }
            }
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }



    @RequestMapping(value = "/queryUserNoCompany",method = RequestMethod.POST)
    @ApiOperation(value = "获取游离状态下的用户")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "searchParam",value = "搜索参数 参数类型：string",paramType = "String.class"),
            @ApiImplicitParam(name = "pageNO",value = "分页参数 参数类型：int",paramType = "Integer.class"),
            @ApiImplicitParam(name = "pageSize",value = "分页参数 参数类型：int",paramType = "Integer.class")
    })
    public ViewData queryUserNoCompany(String searchParam,Integer pageNO,Integer pageSize){
        String phone = null == searchParam ? null : searchParam;
        String pid = null == searchParam ? null : searchParam;
        try {
            User currentUser = LoginHelper.getCurrentUserOfAPI();
            if(RoleEnum.COMPANY_USER.ordinal() != currentUser.getRoleId()){
                return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
            }
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                    userService.queryNoCompanyUser(phone,pid,pageNO,pageSize,currentUser));

        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }

    /**
     *  找回密码 | 修改密码
     *  旧密码 和 手机号 互斥存在
     *  旧密码存在 则 应用内修改密码
     *  手机号存在 则 不知道旧密码|忘记密码 修改密码
     * @param newPwd 新密码
     * @param oldPwd  旧密码
     * @param phone 手机号
     * @return
     */
    @RequestMapping(value = "/setPwd",method = RequestMethod.POST)
    @ApiOperation(notes ="找回密码 | 修改密码,旧密码 和 手机号 互斥存在 手机号存在 则 不知道旧密码|忘记密码 修改密码",
            value = "找回密码 | 修改密码",response = User.class)
   @ApiImplicitParams({ @ApiImplicitParam(name = "newPwd",value = "新密码",required = true,paramType = "int"),
   @ApiImplicitParam(name = "oldPwd",value = "旧密码",paramType = "Integer",dataType = "Integer.class"),
   @ApiImplicitParam(name = "phone",value = "手机号",dataType = "String.class")})
    public ViewData setPwd(String newPwd,String oldPwd,String phone){

        if(CommonUtil.isEmpty(newPwd)){
            return buildFailureJson(StatusConstant.Fail_CODE,"字段不能为空");
        }
        if((CommonUtil.isEmpty(phone) && CommonUtil.isEmpty(oldPwd))
                || (!CommonUtil.isEmpty(phone) && !CommonUtil.isEmpty(oldPwd)) ){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        try {
            User wait = new User();
            if(!CommonUtil.isEmpty(phone)){
                User user = userService.queryUserByPhone(phone);
                if(null == user){
                    return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"手机号不存在");
                }
                wait.setId(user.getId());
                wait.setPwd(newPwd);
            }

            if(!CommonUtil.isEmpty(oldPwd)){
                User user = LoginHelper.getCurrentUserOfAPI();
                User sqlUser = userService.queryBaseInfo(user.getId());
                if(!oldPwd.equals(sqlUser.getPwd())){
                    return buildFailureJson(StatusConstant.Fail_CODE,"原始密码不对");
                }
                if(newPwd.equals(sqlUser.getPwd())){
                    return buildFailureJson(StatusConstant.Fail_CODE,"新密码不能和原始密码一致");
                }
                wait.setId(sqlUser.getId());
                wait.setPwd(newPwd);
            }
            wait.setUpdateTime(new Date());
            userService.updateUser(wait);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"修改成功");
        }catch (InterfaceCommonException e){
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e){
            return buildFailureJson(StatusConstant.Fail_CODE,"修改失败");
        }

    }

    /**
     * 短信发送
     * @param phone
     * @return
     */
    @RequestMapping(value = "/sendMessage",method = RequestMethod.POST)
    @ApiOperation(value = "短信发送接口",response = ViewData.class)
    @ApiImplicitParam(name = "phone",value = "手机号，如果为空,系统自动获取当前登陆人的手机号",paramType = "string",dataType = "String.class")
    public ViewData sendMessage(String phone){
        try {
            if(CommonUtil.isEmpty(phone)){
                phone = LoginHelper.getCurrentUserOfAPI().getPhone();
            }
            String code = SMSCode.createRandomCode();
            boolean b = SMSCode.sendMessage(MessageFormat.format(TextMessage.MSG_CODE, code), phone);
            if(!b){
                return buildFailureJson(StatusConstant.Fail_CODE,"短信发送失败");
            }
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"发送成功",code);
        }catch (InterfaceCommonException e){
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e){
            return buildFailureJson(StatusConstant.Fail_CODE,"短信发送失败");
        }

    }


    /**
     * 短信发送
     * @param phone
     * @return
     */
    @RequestMapping(value = "/sendMessageRegister",method = RequestMethod.POST)
    @ApiOperation(value = "注册时候 短信发送接口",response = ViewData.class)
    @ApiImplicitParam(name = "phone",value = "手机号，如果为空,系统自动获取当前登陆人的手机号", required = true,paramType = "string",dataType = "String.class")
    public ViewData sendMessageRegister(String phone){
        try {
            if(CommonUtil.isEmpty(phone)){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"手机号不能为空");
            }
            String code = SMSCode.createRandomCode();
            User sqlUser = userService.queryBaseUserByPhone(phone);
            if(null != sqlUser && StatusConstant.ACCOUNT_NON_APPROVED.equals(sqlUser.getStatus())
                    && (RoleEnum.COMPANY_USER.ordinal() == sqlUser.getRoleId() ||
                    RoleEnum.GOVERNMENT_USER.ordinal() == sqlUser.getRoleId())){
                boolean b = SMSCode.sendMessage(MessageFormat.format(TextMessage.MSG_CODE, code), phone);
                if(!b){
                    return buildFailureJson(StatusConstant.Fail_CODE,"短信发送失败");
                }
                return buildSuccessJson(StatusConstant.SUCCESS_CODE,"发送成功",code);
            }
            if(null != sqlUser){
                return buildFailureJson(StatusConstant.OBJECT_EXIST,"手机号已经被注册");
            }
            boolean b = SMSCode.sendMessage(MessageFormat.format(TextMessage.MSG_CODE, code), phone);
            if(!b){
                return buildFailureJson(StatusConstant.Fail_CODE,"短信发送失败");
            }
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"发送成功",code);
        }catch (InterfaceCommonException e){
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e){
            return buildFailureJson(StatusConstant.Fail_CODE,"短信发送失败");
        }

    }



    /**
     * 短信发送
     * @param phone
     * @return
     */
    @RequestMapping(value = "/sendMessageForgetPwd",method = RequestMethod.POST)
    @ApiOperation(value = "忘记密码时候 短信发送接口",response = ViewData.class)
    @ApiImplicitParam(name = "phone",value = "手机号", required = true,paramType = "string",dataType = "String.class")
    public ViewData sendMessageForgetPwd(String phone){
        try {
            if(CommonUtil.isEmpty(phone)){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"手机号不能为空");
            }
            String code = SMSCode.createRandomCode();
            User sqlUser = userService.queryBaseUserByPhone(phone);
            if(null == sqlUser){
                return buildFailureJson(StatusConstant.OBJECT_EXIST,"手机号不存在");
            }
            else {
                boolean b = SMSCode.sendMessage(MessageFormat.format(TextMessage.MSG_CODE, code), phone);
                if(!b){
                    return buildFailureJson(StatusConstant.Fail_CODE,"短信发送失败");
                }
                return buildSuccessJson(StatusConstant.SUCCESS_CODE,"发送成功",code);
            }
        }catch (InterfaceCommonException e){
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e){
            return buildFailureJson(StatusConstant.Fail_CODE,"短信发送失败");
        }

    }

    /**
     * 更新用户
     */
    @RequestMapping(value = "/updateUser",method = RequestMethod.POST)
    @ApiOperation(value = "更新用户信息",notes = "以下参数值 不能全部为空",response = ViewData.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "tradeId",value = "行业ID",paramType = "int",dataType = "String.class"),
            @ApiImplicitParam(name = "faceId",value = "FaceId",paramType = "string",dataType = "String.class"),
            @ApiImplicitParam(name = "veriFaceImages",value = "验证成功的人脸图片" +
                    "如果 faceId 不为空，则参数必选",paramType = "string",dataType = "String.class"),
            @ApiImplicitParam(name = "pid",value = "政府：机构代码 企业：营业执照编码",paramType = "string",dataType = "String.class"),
            @ApiImplicitParam(name = "licenseFile",value = "企业：营业执照 政府：介绍信",paramType = "string",dataType = "string"),
            @ApiImplicitParam(name = "showName",value = "名称",paramType = "string",dataType = "String.class"),
            @ApiImplicitParam(name = "introduce",value = "介绍",paramType = "path",dataType = "string"),
            @ApiImplicitParam(name = "avatar",value = "头像URL",paramType = "string",dataType = "String.class"),
            @ApiImplicitParam(name = "cityId",value = "城市ID",paramType = "int",dataType = "Integer.class"),
            @ApiImplicitParam(name = "definition",value = "视频播放清晰度 0：流畅  1：高清",paramType = "int",dataType = "Integer.class")
    })
    public ViewData updateUser(String showName,String avatar,Integer cityId,Integer definition,
                               String faceId,String veriFaceImages,String pid,String licenseFile,
                               Integer tradeId,String introduce){
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            if(CommonUtil.isEmpty(cityId) && CommonUtil.isEmpty(showName) && CommonUtil.isEmpty(avatar)
                    && CommonUtil.isEmpty(definition) && CommonUtil.isEmpty(faceId)
                    && CommonUtil.isEmpty(veriFaceImages) && CommonUtil.isEmpty(pid)
                    && CommonUtil.isEmpty(tradeId) && CommonUtil.isEmpty(cityId)
                    && CommonUtil.isEmpty(licenseFile) && CommonUtil.isEmpty(introduce)){
                return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
            }
            if(!CommonUtil.isEmpty(faceId) && CommonUtil.isEmpty(veriFaceImages)){
                return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
            }
            if(!CommonUtil.isEmpty(veriFaceImages) && CommonUtil.isEmpty(faceId)){
                return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
            }

            if(!CommonUtil.isEmpty(showName) && RoleEnum.COMPANY_USER.ordinal() == user.getRoleId()
                    && !showName.equals(user.getShowName())){
                User exit = userService.queryUserByCompany(showName);
                if(null != exit){
                    return buildFailureJson(StatusConstant.OBJECT_EXIST,"公司名称已经存在");
                }
            }

            User temp = new User();
            temp.setId(user.getId());
            if(!CommonUtil.isEmpty(tradeId)){
                Trade trade = tradeService.queryTradeById(tradeId);
                if(null == trade){
                    return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"行业不存在");
                }
                user.setTradeId(tradeId);
                user.setTradeName(trade.getTradeName());
                temp.setTradeId(tradeId);
            }
            if(!CommonUtil.isEmpty(introduce)){
                user.setIntroduce(introduce);
                temp.setIntroduce(introduce);
            }
            if(!CommonUtil.isEmpty(licenseFile)){
                user.setLicenseFile(licenseFile);
                temp.setLicenseFile(licenseFile);
            }
            if(!CommonUtil.isEmpty(pid)){
                user.setPid(pid);
                temp.setPid(pid);
            }
            if(!CommonUtil.isEmpty(showName)){
                // 把昵称当作 展示名称使用
                user.setShowName(showName);
                temp.setShowName(showName);
            }
            if(!CommonUtil.isEmpty(avatar)){
                user.setAvatar(avatar);
                temp.setAvatar(avatar);
            }
            if(!CommonUtil.isEmpty(definition)){
                user.setDefinition(definition);
                temp.setDefinition(definition);
            }
            if(!CommonUtil.isEmpty(faceId) && !CommonUtil.isEmpty(veriFaceImages)
                    && RoleEnum.USER.ordinal() == user.getRoleId()){
                user.setFaceId(faceId);
                temp.setFaceId(faceId);
                user.setVeriFaceImages(veriFaceImages);
                temp.setVeriFaceImages(veriFaceImages);
            }
            if(!CommonUtil.isEmpty(cityId)){
                City city = cityService.queryCity(cityId);
                if (null == city){
                    return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"城市不存在");
                }
                user.setCityId(cityId);
                user.setCity(city);
                temp.setCityId(cityId);
            }
            temp.setUpdateTime(new Date());
            userService.updateUser(temp);
            // 更新缓存
            LoginHelper.replaceToken(user.getToken(),user);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"更新成功");
    }


    /**
     * 获取个人基本信息
     */
    @RequestMapping(value = "/getInfo",method = RequestMethod.POST)
    @ApiOperation(value = "获取个人基本信息",notes = "请求头带token",response = User.class)
    public ViewData getInfo(){
        User currentUser = LoginHelper.getCurrentUser();
        if(null == currentUser){
            return buildFailureJson(StatusConstant.NOTLOGIN,"未登录");
        }
        if (null != currentUser.getCityId()) {
            City city = cityService.getThreeId(currentUser.getCityId());
            JSONArray jsonArray = new JSONArray();
            jsonArray.add(city.getProvinceId());
            jsonArray.add(city.getTownId());
            jsonArray.add(city.getId());
            currentUser.setCityJsonAry(jsonArray);
        }

        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",currentUser);
    }

    /**
     *  登录
     * @param phone
     * @param password
     * @param deviceType
     * @param deviceToken
     * @param isWechat
     * @return
     */
    @RequestMapping(value = "/login",method = RequestMethod.POST)
    @ApiOperation(value = "用户登录")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "phone",value = "手机号",required = true,paramType = "string",dataType = "String.class"),
            @ApiImplicitParam(name = "password",value = "密码MD5",required = true,paramType = "string",dataType = "String.class"),
            @ApiImplicitParam(name = "deviceType",value = "设备类型 android:0,ios:1,微信端为空",paramType = "int",dataType = "Integer.class"),
            @ApiImplicitParam(name = "deviceToken",value = "设备注册ID",paramType = "string",dataType = "String.class"),
            @ApiImplicitParam(name = "isWechat",value = "除微信端传 1，其他传 0",paramType = "int",dataType = "Integer.class"),
            @ApiImplicitParam(name = "code",value = "验证码",required = true)
    })
    public ViewData login(String phone,String password,Integer deviceType,String deviceToken,
                          Integer isWechat,String code,HttpServletRequest request){

        if(CommonUtil.isEmpty(phone,password,isWechat,code)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            Object o = LoginHelper.get(LoginHelper.KEY_LOGIN + phone);
            if(null == o || !code.equals(o.toString())){
                return buildFailureJson(StatusConstant.Fail_CODE,"验证码无效");
            }
            User user = userService.login(phone, password);
            // 后台|分销商用户不能登录APP
            if(RoleEnum.COMPANY_USER.ordinal() != user.getRoleId() && RoleEnum.USER.ordinal() != user.getRoleId()
                    && RoleEnum.GOVERNMENT_USER.ordinal() != user.getRoleId() ){
                return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
            }
            if(null != user.getToken()){
                LoginHelper.delObject(user.getToken());
            }
            String token = LoginHelper.addToken(user);
            user.setToken(token);

            User temp = new User();
            temp.setId(user.getId());
            temp.setToken(token);
            if(CommonUtil.isEmpty(deviceToken)){
                temp.setDeviceToken(deviceToken);
            }
            if(CommonUtil.isEmpty(deviceType)){
                temp.setDeviceType(deviceType);
            }
            temp.setLastLoginTime(new Date());
            userService.updateUser(temp);
            // 记录日志
            int i = loginLogService.loginLog(request,user,isWechat == 0 ? StatusConstant.LOG_LOGIN_WECHAT : StatusConstant.LOG_LOGIN_APP);
            if(i == 1){
                user.setIsException(1);
            }
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"登录成功",user);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"登录失败");
        }

    }

    /**
     * 注册用户
     * @param user 用户实体
     * @param isWechat 是否是微信客户端
     * @return
     */
    @RequestMapping(value = "/register",method = RequestMethod.POST)
    @ApiOperation(value = "用户注册",notes = "接口参数 暂不描述")
    @ApiImplicitParam(name = "user",value = "用户实体",dataType = "User.class")
    public ViewData register(User user,Integer isWechat){

        if(CommonUtil.isEmpty(user.getPhone(),user.getShowName(),user.getPid(),user.getRoleId(),isWechat)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(RoleEnum.COMPANY_USER.ordinal() == user.getRoleId()){
            user.setStatus(StatusConstant.ACCOUNT_APPROVED_ING);
            if(CommonUtil.isEmpty(user.getLicenseFile(),user.getCityId())){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
        }
        if(RoleEnum.USER.ordinal() == user.getRoleId()){
            user.setStatus(StatusConstant.ACCOUNT_APPROVED);
            if(CommonUtil.isEmpty(user.getVeriFaceImages(),user.getCityId(),user.getFaceId())){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
        }
        if(RoleEnum.GOVERNMENT_USER.ordinal() == user.getRoleId()){
            user.setStatus(StatusConstant.ACCOUNT_APPROVED_ING);
            if(CommonUtil.isEmpty(user.getLicenseFile())){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
        }
        try {
            userService.addUser(user,null).getId();
        }catch (InterfaceCommonException e){
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"新增失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"注册成功");
    }


    /**
     * 退出登录
     * @return
     */
    @RequestMapping(value = "/logout",method = RequestMethod.POST)
    @ApiOperation(value = "退出登录",notes = "请求头带token")
    public ViewData logout(){
        User currentUser = LoginHelper.getCurrentUser();
        if(null != currentUser){
           userService.clearDeviceInfo(currentUser.getId());
            LoginHelper.delObject(currentUser.getToken());
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }

}
