package com.magic.aimai.controller;

import com.magic.aimai.business.entity.Collect;
import com.magic.aimai.business.entity.User;
import com.magic.aimai.business.entity.Video;
import com.magic.aimai.business.exception.InterfaceCommonException;
import com.magic.aimai.business.service.CollectService;
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
import org.springframework.web.servlet.View;

import javax.annotation.Resource;

/**
 * 收藏 Controller
 * Created by Eric Xie on 2017/7/14 0014.
 */
@RestController
@RequestMapping("/collect")
@Api(value = "/collect",description = "收藏接口列表，收藏类型： 0:资讯 1:课程 2：考题")
public class CollectController extends BaseController {

    @Resource
    private CollectService collectService;


    /**
     * 通过类型 获取收藏
     * @param type
     * @param pageNO
     * @param pageSize
     * @return
     */
    @RequestMapping(value = "/queryCollect",method = RequestMethod.POST)
    @ApiOperation(value = "通过类型 获取收藏",response = ViewData.class)
    @ApiImplicitParams({@ApiImplicitParam(name = "type",value = "收藏类型 参数类型:int",required = true,paramType = "int",dataType = "Integer.class"),
            @ApiImplicitParam(name = "pageNO",value = "分页参数 参数类型:int",required = true,paramType = "int",dataType = "Integer.class"),
            @ApiImplicitParam(name = "pageSize",value = "分页参数 参数类型:int",required = true,paramType = "int",dataType = "Integer.class")}
    )
    public ViewData queryCollect(Integer type,Integer pageNO,Integer pageSize){
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            if(CommonUtil.isEmpty(type,pageNO,pageSize)){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                    collectService.queryCollectByType(type,user.getId(),pageNO,pageSize));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }


    }


    /**
     * 通过类型 获取收藏
     * @param type
     * @return
     */
    @RequestMapping(value = "/isCollect",method = RequestMethod.POST)
    @ApiOperation(value = "通过类型 获取收藏",response = ViewData.class)
    @ApiImplicitParams(
            {
                    @ApiImplicitParam(name = "type",value = "收藏类型 参数类型:int",required = true,paramType = "int",dataType = "Integer.class"),
                    @ApiImplicitParam(name = "targetId",value = "0:资讯 1:课程 2：考题 参数类型:int",required = true,paramType = "int",dataType = "Integer.class")
            }
    )
    public ViewData isCollect(Integer type,Integer targetId){
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            if(CommonUtil.isEmpty(type,targetId)){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                    collectService.isCollect(user.getId(),type,targetId));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }



    /**
     * 添加收藏
     * @return
     */
    @RequestMapping(value = "/addCollect",method = RequestMethod.POST)
    @ApiOperation(value = "添加收藏")
    @ApiImplicitParams({@ApiImplicitParam(name = "type",value = "收藏类型 参数类型:int",required = true,paramType = "path",dataType = "java.lang.Integer.class"),
    @ApiImplicitParam(name = "targetId",value = "目标ID 参数类型:int",required = true,paramType = "path",dataType = "java.lang.Integer.class"),
    @ApiImplicitParam(name = "collect",value = "不用管此参数",dataType = "Integer.class")})
    public ViewData addCollect(Collect collect){
        try {
            User user =  LoginHelper.getCurrentUserOfAPI();
            if(CommonUtil.isEmpty(collect.getType(),collect.getTargetId())){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            collect.setUserId(user.getId());
            collectService.addCollect(collect);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"收藏失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"收藏成功");
    }

}
