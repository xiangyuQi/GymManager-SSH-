package com.kzw.core.mvc;

import org.apache.commons.beanutils.Converter;
import org.apache.commons.lang3.time.DateUtils;

/**
 * 用于进行Bean的日期属性类型转化
 */
public class BeanDateConnverter implements Converter {
	
	public static final String[] ACCEPT_DATE_FORMATS = { "yyyy-MM-dd HH:mm:ss",
			"yyyy-MM-dd" };

	public BeanDateConnverter() {
	}

	public Object convert(Class arg0, Object value) {
		String dateStr = value.toString();
		dateStr = dateStr.replace("T", " ");
		try {
			return DateUtils.parseDate(dateStr, ACCEPT_DATE_FORMATS);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
}