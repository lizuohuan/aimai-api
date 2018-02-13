package com.magic.aimai.filter;

import com.magic.aimai.business.cache.MemcachedUtil;
import com.magic.aimai.business.entity.User;
import com.magic.aimai.business.pay.WeChatConfig;
import com.magic.aimai.business.util.CommonUtil;
import com.magic.aimai.business.util.SendRequestUtil;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Eric Xie on 2017/3/21 0021.
 */

@WebFilter("/*")
public class APPFilter implements Filter {


    private Logger logger = Logger.getLogger(this.getClass());

    public void init(FilterConfig filterConfig) throws ServletException {

    }

    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String ua = request.getHeader("user-agent").toLowerCase();

        logger.debug("UA: "+ua);
        if (ua.indexOf("micromessenger") < 0) {// 非微信浏览器不进行请求
            logger.info("进入了非微信浏览器不进行请求.....");
            filterChain.doFilter(servletRequest, servletResponse);
            return;
        }

        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String url = requestURI.substring(contextPath.length());
        List<String> excludePath = new ArrayList<String>();
        excludePath.add("cook");
        for (String exclude : excludePath) {
            if (exclude.contains(url)) {
                filterChain.doFilter(servletRequest, servletResponse);
                return;
            }
        }

        // 不拦截付款回调
        if (url.indexOf("wxPayCallBack") >= 0) {
            logger.info("进入不拦截付款回调.....");
            filterChain.doFilter(servletRequest, servletResponse);
            return;
        }
        // 不拦截付款回调
        if (url.indexOf("wxPayCallBackApi") >= 0) {
            logger.info("进入不拦截付款回调.....");
            filterChain.doFilter(servletRequest, servletResponse);
            return;
        }
        // 不拦截支付宝付款回调
        if (url.indexOf("aliPay") >= 0) {
            logger.info("不拦截支付宝付款回调.....");
            filterChain.doFilter(servletRequest, servletResponse);
            return;
        }

        HttpSession session = request.getSession();
        Object object = session.getAttribute(WeChatConfig.SESSION_WX_USER);
        String code = request.getParameter("code");

//        logger.info("object 对象："+ object);
//        logger.info("code 对象："+ code);

        if (null == object && CommonUtil.isEmpty(code)) {

            // 无微信用户信息, 跳转获取code
            String redirectUrl = request.getRequestURL().toString();
            logger.info("进入无微信用户信息, 跳转获取code.....");
            logger.info("进入无微信用户信息, 跳转获取code  redirectUrl....." + redirectUrl);
//            String redirectUrl = "http://tiger.magic-beans.cn/app/page/index";
            String authUrl = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=" + WeChatConfig.getValue("appId") + "&redirect_uri=" + redirectUrl + "&response_type=code&scope=snsapi_base&state=123#wechat_redirect";
            logger.info("authUrl:       "+authUrl);
            response.sendRedirect(authUrl);
            return;
        } else if (null == object && !CommonUtil.isEmpty(code)) {
            logger.info("进入获取openId.....");
            // 已获取code, 调用获取openid
            String requestUrl = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=" + WeChatConfig.getValue("appId") + "&secret=" + WeChatConfig.getValue("secret") + "&code=" + code + "&grant_type=authorization_code";
            try {
                String resultStr = SendRequestUtil.sendRequest(requestUrl,"GET");
                JSONObject result = JSONObject.fromObject(resultStr);
                logger.info("resultStr:"+resultStr);
                logger.info("result:"+result);
                String openId = result.getString("openid");

                 String accessToken = (String) MemcachedUtil.getInstance().get(WeChatConfig.ACCESS_TOKEN2);
                if (null == accessToken || "".equals(accessToken)) {
                    //获取AccessToken
                    String getAccessTokenUrl = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=" + WeChatConfig.getValue("appId") + "&secret=" + WeChatConfig.getValue("secret");
                    String accessTokenStr = SendRequestUtil.sendRequest(getAccessTokenUrl,"GET");
                    JSONObject accessTokenObj = JSONObject.fromObject(accessTokenStr);
                    logger.info("accessTokenObj:"+accessTokenObj);
                    accessToken = accessTokenObj.getString("access_token");
                    MemcachedUtil.getInstance().add(WeChatConfig.ACCESS_TOKEN2,accessToken,Integer.parseInt(accessTokenObj.getString("expires_in")));
                }
                logger.info("access_token:"+accessToken);

                User wxUser = new User();
                wxUser.setOpenId(openId);
                session.setAttribute(WeChatConfig.SESSION_WX_USER, wxUser);
                logger.info("openId:"+openId);
            }catch (Exception e){
                logger.error("请求appid异常.",e);
            }
        }
        filterChain.doFilter(servletRequest, servletResponse);
    }

    public void destroy() {

    }
}
