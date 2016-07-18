package com.kzw.core.util;

import java.util.HashMap;
import java.util.Map;

/**
 * 用ThreadLocal提供一个存储线程内变量的地方.
 * <p/>
 * 客户端代码可以用静态方法存储和获取线程内变量,不需要依赖于HttpSession.
 * web层的Controller可通过此处向business层传入user_id之类的变量
 *
 */
@SuppressWarnings("unchecked")
public class UserSession {
	
	private static final ThreadLocal<Map> sessionMap = new ThreadLocal<Map>();

	public static Object get(String attribute) {
		Map map = sessionMap.get();
		if (map == null) {
			return null;
		}
		return map.get(attribute);
	}

	public static <T> T get(String attribute, Class<T> clazz) {
		return (T) get(attribute);
	}

	public static void set(String attribute, Object value) {
		Map map = sessionMap.get();
		if (map == null) {
			map = new HashMap();
			sessionMap.set(map);
		}
		map.put(attribute, value);
	}
	
	public static void clearAll() {
		sessionMap.set(null);
	}
	
	public static void clear(String attribute) {
		Map map = sessionMap.get();
		if(map != null) {
			map.remove(attribute);
		}
	}
	
}
