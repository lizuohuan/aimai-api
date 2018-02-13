package com.magic.aimai.controller;

import com.magic.aimai.business.entity.Paper;
import com.magic.aimai.business.entity.PaperRecord;
import com.magic.aimai.business.entity.User;
import com.magic.aimai.business.enums.Common;
import com.magic.aimai.business.enums.PaperEnum;
import com.magic.aimai.business.exception.InterfaceCommonException;
import com.magic.aimai.business.service.PaperService;
import com.magic.aimai.business.util.CommonUtil;
import com.magic.aimai.business.util.LoginHelper;
import com.magic.aimai.business.util.StatusConstant;
import com.magic.aimai.util.ViewData;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import net.sf.json.JSONArray;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * Created by Eric Xie on 2017/7/27 0027.
 */
@RestController
@RequestMapping("/paper")
@Api(value = "试卷 API列表")
public class PaperController extends BaseController {

    @Resource
    private PaperService paperService;



    @RequestMapping(value = "/queryPaperRecord",method = RequestMethod.POST)
    @ApiOperation(value = "本人获取考试成绩记录",response = PaperRecord.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "orderId",value = "订单ID",required = true,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "paperId",value = "试卷ID",required = true,dataType = "path",paramType = "Integer.class")
    })
    public ViewData queryPaperRecord(Integer orderId,Integer paperId){
        if(CommonUtil.isEmpty(orderId,paperId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    paperService.queryPaperRecord(user.getId(),orderId,paperId));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }


    @RequestMapping(value = "/queryPaperById",method = RequestMethod.POST)
    @ApiOperation(value = "通过试卷ID 获取试卷试题")
    @ApiImplicitParam(name = "paperId",value = "试卷ID",required = true)
    public ViewData queryPaperById(Integer paperId){
        if(CommonUtil.isEmpty(paperId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        Paper data = paperService.queryPaperById(paperId);
        if(null == data){
            return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"试题不存在");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                data.getExaminationList());
    }


    @RequestMapping(value = "/submitPaper",method = RequestMethod.POST)
    @ApiOperation(value = "提交试卷")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "answers",value = "答案集合，格式如下 : [ { \"examinationId\":1,  \"answers\":[1,2]},{ \"examinationId\":2,\"answers\":[1] }]" +
                    "   其中examinationId:试题ID，answers:选择的答案集合,列表的ID集合",required = true,dataType = "path",paramType = "String.class"),
            @ApiImplicitParam(name = "paperId",value = "试卷ID",required = true,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "orderId",value = "订单ID",required = true,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "seconds",value = "用时(单位:秒)",required = true,dataType = "path",paramType = "Integer.class")
    })
    public ViewData submitPaper(String answers,Integer paperId,Integer orderId,Integer seconds){
        if(CommonUtil.isEmpty(answers,paperId,orderId,seconds)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"提交成功",
                    paperService.submitPaper(JSONArray.fromObject(answers),paperId,orderId,user,seconds));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"提交失败");
        }
    }


    @RequestMapping(value = "/queryPager",method = RequestMethod.POST)
    @ApiOperation(value = "获取试卷列表",notes = "视频播放完，获取试卷",response = Paper.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "targetId",value = "目标ID，如果获取练习试卷 则是 课时 ID" +
                    "如果获取 模拟题 或者 考试题 则是 课程ID",required = true,paramType = "Integer.class",dataType = "path"),
            @ApiImplicitParam(name = "type",value = "0：练习题  1：模拟题 2：考试题，其他参数无效",required = true,paramType = "Integer.class",dataType = "path")
    })
    public ViewData queryPager(Integer targetId,Integer type){
        if(CommonUtil.isEmpty(targetId,type)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(PaperEnum.Exercises.ordinal() != type && PaperEnum.ExaminationQuestion.ordinal() != type &&
                PaperEnum.SimulationExercise.ordinal() != type ){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        try {
            LoginHelper.getCurrentUserOfAPI();
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    paperService.queryPaperByItems(targetId,type));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }


}
