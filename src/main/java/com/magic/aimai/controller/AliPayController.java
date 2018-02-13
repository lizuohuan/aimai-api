package com.magic.aimai.controller;


import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.domain.AlipayTradeAppPayModel;
import com.alipay.api.request.AlipayTradeAppPayRequest;
import com.alipay.api.response.AlipayTradeAppPayResponse;
import com.magic.aimai.business.entity.Order;
import com.magic.aimai.business.entity.User;
import com.magic.aimai.business.enums.PayMethodEnum;
import com.magic.aimai.business.exception.InterfaceCommonException;
import com.magic.aimai.business.pay.AliPayConfig;
import com.magic.aimai.business.pay.SignUtils;
import com.magic.aimai.business.service.OrderService;
import com.magic.aimai.business.util.LoginHelper;
import com.magic.aimai.business.util.StatusConstant;
import com.magic.aimai.util.ViewData;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiOperation;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.net.URLEncoder;
import java.text.MessageFormat;
import java.util.*;


/**
 *  支付宝 签名 回调接口 控制层
 * @author QimouXie
 *
 */
@Controller
@RequestMapping("/aliPay")
@Api(value = "支付宝 签名 接口列表",description = "支付宝 签名 接口列表")
public class AliPayController extends BaseController {
	
	/**日志类*/
	private Logger logger = Logger.getLogger(AliPayController.class);
	@Resource
	private OrderService orderService;

	
	/**
	 *  支付宝 签名 
	 * @param req
	 * @param orderId 订单ID
	 * @return
	 */
	@RequestMapping(value = "/sign",method = RequestMethod.POST)
	@ResponseBody
	@ApiOperation(value = "支付宝 签名接口",response = ViewData.class)
	@ApiImplicitParam(name = "orderId",value = "订单ID 参数类型 int",required = true,paramType = "path",dataType = "Integer.class")
	public ViewData sign(HttpServletRequest req, Integer orderId){
		if(null == orderId ){
			return buildFailureJson(StatusConstant.FIELD_NOT_NULL, "字段不能为空");
		}
		try {
			User user = LoginHelper.getCurrentUserOfAPI();
			Order order = orderService.queryBaseOrder(orderId);
			if(null == order){
				return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"订单不存在");
			}
			if(!StatusConstant.NO_PAY.equals(order.getPayStatus())){
				return buildFailureJson(StatusConstant.ORDER_STATUS_ABNORMITY,"订单状态异常");
			}

			String subject = "爱麦订单支付";
			String body = "爱麦订单支付";
			Map<String,Object> extendParams = new HashMap<String, Object>();
			String outTradeNo = AliPayConfig.buildNumber();
			extendParams.put("orderId", orderId);
			extendParams.put("out_trade_no",outTradeNo);

			AlipayClient client = new DefaultAlipayClient(AliPayConfig.GATE_WAY_URL, AliPayConfig.APP_ID, AliPayConfig.PRIVATE_KEY_PC,
					"json", AliPayConfig.CHARSET, AliPayConfig.PUBLIC_KEY_PC, AliPayConfig.SIGN_TYPE);

			AlipayTradeAppPayRequest request = new AlipayTradeAppPayRequest();
			AlipayTradeAppPayModel model = new AlipayTradeAppPayModel();
			model.setBody(body);
			model.setSubject(subject);
			model.setOutTradeNo(outTradeNo);
			model.setTimeoutExpress("30m");
			model.setTotalAmount(order.getPrice() + "");
			model.setProductCode("QUICK_MSECURITY_PAY");
			model.setPassbackParams(JSONObject.fromObject(extendParams).toString());

			String localPath = req.getScheme() + "://"+req.getServerName() + ":"+req.getServerPort() + "/api";
			request.setBizModel(model);
			request.setNotifyUrl(localPath+"/aliPay/aliPayCallBack");

			AlipayTradeAppPayResponse response = client.sdkExecute(request);
			return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",response.getBody());
		} catch (InterfaceCommonException e) {
			return buildFailureJson(e.getErrorCode(), e.getMessage());
		}catch (Exception e) {
			logger.error(e.getMessage(),e);
			return buildFailureJson(StatusConstant.Fail_CODE, "获取签名失败");
		}
	}
	
	/**
	 *  AliPay支付成功后 回调接口
	 * @param req
	 * @return
	 */
	@RequestMapping("/aliPayCallBack")
	@ResponseBody
	@ApiOperation(value = "AliPay支付成功 回调接口",hidden = true)
	public void aliPayCallBack(HttpServletRequest req,HttpServletResponse resp){
		try {
			String payStatus = req.getParameter("trade_status");
			if(!"TRADE_SUCCESS".equals(payStatus)){
				return;
			}
			// 获取订单ID
			JSONObject jsonObj = JSONObject.fromObject(req.getParameter("extra_common_param"));

			Integer orderId = jsonObj.getInt("orderId");
			String out_trade_no = req.getParameter("trade_no");
			Order order = orderService.queryBaseOrder(orderId);
			if(null == order){
				return;
			}
			// 支付宝回调 业务处理
			orderService.paySuccess(order, PayMethodEnum.AliPay.ordinal(),out_trade_no);
			resp.getWriter().print("success");
		} catch (Exception e) {
			logger.debug("支付宝回调业务处理失败.........",e);
		}
	}
	

}
