package com.magic.aimai.controller;

import com.magic.aimai.business.entity.News;
import com.magic.aimai.business.enums.Common;
import com.magic.aimai.business.service.NewsService;
import com.magic.aimai.business.util.CommonUtil;
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
 * Created by Eric Xie on 2017/7/21 0021.
 */
@RestController
@RequestMapping("/news")
@Api(value = "资讯接口列表",description = "资讯接口列表")
public class NewsController extends BaseController {


    @Resource
    private NewsService newsService;

    @RequestMapping(value = "/increaseRead",method = RequestMethod.POST)
    @ApiOperation(value = "资讯新增阅读量")
    @ApiImplicitParam(name = "newsId",value = "资讯ID",required = true,dataType = "path",paramType = "Integer.class")
    public ViewData increaseRead(Integer newsId){
        if(CommonUtil.isEmpty(newsId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        News info = newsService.info(newsId);
        if(null == info){
            return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"资讯不存在");
        }
        News news = new News();
        news.setId(info.getId());
        news.setReadNum(null == news.getReadNum() ? 1 : news.getReadNum() + 1);
        newsService.update(news);
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    @RequestMapping(value = "/queryNewsList",method = RequestMethod.POST)
    @ApiOperation(value = "获取资讯列表",response = News.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "pageNO",value = "分页参数",required = true,dataType = "Integer.class"),
            @ApiImplicitParam(name = "pageSize",value = "分页参数",required = true,dataType = "Integer.class"),
            @ApiImplicitParam(name = "searchParam",value = "搜索参数",dataType = "Integer.class"),
            @ApiImplicitParam(name = "cityId",value = "城市ID",dataType = "Integer.class"),
            @ApiImplicitParam(name = "type",value = "新闻类型",dataType = "Integer.class"),
            @ApiImplicitParam(name = "sort",value = "排序 0:热门 1:最新",dataType = "Integer.class")
    })
    public ViewData queryNewsList(Integer pageNO,Integer pageSize,String searchParam,Integer cityId,
                                  Integer type,Integer sort){
        if(CommonUtil.isEmpty(pageNO,pageSize)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                newsService.queryNews(pageNO,pageSize,searchParam,cityId,type,sort));
    }


    @RequestMapping(value = "/info",method = RequestMethod.POST)
    @ApiOperation(value = "获取资讯详情",response = News.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id",value = "资讯id",required = true,dataType = "Integer.class")
    })
    public ViewData info(Integer id){
        if(CommonUtil.isEmpty(id)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                newsService.info(id));
    }


}
