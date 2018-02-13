package com.magic.aimai.controller;

import com.magic.aimai.business.entity.Examination;
import com.magic.aimai.business.entity.User;
import com.magic.aimai.business.exception.InterfaceCommonException;
import com.magic.aimai.business.service.ExaminationService;
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
import java.util.List;

/**
 * Created by Eric Xie on 2017/8/2 0002.
 */

@RestController
@RequestMapping("/examination")
@Api(value = "试题相关接口")
public class ExaminationController extends BaseController {

    @Resource
    private ExaminationService examinationService;


    @RequestMapping(value = "/queryExaminationKey",method = RequestMethod.POST)
    @ApiOperation(value = "通过题目的ID集合查询题解",response = Examination.class)
    @ApiImplicitParam(name = "ids",value = "试题ID集合 参数事例：[1,2,3]",required = true,dataType = "path",paramType = "Integer.class")
    public ViewData queryErrorExaminationKey(String ids){
        if(CommonUtil.isEmpty(ids)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            JSONArray jsonArray = JSONArray.fromObject(ids);
            List<Integer> idsArr = JSONArray.toList(jsonArray,Integer.class);
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    examinationService.queryErrorExaminationByIds(idsArr));
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }


    @RequestMapping(value = "/queryErrorExamination",method = RequestMethod.POST)
    @ApiOperation(value = "获取错题集",notes = "只有入口为没有错题ID集合的情况下调用",response = Examination.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "orderId",required = true,value = "订单ID",dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "courseWareId",required = true,value = "课时ID",dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "pageNO",required = true,value = "分页参数",dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "pageSize",required = true,value = "分页参数",dataType = "path",paramType = "Integer.class")
    })
    public ViewData queryErrorExamination(Integer orderId,Integer courseWareId,Integer pageNO,Integer pageSize){
        if(CommonUtil.isEmpty(orderId,courseWareId,pageNO,pageSize)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    examinationService.queryErrorExamination(user.getId(),orderId,courseWareId,pageNO,pageSize));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }



}
