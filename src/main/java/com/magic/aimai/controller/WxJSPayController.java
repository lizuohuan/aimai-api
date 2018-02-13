package com.magic.aimai.controller;

import com.magic.aimai.business.entity.Order;
import com.magic.aimai.business.entity.User;
import com.magic.aimai.business.enums.PayMethodEnum;
import com.magic.aimai.business.exception.InterfaceCommonException;
import com.magic.aimai.business.pay.WXConfig;
import com.magic.aimai.business.pay.WeChatConfig;
import com.magic.aimai.business.service.OrderService;
import com.magic.aimai.business.util.*;
import com.magic.aimai.util.ViewData;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiOperation;
import net.sf.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;
import java.util.UUID;

/**
 * 微信客户端 JSPay 支付 控制器
 * Created by Eric Xie on 2017/3/23 0023.
 */

@Controller
@RequestMapping("/jsPay")
@Api(value = "微信客户端 支付签名接口",description = "仅限微信端使用")
public class WxJSPayController extends BaseController {

    @Resource
    private OrderService orderService;

    /**
     * 微信客户端 订单签名
     * @param req
     * @param orderId 订单ID
     * @return
     */
    @RequestMapping(value = "/sign",method = RequestMethod.POST)
    @ResponseBody
    @ApiOperation(value = "微信客户端 支付签名",response = ViewData.class)
    @ApiImplicitParam(name = "orderId",value = "订单ID",required = true,paramType = "int",dataType = "Integer.class")
    public ViewData signByOrder(HttpServletRequest req, Integer orderId) {
        logger.info("进入 签名接口..........");
        if (null == orderId ) {
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL, "字段不能为空");
        }
        try {
            LoginHelper.getCurrentUserOfAPI();
            Order order = orderService.queryBaseOrder(orderId);
            if (null == order) {
                return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST, "订单不存在");
            }
            if (!StatusConstant.NO_PAY.equals(order.getPayStatus())) {
                return buildFailureJson(StatusConstant.ORDER_STATUS_ABNORMITY, "订单状态异常");
            }
            Integer total_fee = (int) (order.getPrice() * 100);
//            Integer total_fee = 1;
            Map<String, Object> extendsParams = new HashMap<String, Object>();
            extendsParams.put("orderId", orderId);

            String callBack = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + "/api";
            Map<String, Object> map = new TreeMap<String, Object>();
            map.put("appid",  WeChatConfig.getValue("appId"));
            map.put("mch_id",  WeChatConfig.getValue("mchId"));
            map.put("attach", JSONObject.fromObject(extendsParams).toString()); // 扩展参数
            map.put("nonce_str", UUID.randomUUID().toString().replaceAll("-", ""));
            map.put("out_trade_no", CommonUtil.buildOrderNumber());
            map.put("body", map.get("out_trade_no"));
            extendsParams.put("out_trade_no",map.get("out_trade_no"));
            map.put("total_fee", total_fee); // 支付金额   单位：分

            String ipAddr = CommonUtil.getIpAddr(req);
            logger.info("转换前的IP ："+ipAddr);
            if(ipAddr.indexOf(",") >= 0){
                ipAddr = ipAddr.split(",")[0];
            }
            logger.info("转换后的IP ："+ipAddr);
            map.put("spbill_create_ip", ipAddr);
            map.put("notify_url", callBack + "/jsPay/wxPayCallBackApi");
            map.put("trade_type", "JSAPI");
            User wxUser = (User) req.getSession().getAttribute(WeChatConfig.SESSION_WX_USER);
            map.put("openid", wxUser.getOpenId());
            map.put("attach", JSONObject.fromObject(extendsParams).toString()); // 扩展参数
            String sign = WXUtil.getSign(map, (String)WeChatConfig.getValue("payKey"));
            logger.info("微信JS 签名： "+sign);

            map.put("sign", sign);
            logger.info("代签名参数......."+JSONObject.fromObject(map).toString());
            String result = XMLUtil.toXML(map);
            String content = SendRequestUtil.httpPost(WXConfig.SIGN_URL, result);
            logger.info("签名结果: "+content);

            Map<String, Object> obj = XMLUtil.decodeXml(content);

            logger.info("签名结果XML： "+JSONObject.fromObject(obj).toString());
            String prepayId = (String) obj.get("prepay_id");

            Map<String, Object> data = new TreeMap<String, Object>();
            data.put("package", "prepay_id="+prepayId);
            data.put("timeStamp", String.valueOf(System.currentTimeMillis() / 1000));
            data.put("nonceStr", UUID.randomUUID().toString().replaceAll("-", ""));
            data.put("appId",  WeChatConfig.getValue("appId"));
            data.put("signType","MD5");
            data.put("sign", WXUtil.getSign(data, (String)WeChatConfig.getValue("payKey") ));
            return buildSuccessJson(StatusConstant.SUCCESS_CODE, "获取成功", data);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            e.printStackTrace();
            return buildFailureJson(StatusConstant.Fail_CODE, "获取签名失败");
        }
    }


    /**
     * 微信客户端支付成功后  回调
     *
     * @return
     */
    @RequestMapping("/wxPayCallBackApi")
    @ResponseBody
    @ApiOperation(value = "",hidden = true)
    public void wxCallBack(HttpServletRequest request, HttpServletResponse resp) {
        logger.debug("微信客户端回调开始....");
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
            logger.debug("微信客户端回调结果....");
            logger.debug(JSONObject.fromObject(map).toString());
            logger.debug("微信客户端回调结果....");
            if (map.get("result_code").toString().equalsIgnoreCase("SUCCESS")) {
                // 如果返回成功
                JSONObject obj = JSONObject.fromObject(map.get("attach")); //  接收扩展参数
                logger.debug("微信客户端回调结果成功....扩展参数...");
                logger.debug(obj.toString());
                Integer orderId = obj.getInt("orderId");
                String out_trade_no = obj.getString("out_trade_no");
                logger.debug("微信客户端回调结果成功....开始业务处理...");
                Order order = orderService.queryBaseOrder(orderId);
                if (null == order) {
                    return;
                }
                // 微信回调 业务处理
                orderService.paySuccess(order, PayMethodEnum.WeChatClientPay.ordinal(),out_trade_no);
                logger.debug("微信客户端回调结果成功....结束业务处理...");
                resp.getWriter().print(WXUtil.noticeStr("SUCCESS", ""));
            }
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
    }

}
