package com.magic.aimai.controller;

import com.magic.aimai.business.entity.Suggest;
import com.magic.aimai.business.entity.User;
import com.magic.aimai.business.service.SuggestService;
import com.magic.aimai.business.util.CommonUtil;
import com.magic.aimai.business.util.LoginHelper;
import com.magic.aimai.business.util.StatusConstant;
import com.magic.aimai.util.ViewData;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 意见反馈
 * Created by Eric Xie on 2017/7/13 0013.
 */
@RestController
@RequestMapping("/suggest")
@Api(value = "意见反馈接口列表")
public class SuggestController extends BaseController {

    @Resource
    private SuggestService suggestService;


    /**
     * 提交意见反馈
     * @param content
     * @return
     */
    @RequestMapping(value = "/submitSuggest",method = RequestMethod.POST)
    @ApiOperation(value = "提交意见反馈",response = ViewData.class)
    @ApiImplicitParam(name = "content",value = "反馈内容",required = true,paramType = "path",dataType = "String.class")
    public ViewData addSuggest(String content){
        if(CommonUtil.isEmpty(content)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            Suggest suggest = new Suggest();
            User user = LoginHelper.getCurrentUserOfAPI();
            suggest.setUserId(user.getId());
            suggest.setContent(content);
            suggestService.addSuggest(suggest);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"提交失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"提交成功");
    }

}
