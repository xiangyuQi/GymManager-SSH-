package com.kzw.comm.vo;

public class Msg {

	private boolean success = true;
	private String text;

	public Msg() {
	}

	public Msg(boolean success, String text) {
		this.success = success;
		this.text = text;
	}

	public Msg(boolean success) {
		this.success = success;
	}

	public boolean isSuccess() {
		return success;
	}

	public void setSuccess(boolean success) {
		this.success = success;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

}
