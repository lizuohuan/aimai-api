package com.magic.aimai.controller;


import com.magic.aimai.business.entity.Curriculum;
import com.magic.aimai.business.service.ContentService;
import com.magic.aimai.business.util.StatusConstant;
import com.magic.aimai.util.ViewData;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 公司内容管理
 * @author lzh
 * @create 2017/8/3 21:29
 */
@RestController
@RequestMapping("/content")
public class ContentController extends BaseController {

    @Resource
    private ContentService contentService;

    /**
     * 安培公司信息详情
     * @return
     */
    @RequestMapping(value = "/info",method = RequestMethod.POST)
    @ApiOperation(value = "课程首页列表获取",response = Curriculum.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id",value = "公司内容详情 1：关于我们 2：资质 3：平台 4：安巡 参数类型:int",paramType = "int" ,required = true,dataType = "Integer.class")
    })
    public ViewData info(Integer id) {
        try {
            if (null == id) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",contentService.info(id));
        } catch (Exception e) {
            e.printStackTrace();
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新失败");
        }
    }
}
