package com.kzw.core.util;

import java.util.List;

public class ObjectJson {

	private Boolean success = true;
	private Object data;
	private List result;
	
	public ObjectJson(Object bean) {
		if (bean instanceof List) {
			this.result = (List) bean;
		} else
			this.data = bean;
	}
	
	public List getResult() {
		return result;
	}

	public void setResult(List result) {
		this.result = result;
	}

	public Boolean getSuccess() {
		return success;
	}
	public void setSuccess(Boolean success) {
		this.success = success;
	}
	public Object getData() {
		return data;
	}
	public void setData(Object data) {
		this.data = data;
	}
}
