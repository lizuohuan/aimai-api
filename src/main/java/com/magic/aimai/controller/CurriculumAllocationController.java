package com.magic.aimai.controller;

import com.magic.aimai.business.entity.CurriculumAllocation;
import com.magic.aimai.business.entity.Order;
import com.magic.aimai.business.entity.User;
import com.magic.aimai.business.exception.InterfaceCommonException;
import com.magic.aimai.business.service.CurriculumAllocationService;
import com.magic.aimai.business.service.OrderService;
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
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * 课程分配
 * Created by Eric Xie on 2017/7/14 0014.
 */
@RestController
@RequestMapping("/allocation")
@Api(value = "/allocation",description = "课程分配接口")
public class CurriculumAllocationController extends BaseController {


    @Resource
    private CurriculumAllocationService curriculumAllocationService;
    @Resource
    private OrderService orderService;


    @RequestMapping(value = "/batchAddAllocation",method = RequestMethod.POST)
    @ApiOperation(value = "给用户批量分配课程",response = ViewData.class)
    @ApiImplicitParams({@ApiImplicitParam(name = "userId",value = "用户ID  类型:int",paramType = "path",required = true,dataType = "Integer.class"),
    @ApiImplicitParam(name = "curriculumIds",value = "课程ID集合 逗号隔开 类型:string",paramType = "path",required = true,dataType = "String.class"),
            @ApiImplicitParam(name = "number",value = "分配的数量 一期功能 默认传 1 类型:int",paramType = "path",required = true,dataType = "Integer.class")})
    public ViewData batchAddAllocation(String curriculumIds,Integer userId,Integer number){
        if(CommonUtil.isEmpty(curriculumIds,userId,number)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            String[] split = curriculumIds.split(","); // 课程ID
            List<CurriculumAllocation> allocations = new ArrayList<CurriculumAllocation>();
            for (int i = 0; i < split.length; i++) {
                // 查询该公司用户下的所有订单，按创建时间排序出来，取第一条来扣除订单数量
                List<Order> orders = orderService.queryOrderByCompany(user.getId(), Integer.valueOf(split[i]));
                CurriculumAllocation allocation = new CurriculumAllocation();
                for (Order order : orders) {
                    if(order.getSurplusNumber() >= number){
                        order.setSurplusNumber(order.getSurplusNumber() - number);
                        allocation.setOrderId(order.getId());
                        break;
                    }
                }
                if(null == allocation.getOrderId()){
                    throw new InterfaceCommonException(StatusConstant.Fail_CODE,"剩余可分配数量不足");
                }
                allocation.setNumber(number);
                allocation.setUserId(userId);
                allocations.add(allocation);
            }
            if(allocations.size() > 0){
                curriculumAllocationService.addAllocation(allocations);
            }
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"分配成功");
    }


    /**
     * 分配课程
     * @param userIds 用户ID集合 逗号隔开
     * @param curriculumId 订单ID
     * @param number 分配的数量 一期功能 为 1
     * @return
     */
    @RequestMapping(value = "/addAllocation",method = RequestMethod.POST)
    @ApiOperation(value = "分配课程",response = ViewData.class)
    @ApiImplicitParams({@ApiImplicitParam(name = "userIds",value = "用户ID集合 逗号隔开 类型:string",paramType = "path",required = true,dataType = "String.class"),
    @ApiImplicitParam(name = "curriculumId",value = "课程ID 类型:int",paramType = "path",required = true,dataType = "Integer.class"),
            @ApiImplicitParam(name = "number",value = "分配的数量 一期功能 默认传 1 类型:int",paramType = "path",required = true,dataType = "Integer.class")})
    public ViewData addAllocation(String userIds,Integer curriculumId,Integer number){
        if(CommonUtil.isEmpty(userIds,curriculumId,number)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();

            // 查询该公司用户下的所有订单，按创建时间排序出来，取第一条来扣除订单数量
            List<Order> orders = orderService.queryOrderByCompany(user.getId(), curriculumId);

            if(null == orders || orders.size() == 0){
                throw new InterfaceCommonException(StatusConstant.Fail_CODE,"剩余可分配数量不足");
            }
            Set<Integer> orderIds = new HashSet<Integer>();
            String[] split = userIds.split(",");
            List<CurriculumAllocation> allocations = new ArrayList<CurriculumAllocation>();
            for (int i = 0; i < split.length; i++) {
                CurriculumAllocation allocation = new CurriculumAllocation();
                for (Order order : orders) {
                    if(order.getSurplusNumber() >= number){
                        allocation.setOrderId(order.getId());
                        order.setSurplusNumber(order.getSurplusNumber() - number);
                        orderIds.add(order.getId());
                        break;
                    }
                }
                if(null == allocation.getOrderId()){
                    throw new InterfaceCommonException(StatusConstant.Fail_CODE,"剩余可分配数量不足");
                }
                allocation.setNumber(number);
                allocation.setUserId(Integer.valueOf(split[i]));
                allocations.add(allocation);
            }
            if(allocations.size() > 0){
                curriculumAllocationService.addAllocation(allocations,orderIds);
            }
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"分配成功");
    }


}
