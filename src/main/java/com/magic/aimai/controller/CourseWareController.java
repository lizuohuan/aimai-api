package com.magic.aimai.controller;

import com.magic.aimai.business.entity.CourseWare;
import com.magic.aimai.business.entity.ExaminationList;
import com.magic.aimai.business.entity.User;
import com.magic.aimai.business.exception.InterfaceCommonException;
import com.magic.aimai.business.service.CourseWareService;
import com.magic.aimai.business.util.CommonUtil;
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
 * Created by Eric Xie on 2017/8/1 0001.
 */
@RestController
@RequestMapping("/courseWare")
@Api(value = "课件/课时 接口列表")
public class CourseWareController extends BaseController {


    @Resource
    private CourseWareService courseWareService;



    @RequestMapping(value = "/queryCourseWareError",method = RequestMethod.POST)
    @ApiOperation(value = "学习模块 获取错题库列表",response = ExaminationList.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "orderId",value = "订单ID",required = true,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "pageNO",value = "分页参数",required = true,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "pageSize",value = "分页参数",required = true,dataType = "path",paramType = "Integer.class")
    })

    public ViewData queryCourseWareError(Integer orderId,Integer pageNO,Integer pageSize){
        if(CommonUtil.isEmpty(orderId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    courseWareService.queryCourseWareError(orderId,user.getId(),pageNO,pageSize));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }


    @RequestMapping(value = "/statisticsCourseWare",method = RequestMethod.POST)
    @ApiOperation(value = "学习模块 获取练习题列表",response = ExaminationList.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "orderId",value = "订单ID",required = true,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "pageNO",value = "分页参数",required = true,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "pageSize",value = "分页参数",required = true,dataType = "path",paramType = "Integer.class")
    })

    public ViewData statisticsCourseWare(Integer orderId,Integer pageNO,Integer pageSize){
        if(CommonUtil.isEmpty(orderId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    courseWareService.statisticsCourseWare(orderId,user.getId(),pageNO,pageSize));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }

    }


    @RequestMapping(value = "/queryCourseWare",method = RequestMethod.POST)
    @ApiOperation(value = "通过课程ID/订单Id 获取课件/课时列表",response = CourseWare.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "curriculumId",value = "课程ID 参数类型:int",required = true,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "orderId",value = "订单ID 参数类型:int",required = true,dataType = "path",paramType = "Integer.class")
    })
    public ViewData queryCourseWare(Integer curriculumId,Integer orderId){
        if(CommonUtil.isEmpty(curriculumId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    courseWareService.queryCourseWareByCurriculum(curriculumId,orderId,user.getId()));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }


}
