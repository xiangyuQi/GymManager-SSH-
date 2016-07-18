package com.kzw.core.util;

import java.math.BigDecimal;
import java.util.Calendar;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
/**
 * 
 * @author 
 * 参数转换
 */
public class ParamUtil {
	private static Log logger=LogFactory.getLog(ParamUtil.class);
	
	 public static Object convertObject(String type,String paramValue){
	    	if(StringUtils.isEmpty(paramValue))return null;
	    	Object value=null;
	    	try{
				if("S".equals(type)){//大部的查询都是该类型，所以放至在头部
					value=paramValue;
				}else if("L".equals(type)){
					value=new Long(paramValue);
				}else if("N".equals(type)){
					value=new Integer(paramValue);
				}else if("BD".equals(type)){
					value=new BigDecimal(paramValue);
				}else if("FT".equals(type)){
					value=new Float(paramValue);
				}else if("SN".equals(type)){
					value=new Short(paramValue);
				}else if("D".equals(type)){
					value=DateUtils.parseDate(paramValue,new String[]{"yyyy-MM-dd","yyyy-MM-dd HH:mm:ss"});
				}else if("DL".equals(type)){
					Calendar cal=Calendar.getInstance();
					cal.setTime(DateUtils.parseDate(paramValue,new String[]{"yyyy-MM-dd"}));
					value=DateUtil.setStartDay(cal).getTime();
				}else if("DG".equals(type)){
					Calendar cal=Calendar.getInstance();
					cal.setTime(DateUtils.parseDate(paramValue,new String[]{"yyyy-MM-dd"}));
					value=DateUtil.setEndDay(cal).getTime();
				}else{
					value=paramValue;
				}
			}catch(Exception ex){
				logger.error("the data value is not right for the query filed type:"+ex.getMessage());
			}
			return value;
	    }
}
