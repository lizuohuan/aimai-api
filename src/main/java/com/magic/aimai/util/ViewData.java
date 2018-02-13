package com.magic.aimai.util;


import com.alibaba.fastjson.JSON;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.jsonschema.JsonSerializableSchema;
import com.wordnik.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/**
 * Created by flyong86 on 2016/4/6.
 */
@JsonSerialize(include= JsonSerialize.Inclusion.NON_NULL)
@ApiModel
public class ViewData {
    @ApiModelProperty(value = "flag",dataType = "int")
    private Integer flag;
    @ApiModelProperty(value = "状态码")
    private Integer code;
    @ApiModelProperty(value = "返回信息")
    private String msg;
    @ApiModelProperty(value = "返回数据")
    private Object data;

    public ViewData(Integer flag, Integer code, String msg, Object data) {
        this.flag = flag;
        this.code = code;
        this.msg = msg;
        this.data = data;
    }

    public ViewData() {
    }

    public Integer getFlag() {
        return this.flag;
    }

    public void setFlag(Integer flag) {
        this.flag = flag;
    }

    public String getMsg() {
        return this.msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Object getData() {
        return this.data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    public Integer getCode() {
        return this.code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public String toJson() {
        String dataFormat = "{\"flag\":\"${1}\",\"msg\":${2},\"code\":${3},\"data\":${4}}";
        dataFormat = dataFormat.replace("${1}", String.valueOf(this.flag));
        dataFormat = dataFormat.replace("${2}", null == this.msg ? "" : JSON.toJSONString(this.msg));
        dataFormat = dataFormat.replace("${3}", null == this.code ? "" :this.code.toString());
        dataFormat = dataFormat.replace("${4}", null == this.data ?"": JSON.toJSONString(this.data));
        return dataFormat;
    }

    public static enum FlagEnum {
        NORMAL("正常结果"),
        ERROR("错误结果"),
        NEED_LOGIN("未登录"),
        NO_AUTH("无权限");

        private String text;

        private FlagEnum(String text) {
            this.text = text;
        }

        public String getText() {
            return this.text;
        }

        public static FlagEnum parse(int i) {
            return values()[i];
        }
    }

}
