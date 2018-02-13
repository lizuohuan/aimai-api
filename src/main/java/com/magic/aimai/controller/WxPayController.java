package com.magic.aimai.controller;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.net.URLEncoder;
import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.magic.aimai.business.entity.Order;
import com.magic.aimai.business.enums.PayMethodEnum;
import com.magic.aimai.business.exception.InterfaceCommonException;
import com.magic.aimai.business.pay.WXConfig;
import com.magic.aimai.business.service.OrderService;
import com.magic.aimai.business.util.*;
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


/**
 * 微信支付 Controller
 */
@Controller
@RequestMapping("/wxPay")
@Api(value = "微信支付 API")
public class WxPayController extends BaseController {


    @Resource
    private OrderService orderService;

    /**
     * APP 微信签名
     * @param req
     * @param orderId 订单ID
     * @return
     */
    @RequestMapping(value = "/sign",method = RequestMethod.POST)
    @ResponseBody
    @ApiOperation(value = "签名接口",response = ViewData.class)
    @ApiImplicitParam(name = "orderId",value = "订单ID",required = true,paramType = "int",dataType = "Integer.class")
    public ViewData sign(HttpServletRequest req, Integer orderId) {
        if (null == orderId ) {
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL, "字段不能为空");
        }
        try {
            LoginHelper.getCurrentUserOfAPI();
            Order order = orderService.queryBaseOrder(orderId);
            if (null == order) {
                return buildFailureJson(StatusConstant.Fail_CODE, "订单不存在");
            }
            if (!StatusConstant.NO_PAY.equals(order.getPayStatus())) {
                return buildFailureJson(StatusConstant.ORDER_STATUS_ABNORMITY, "订单状态异常");
            }
            Integer total_fee = (int) (order.getPrice() * 100); //支付金额   单位：分
//            Integer total_fee = 1; //支付金额   单位：分
            Map<String, Object> extendsParams = new HashMap<String, Object>();
            extendsParams.put("orderId", orderId);
            String callBack = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + "/api";
            Map<String, Object> map = new TreeMap<String, Object>();
            map.put("appid", WXConfig.APP_ID);
            map.put("mch_id", WXConfig.MCH_ID);
            map.put("attach", JSONObject.fromObject(extendsParams).toString()); // 扩展参数
            map.put("nonce_str", UUID.randomUUID().toString().replaceAll("-", ""));
            map.put("out_trade_no", CommonUtil.buildOrderNumber());
            map.put("body", map.get("out_trade_no"));
            extendsParams.put("out_trade_no",map.get("out_trade_no"));
            map.put("total_fee", total_fee); // 支付金额   单位：分
            map.put("spbill_create_ip", CommonUtil.getIpAddr(req));
            map.put("notify_url", callBack + "/wxPay/wxPayCallBack");
            map.put("trade_type", "APP");
            map.put("attach", JSONObject.fromObject(extendsParams).toString()); // 扩展参数
            String sign = WXUtil.getSign(map, WXConfig.KEY);
            map.put("sign", sign);
            String result = XMLUtil.toXML(map);
            String content = SendRequestUtil.httpPost(WXConfig.SIGN_URL, result);
            Map<String, Object> obj = XMLUtil.decodeXml(content);
            String prepayId = (String) obj.get("prepay_id");
            Map<String, Object> data = new TreeMap<String, Object>();
            data.put("appid", WXConfig.APP_ID);
            data.put("partnerid", WXConfig.MCH_ID);
            data.put("prepayid", prepayId);
            data.put("noncestr", UUID.randomUUID().toString().replaceAll("-", ""));
            data.put("package", "Sign=WXPay");
            data.put("timestamp", String.valueOf(System.currentTimeMillis() / 1000));
            data.put("sign", WXUtil.getSign(data, WXConfig.KEY));
            return buildSuccessJson(StatusConstant.SUCCESS_CODE, "获取成功", data);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(), e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE, "获取签名失败");
        }
    }


    /**
     * 微信支付成功后  回调
     *
     * @return
     */
    @RequestMapping("/wxPayCallBack")
    @ResponseBody
    @ApiOperation(value = "",hidden = true)
    public void wxCallBack(HttpServletRequest request, HttpServletResponse resp) {
        try {
            InputStream is = request.getInputStream();
            ByteArrayOutputStream outSteam = new ByteArrayOutputStream();
            byte[] buffer = new byte[1024];
            int len = 0;
            while ((len = is.read(buffer)) != -1) {
                outSteam.write(buffer, 0, len);
            }
            outSteam.close();
            is.close();
            String result = new String(outSteam.toByteArray());
            Map<String, Object> map = XMLUtil.decodeXml(result);
            if (map.get("result_code").toString().equalsIgnoreCase("SUCCESS")) {
                // 如果返回成功
                JSONObject obj = JSONObject.fromObject(map.get("attach")); //  接收扩展参数
                Integer orderId = obj.getInt("orderId");
                String out_trade_no = obj.getString("out_trade_no");
                Order order = orderService.queryBaseOrder(orderId);
                if (null == order) {
                    return;
                }
                // 微信回调 业务处理
                orderService.paySuccess(order, PayMethodEnum.WeChatPAY.ordinal(),out_trade_no);
                resp.getWriter().print(WXUtil.noticeStr("SUCCESS", ""));
            }
        } catch (Exception e) {
            logger.error("微信回调处理..失败"+e.getMessage(), e);
        }
    }


}
