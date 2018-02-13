package com.magic.aimai.controller;

import com.magic.aimai.business.entity.Evaluate;
import com.magic.aimai.business.entity.User;
import com.magic.aimai.business.exception.InterfaceCommonException;
import com.magic.aimai.business.service.EvaluateService;
import com.magic.aimai.business.service.ForbiddenWordsService;
import com.magic.aimai.business.util.CommonUtil;
import com.magic.aimai.business.util.LoginHelper;
import com.magic.aimai.business.util.StatusConstant;
import com.magic.aimai.util.ViewData;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.Date;

/**
 * 评价 Controller
 * Created by Eric Xie on 2017/7/17 0017.
 */
@RestController
@RequestMapping(value = "/evaluate")
@Api(value = "评价API",description = "评价API",consumes = "application/json", produces = "application/json")

public class EvaluateController extends BaseController {

    @Resource
    private EvaluateService evaluateService;
    @Resource
    private ForbiddenWordsService forbiddenWordsService;


    /**
     * 获取 评价列表
     * @param pageNO 页码
     * @param pageSize 数量
     * @return
     */
    @RequestMapping(value = "/queryEvaluate",method = RequestMethod.POST)
    @ApiOperation(value = "获取评价列表",notes = "获取评价列表接口",response = Evaluate.class)
    @ApiImplicitParams({@ApiImplicitParam(name = "curriculumId",value = "课程ID",required = true,dataType = "Integer.class"),
    @ApiImplicitParam(name = "pageNO",value = "页码",required = true,dataType = "Integer.class"),
    @ApiImplicitParam(name = "pageSize",value = "每页显示数量",required = true,dataType = "Integer.class")})
    public @ResponseBody ViewData queryEvaluate(@RequestParam("pageNO") Integer pageNO,
                           @RequestParam("pageSize") Integer pageSize,
                           @RequestParam("curriculumId") Integer curriculumId){
        if(CommonUtil.isEmpty(pageNO,pageSize,curriculumId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        User currentUser = LoginHelper.getCurrentUser();
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                evaluateService.queryEvaluate(null == currentUser ? null : currentUser.getId(),
                        pageNO,pageSize,curriculumId));
    }


    /**
     * 发表评论
     * @param content 评论内容
     * @return
     */
    @RequestMapping(value = "/addEvaluate",method = RequestMethod.POST)
    @ApiOperation(value = "发表评论",response = ViewData.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "content",value = "评论内容 最大长度 255 参数:string",required = true,paramType = "path",dataType = "String.class"),
            @ApiImplicitParam(name = "curriculumId",value = "课程ID 参数类型:int",required = true,paramType = "path",dataType = "Integer.class")
    })
    public ViewData addEvaluate(String content,Integer curriculumId){
        if(CommonUtil.isEmpty(content,curriculumId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }

        if(forbiddenWordsService.judgeWord(content)){
            return buildFailureJson(StatusConstant.Fail_CODE,"内容包含敏感词");
        }

        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            Evaluate evaluate = new Evaluate();
            evaluate.setUserId(user.getId());
            evaluate.setContent(content);
            evaluate.setCurriculumId(curriculumId);
            evaluate.setCreateTime(new Date());
            evaluateService.addEvaluate(evaluate);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


}
