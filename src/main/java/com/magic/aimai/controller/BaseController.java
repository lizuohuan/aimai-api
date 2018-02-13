package com.magic.aimai.controller;

import com.magic.aimai.util.ViewData;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class BaseController {

    protected Logger logger = LoggerFactory.getLogger(getClass());

    protected ViewData buildViewData(ViewData.FlagEnum flag, int code, String message, Object data) {
        ViewData viewData = new ViewData();
        viewData.setFlag(flag.ordinal());
        viewData.setCode(Integer.valueOf(code));
        viewData.setMsg(message);
        viewData.setData(data);
        return viewData;
    }



    protected ViewData buildSuccessJson(int code, String msg, Object data) {
        return buildViewData(ViewData.FlagEnum.NORMAL, code, msg, data);
    }

    public ViewData buildSuccessCodeJson(int code, String msg) {
        return buildSuccessJson(code, msg, (Object)null);
    }

    protected ViewData buildSuccessViewData(int code, String msg, Object data) {
        return buildViewData(ViewData.FlagEnum.NORMAL, code, msg, data);
    }

    protected ViewData buildSuccessCodeViewData(int code, String msg) {
        return buildSuccessViewData(code, msg, (Object) null);
    }

    protected ViewData buildFailureJson(ViewData.FlagEnum flag, int code, String msg) {
        return buildViewData(flag, code, msg, (Object)null);
    }
    protected ViewData buildFailureJson(int code, String msg) {
        return buildViewData(ViewData.FlagEnum.NORMAL, code, msg, (Object)null);
    }

    protected ViewData buildFailureMessage(String msg) {
        return buildFailureJson(202, msg);
    }


    
    
    
}
