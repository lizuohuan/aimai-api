package com.magic.aimai.controller;

import com.magic.aimai.business.entity.City;
import com.magic.aimai.business.service.CityService;
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
 * 城市 控制器
 * Created by Eric Xie on 2017/7/12 0012.
 */

@RestController
@RequestMapping("/city")
@Api(value = "/city",description = "城市 接口")
public class CityController extends BaseController {

    @Resource
    private CityService cityService;

    /**
     * 通过城市ID 查询 城市下面 该级别的所有城市
     * @param cityId
     * @param levelType  1:省级  2：市级  3：区县级
     * @return
     */
    @RequestMapping(value = "/queryCityByParentId",method = RequestMethod.POST)
    @ApiOperation(value = "通过城市ID 查询 城市下面 该级别的所有城市",response = City.class)
    @ApiImplicitParams({@ApiImplicitParam(name = "cityId",value = "城市ID 参数类型 int",required = false,paramType = "path",dataType = "Integer.class"),
    @ApiImplicitParam(name = "levelType",value = "1:省级  2：市级  3：区县级 参数类型 int",required = true,paramType = "path",dataType = "Integer.class")})
    public ViewData queryCityByParentId(Integer cityId,Integer levelType){
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                cityService.queryCityByParentId(cityId,levelType));
    }


    @RequestMapping(value = "/getCities",method = RequestMethod.POST)
    @ApiOperation(value = "获取全国所有城市",response = City.class)
    public ViewData getCities(){
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                cityService.queryAllCity());
    }

}
