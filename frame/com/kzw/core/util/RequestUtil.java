package com.kzw.core.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.servlet.http.HttpServletRequest;

public class RequestUtil {
	public final static String getErrorUrl(HttpServletRequest request) {
		String errorUrl = (String) request.getAttribute("javax.servlet.error.request_uri");
		if (errorUrl == null) {
			errorUrl = (String) request.getAttribute("javax.servlet.forward.request_uri");
		}
		if (errorUrl == null) {
			errorUrl = (String) request.getAttribute("javax.servlet.include.request_uri");
		}
		if (errorUrl == null) {
			errorUrl = request.getRequestURL().toString();
		}
		return errorUrl;
	}
	
	public final static StringBuilder getErrorInfoFromRequest(HttpServletRequest request, boolean isInfoEnabled) {
		StringBuilder sb = new StringBuilder();
		String errorUrl = getErrorUrl(request);
		sb.append(StringUtil.formatMsg("Error processing url: %1, Referrer: %2, Error message: %3.\n", errorUrl,
				request.getHeader("REFERER"), request.getAttribute("javax.servlet.error.message")));

		Throwable ex = (Throwable) request.getAttribute("exception");
		if (ex == null) {
			ex = (Throwable) request.getAttribute("javax.servlet.error.exception");
		}

		if (ex != null) {
			sb.append(StringUtil.formatMsg("Exception stack trace: \n", ex));
		}
		return sb;
	}
	
	/**
	 * 根据url获得html内容
	 * */
	public final static String getHtml(String fullUrl) throws IOException {
		URL url = new URL(fullUrl);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		InputStream in = conn.getInputStream();
		Writer writer = new StringWriter();
		if (in != null) {
			char[] buffer = new char[1024];
			try {
				Reader reader = new BufferedReader(new InputStreamReader(in,
						"UTF-8"));
				int n;
				while ((n = reader.read(buffer)) != -1) {
					writer.write(buffer, 0, n);
				}
			} finally {
				in.close();
			}
		}
		return writer.toString();
	}
	
	public  static void main(String[]args) throws IOException{
		String url="http://www.baidu.com";

		String a=getHtml(url);
		
		System.out.println("ss:"+a);
	}
	
}
