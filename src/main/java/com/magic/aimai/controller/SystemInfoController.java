package com.magic.aimai.controller;

import com.magic.aimai.business.entity.Suggest;
import com.magic.aimai.business.entity.SystemInfo;
import com.magic.aimai.business.entity.User;
import com.magic.aimai.business.exception.InterfaceCommonException;
import com.magic.aimai.business.service.SystemInfoService;
import com.magic.aimai.business.util.LoginHelper;
import com.magic.aimai.business.util.StatusConstant;
import com.magic.aimai.util.ViewData;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 消息
 * Created by Eric Xie on 2017/7/13 0013.
 */
@RestController
@RequestMapping("/systemInfo")
@Api(value = "消息接口 列表")
public class SystemInfoController extends BaseController {


    @Resource
    private SystemInfoService systemInfoService;




    @RequestMapping(value = "/countCheckInfo",method = RequestMethod.POST)
    @ApiOperation(value = "查看消息是否有未阅读的消息  返回 0 不显示小红点   1 显示小红点")
    public ViewData countCheckInfo(){
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                    systemInfoService.countCheckInfo(user.getId()));
        }catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }


    /**
     * 获取消息列表
     * @param pageNO
     * @param pageSize
     * @return
     */
    @RequestMapping(value = "/getSystemInfo",method = RequestMethod.POST)
    @ApiOperation(value = "获取消息列表",response = SystemInfo.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "pageNO",value = "分页参数",required = true,paramType = "int",dataType = "Integer.class"),
            @ApiImplicitParam(name = "pageSize",value = "分页参数",required = true,paramType = "int",dataType = "Integer.class")
    })
    public ViewData getSystemInfo(Integer pageNO,Integer pageSize){
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                    systemInfoService.queryInfoOfUser(user.getId(),null == pageNO || null == pageSize ? null :
                            (pageNO - 1) * pageSize,pageSize));
        }catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }


    /**
     * 查看系统消息 记录 查看记录
     * @param systemInfoId 消息ID
     * @return
     */
    @RequestMapping(value = "/checkSystemInfo",method = RequestMethod.POST)
    @ApiOperation(value = "查看消息接口",notes = "用户查看消息，记录该消息被查看接口",response = SystemInfo.class)
    @ApiImplicitParam(name = "systemInfoId",value = "消息ID 参数类型:int",required = true,paramType = "Integer",dataType = "Integer.class")
    public ViewData checkSystemInfo(Integer systemInfoId){
        if(null == systemInfoId){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            systemInfoService.addSystemInfoCheck(user.getId(),systemInfoId);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }



}
