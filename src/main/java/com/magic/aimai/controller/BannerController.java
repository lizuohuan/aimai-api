package com.magic.aimai.controller;

import com.magic.aimai.business.entity.Banner;
import com.magic.aimai.business.service.BannerService;
import com.magic.aimai.business.util.CommonUtil;
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
 * Created by Eric Xie on 2017/7/24 0024.
 */
@RestController
@RequestMapping("/banner")
@Api(value = "Banner API列表")
public class BannerController extends BaseController {

    @Resource
    private BannerService bannerService;


    @RequestMapping(value = "/queryBannerList",method = RequestMethod.POST)
    @ApiOperation(value = "获取banner列表",response = ViewData.class)
    public ViewData queryBannerList(){
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                bannerService.queryBannerList(1));
    }


    @RequestMapping(value = "/queryBannerById",method = RequestMethod.POST)
    @ApiOperation(value = "通过ID 获取banner详情",response = Banner.class)
    @ApiImplicitParam(name = "bannerId",value = "Banner ID",dataType = "Integer.class",paramType = "path")
    public ViewData queryBannerById(Integer bannerId){
        if(CommonUtil.isEmpty(bannerId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                bannerService.queryBannerById(bannerId));
    }


}
