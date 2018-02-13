package com.magic.aimai.controller;

import com.magic.aimai.business.entity.Curriculum;
import com.magic.aimai.business.entity.Order;
import com.magic.aimai.business.entity.User;
import com.magic.aimai.business.enums.Common;
import com.magic.aimai.business.enums.PayMethodEnum;
import com.magic.aimai.business.enums.RoleEnum;
import com.magic.aimai.business.exception.InterfaceCommonException;
import com.magic.aimai.business.service.CurriculumService;
import com.magic.aimai.business.service.OperationLogService;
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

/**
 * Order Controller
 * Created by Eric Xie on 2017/7/14 0014.
 */
@RestController
@RequestMapping("/order")
@Api(value = "/order",description = "订单相关接口文档")
public class OrderController extends BaseController {

    @Resource
    private OrderService orderService;
    @Resource
    private CurriculumService curriculumService;
    @Resource
    private OperationLogService operationLogService;


    /**
     * 获取订单
     * @param payStatus 订单状态
     * @param pageNO 页码
     * @param pageSize 页码
     * @return
     */
    @RequestMapping(value = "/queryOrder",method = RequestMethod.POST)
    @ApiOperation(value = "获取订单列表",notes = "支付状态：0:未支付  1:已支付",response = Order.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "payStatus",value = "支付状态,如果不传则查询全部 参数类型:int",paramType = "int"),
            @ApiImplicitParam(name = "pageNO",value = "页码 参数类型:int",paramType = "int"),
            @ApiImplicitParam(name = "pageSize",value = "页码 参数类型:int",paramType = "int")
    })
    public ViewData queryOrder(Integer payStatus,Integer pageNO,Integer pageSize){

        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            if(CommonUtil.isEmpty(pageNO,pageSize)){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    orderService.queryOrderByItems(user.getId(),payStatus,pageNO,pageSize));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }

    }


    /**
     * 删除订单  (逻辑删除)
     * @param orderId 订单ID
     * @return
     */
    @RequestMapping(value = "/delOrder",method = RequestMethod.POST)
    @ApiOperation(value = "用户删除订单",response = ViewData.class)
    @ApiImplicitParam(name = "orderId",value = "订单ID,参数类型:int",required = true,paramType = "int")
    public ViewData delOrder(Integer orderId){
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            if(null == orderId){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            Order order = orderService.queryBaseOrder(orderId);
            if(null == order){
                return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"订单不存在");
            }
            Order temp = new Order();
            temp.setId(orderId);
            temp.setUserIsValid(Common.NO.ordinal());
            orderService.updateOrder(temp);
            // 订单删除结束

            //操作日志
            operationLogService.save2(user.getId(),user.getRoleId(),"删除了订单");
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"删除成功");
    }


    /**
     * 新增订单
     * @param curriculumId
     * @param number
     * @return
     */
    @RequestMapping(value = "/addOrder",method = RequestMethod.POST)
    @ApiOperation(value = "创建订单",response = ViewData.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "curriculumId",value = "课程ID 参数类型:int",required = true,paramType = "int"),
            @ApiImplicitParam(name = "number",value = "购买数量 参数类型:int",required = true,paramType = "int")
    })
    public ViewData addOrder(Integer curriculumId,Integer number ,Integer deviceType){
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            if(CommonUtil.isEmpty(curriculumId,number) || 0 == number ){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            /*if(RoleEnum.USER.ordinal() == user.getRoleId() && number > 1){
                // 如果是普通用户，职能购买一份
                return buildFailureJson(StatusConstant.Fail_CODE,"当前用户只能购买一份");
            }
*/
            Curriculum curriculum = curriculumService.queryBaseInfo(curriculumId);
            if(null == curriculum){
                return buildFailureJson(StatusConstant.OBJECT_EXIST,"课程不存在");
            }
            /*if (user.getRoleId().equals(RoleEnum.USER.ordinal()) && curriculumService.isBuy(user.getId(),curriculumId) > 0) {
                return buildFailureJson(StatusConstant.Fail_CODE,"对不起，您已购买过此课程，请不要重复购买");
            }*/
            Order order = new Order();
            order.setUserId(user.getId());
            order.setCreateUserId(user.getId());
            order.setCurriculumId(curriculumId);
            order.setNumber(number);
            order.setPayStatus(Common.NO.ordinal());
            order.setPrice(curriculum.getPrice() * number);
            order.setOrderNumber(CommonUtil.buildOrderNumber());
            order.setPayStatus(StatusConstant.NO_PAY);
            int orderId = orderService.addOrder(order);
            if( 0 == curriculum.getPrice()){
                orderService.paySuccess(order, PayMethodEnum.WeChatPAY.ordinal(),"00000000000000");
            }
            if (null != deviceType && deviceType == 1 && null != user.getPhone() && user.getPhone().equals("18380479400")) {
                orderService.paySuccess(order, PayMethodEnum.WeChatPAY.ordinal(),"00000000000000");
            }
            //新增完成

            //操作日志
            operationLogService.save2(user.getId(),user.getRoleId(),"创建了订单");
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"订单创建成功",orderId);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }

    }


}
