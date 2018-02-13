package com.magic.aimai.controller;

import com.magic.aimai.business.entity.User;
import com.magic.aimai.business.entity.VideoStatus;
import com.magic.aimai.business.exception.InterfaceCommonException;
import com.magic.aimai.business.service.VideoStatusService;
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
import java.util.Map;

/**
 * 视频播放状态 记录
 * Created by Eric Xie on 2017/7/17 0017.
 */
@RestController
@RequestMapping("/videoStatus")
@Api(value = "视频播放状态 记录")
public class VideoStatusController extends BaseController {

    @Resource
    private VideoStatusService videoStatusService;

    /**
     * 新增 播放记录
     * @param videoId 视频ID
     * @param status 播放状态 0:开始播放  1:其他异常状态暂停 2:播放完成
     * @param seconds 播放截至的时间   单位:秒
     * @return
     */
    @RequestMapping(value = "/addVideoStatus",method = RequestMethod.POST)
    @ApiOperation(value = "新增 播放记录")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "videoId",value = "视频ID",required = true,paramType = "int",dataType = "Integer.class"),
            @ApiImplicitParam(name = "orderId",value = "订单ID",required = true,paramType = "int",dataType = "Integer.class"),
            @ApiImplicitParam(name = "status",value = "播放状态 0:开始播放  1:其他异常状态暂停 2:播放完成",required = true,paramType = "int",dataType = "Integer.class"),
            @ApiImplicitParam(name = "seconds",value = "播放截至的时间   单位:秒",required = true,paramType = "int",dataType = "Integer.class")
    })
    public ViewData addVideoStatus(Integer videoId,Integer status,Integer seconds,Integer orderId){
        if(CommonUtil.isEmpty(videoId,status,seconds,orderId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            VideoStatus videoStatus = new VideoStatus();
            videoStatus.setUserId(user.getId());
            videoStatus.setSeconds(seconds);
            videoStatus.setOrderId(orderId);
            videoStatus.setStatus(status);
            videoStatus.setVideoId(videoId);
            Map<String, Object> result = videoStatusService.addVideoStatus(videoStatus);
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",result);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }

    }



    /**
     * 获取 最近的播放记录
     * @param videoId 视频ID
     * @return
     */
    @RequestMapping(value = "/queryNewVideoStatus",method = RequestMethod.POST)
    @ApiOperation(value = "获取 视频的播放记录",notes = "通过视频ID 获取该视频上一次的播放记录",response = VideoStatus.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "videoId",value = "视频ID 参数类型:int",required = true,paramType = "int",dataType = "Integer.class"),
            @ApiImplicitParam(name = "orderId",value = "订单ID 参数类型:int",required = true,paramType = "int",dataType = "Integer.class")
    })
    public ViewData queryNewVideoStatus(Integer videoId,Integer orderId){
        if(CommonUtil.isEmpty(videoId,orderId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                    videoStatusService.queryNewVideoStatus(user.getId(),videoId,orderId));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }
}
