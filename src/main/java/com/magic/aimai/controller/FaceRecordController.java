package com.magic.aimai.controller;

import com.magic.aimai.business.entity.FaceRecord;
import com.magic.aimai.business.entity.User;
import com.magic.aimai.business.exception.InterfaceCommonException;
import com.magic.aimai.business.service.FaceRecordService;
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
 * Created by Eric Xie on 2017/7/25 0025.
 */
@RestController
@RequestMapping("/faceRecord")
@Api(value = "人脸验证记录接口")
public class FaceRecordController extends BaseController {


    @Resource
    private FaceRecordService faceRecordService;


    @RequestMapping(value = "/addRecord",method = RequestMethod.POST)
    @ApiOperation(value = "新增人脸验证记录",notes = "当前版本只记录验证成功记录，故 参数 status 固定为  1",response = ViewData.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "videoId",value = "视频ID",required = true,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "orderId",value = "订单ID",required = true,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "status",value = "状态，固定传值  1",required = true,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "videoSecond",value = "视频播放的当前时间，单位:秒",required = true,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "faceImage",value = "验证成功的人脸图片",required = true,dataType = "path",paramType = "String.class")
    })
    public ViewData addRecord(Integer videoId,Integer status,String faceImage,Integer videoSecond,Integer orderId){
        if(CommonUtil.isEmpty(videoId,status,faceImage,videoSecond,orderId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            FaceRecord record = new FaceRecord();
            record.setStatus(status);
            record.setUserId(user.getId());
            record.setFaceImage(faceImage);
            record.setOrderId(orderId);
            record.setVideoId(videoId);
            record.setVideoSecond(videoSecond);
            faceRecordService.addFaceRecord(record);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }



    @RequestMapping(value = "/queryFaceRecord",method = RequestMethod.POST)
    @ApiOperation(value = "通过视频ID获取人脸验证记录",notes = "当前版本只获取验证成功的人脸验证记录",response = FaceRecord.class)
    @ApiImplicitParam(name = "videoId",value = "视频ID",required = true,dataType = "path",paramType = "Integer.class")
    public ViewData queryFaceRecord(Integer videoId,Integer orderId){
        if(CommonUtil.isEmpty(videoId,orderId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    faceRecordService.queryFaceRecord(user.getId(),videoId,1,orderId));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }



}
