package com.kzw.core.json;

import java.text.SimpleDateFormat;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.ser.FilterProvider;
import com.fasterxml.jackson.databind.ser.impl.SimpleBeanPropertyFilter;
import com.fasterxml.jackson.databind.ser.impl.SimpleFilterProvider;

public class Jackson {

	private ObjectMapper objectMapper;
	private SimpleFilterProvider filterProvider = new SimpleFilterProvider();
	private int index = 0;

	public static Jackson me() {
		return new Jackson();
	}

	private Jackson() {
		objectMapper = new ObjectMapper();
		// 设置输入时忽略在JSON字符串中存在但Java对象实际没有的属性
		objectMapper.disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);
		objectMapper.configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
		objectMapper.setDateFormat(new SimpleDateFormat("yyyy-MM-dd"));
	}

	/**
	 * 过滤
	 * */
	public Jackson filter(String filterName, String... properties) {
		FilterProvider filterProvider = new SimpleFilterProvider().addFilter(
				filterName,
				SimpleBeanPropertyFilter.serializeAllExcept(properties));
		objectMapper.setFilterProvider(filterProvider);
		return this;
	}

	/**
	 * 只输出指定属性
	 * */
	public Jackson with(Class<?> target, String... properties) {
		objectMapper.addMixIn(target, Mixin.all.get(index));
		filterProvider.addFilter("filter" + index,
				SimpleBeanPropertyFilter.filterOutAllExcept(properties));
		index++;
		
		objectMapper.setFilterProvider(filterProvider);
		return this;
	}
	
	/**
	 * 不输出指定属性
	 * */
	public Jackson without(Class<?> target, String... properties) {
		objectMapper.addMixIn(target, Mixin.all.get(index));
		filterProvider.addFilter("filter" + index,
				SimpleBeanPropertyFilter.serializeAllExcept(properties));
		index++;
		
		objectMapper.setFilterProvider(filterProvider);
		return this;
	}

	public Jackson setDateFormate(String dateFormat) {
		objectMapper.setDateFormat(new SimpleDateFormat(dateFormat));
		return this;
	}

	public <T> T fromJson(String json, Class<T> clazz) {
		try {
			return objectMapper.readValue(json, clazz);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("解析json错误");
		}
	}

	public String toJson(Object obj) {
		try {
			return objectMapper.writeValueAsString(obj);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("解析对象错误");
		}
	}

	public ObjectMapper getMapper() {
		return objectMapper;
	}

}
