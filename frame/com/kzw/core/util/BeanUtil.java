package com.kzw.core.util;

import java.beans.PropertyDescriptor;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.BeanUtilsBean;
import org.apache.commons.beanutils.ConvertUtilsBean;
import org.apache.commons.beanutils.Converter;
import org.apache.commons.beanutils.DynaBean;
import org.apache.commons.beanutils.DynaProperty;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.beanutils.PropertyUtilsBean;
import org.apache.commons.beanutils.converters.LongConverter;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.kzw.core.mvc.BeanDateConnverter;

@SuppressWarnings({"rawtypes", "unchecked"})
public class BeanUtil {
	
	private static Log logger = LogFactory.getLog(BeanUtil.class);
	// BeanUtil类型转换器
	public static ConvertUtilsBean convertUtilsBean = new ConvertUtilsBean();
	
	static{
		convertUtilsBean.register(new BeanDateConnverter(), Date.class);
		convertUtilsBean.register(new LongConverter(null), Long.class);
	}
	
	/**
	 * 关联赋值, session问题
	 * */
	public static void copyNestedNotNullProperty(Object dest, String propName, Object value) throws Exception {
		if(value == null) return;
		Object bean = dest;
		while(propName.indexOf(".") >= 0) {
			String subProp = propName.substring(0, propName.indexOf("."));
			Object obj = PropertyUtils.getProperty(bean, subProp);
			if(obj == null) {
				PropertyDescriptor pd = PropertyUtils.getPropertyDescriptor(dest, subProp);
				obj = pd.getPropertyType().newInstance();
				PropertyUtils.setProperty(bean, subProp, obj);
			}
			bean = obj;
			propName = propName.substring(propName.indexOf(".")+1);
		}
		PropertyUtils.setProperty(bean, propName, value);
	}
	
	/**
	 * 拷贝一个bean中的非空属性于另一个bean中
	 */
	public static void copyNotNullProperties(Object dest, Object orig) throws Exception {
		BeanUtilsBean beanUtils = BeanUtilsBean.getInstance();
		// Validate existence of the specified beans
		if (dest == null) {
			throw new IllegalArgumentException("No destination bean specified");
		}
		if (orig == null) {
			throw new IllegalArgumentException("No origin bean specified");
		}
		if (logger.isDebugEnabled()) {
			logger.debug("BeanUtils.copyProperties(" + dest + ", " + orig+ ")");
		}

		// Copy the properties, converting as necessary
		if (orig instanceof DynaBean) {
			DynaProperty[] origDescriptors = ((DynaBean) orig).getDynaClass()
					.getDynaProperties();
			for (int i = 0; i < origDescriptors.length; i++) {
				String name = origDescriptors[i].getName();
				// Need to check isReadable() for WrapDynaBean
				// (see Jira issue# BEANUTILS-61)
				if (beanUtils.getPropertyUtils().isReadable(orig, name)
						&& beanUtils.getPropertyUtils().isWriteable(dest, name)) {
					Object value = ((DynaBean) orig).get(name);
					beanUtils.copyProperty(dest, name, value);
				}
			}
		} else if (orig instanceof Map) {
			Iterator entries = ((Map) orig).entrySet().iterator();
			while (entries.hasNext()) {
				Map.Entry entry = (Map.Entry) entries.next();
				String name = (String) entry.getKey();
				if(name.indexOf(".") > 0) {
					//如果是内嵌属性
					//getBeanUtils().setProperty(dest, name, entry.getValue());
					//获得级联的bean
					String[] beans = name.split("\\.");
					int len = beans.length;
					Object obj = dest;
					for(int i=0; i<len-1; i++) {
						Object obj2 = getBeanUtils().getProperty(obj, beans[i]);
						if(obj2 == null) {
							PropertyDescriptor pd = new PropertyDescriptor(beans[i], obj.getClass());
							obj2 = pd.getPropertyType().newInstance();
							getBeanUtils().setProperty(obj, beans[i], obj2);
						}
						obj = obj2;
					}
					if(obj != null) {
						getBeanUtils().setProperty(obj, beans[len-1], entry.getValue());
					}
				} else {
					if (beanUtils.getPropertyUtils().isWriteable(dest, name)) {
						beanUtils.copyProperty(dest, name, entry.getValue());
					}
				}
			}
		} else /* if (orig is a standard JavaBean) */{
			PropertyDescriptor[] origDescriptors = beanUtils.getPropertyUtils()
					.getPropertyDescriptors(orig);
			for (int i = 0; i < origDescriptors.length; i++) {
				String name = origDescriptors[i].getName();
				if ("class".equals(name)) {
					continue; // No point in trying to set an object's class
				}
				if (beanUtils.getPropertyUtils().isReadable(orig, name)
						&& beanUtils.getPropertyUtils().isWriteable(dest, name)) {
					try {
						Object value = beanUtils.getPropertyUtils()
								.getSimpleProperty(orig, name);
						if (value != null) {
							beanUtils.copyProperty(dest, name, value);
						}
					} catch (NoSuchMethodException e) {
						// Should not happen
					}
				}
			}
		}

	}
	
	/**
	 * 通过Request构造实体
	 * @param request 请求对象
	 * @param entity 实体对象
	 * @param preName 请求中的前缀变量
	 */
	public static Object populateEntity(HttpServletRequest request,Object entity, String preName)
	throws Exception{
	    HashMap map = new HashMap();
	    Enumeration<String> names = request.getParameterNames();
	    while (names.hasMoreElements()) {
	      String name = (String) names.nextElement();
	      //属性名称
	      String propetyName=name;
	      if(StringUtils.isNotEmpty(preName)){
	    	  propetyName=propetyName.replace(preName+".", "");
	      }
	      map.put(propetyName, request.getParameterValues(name));
	    }
	    copyNotNullProperties(entity, map);
		return entity;
	}

	/**
	 * 转化类型
	 */
	public static Object convertValue(ConvertUtilsBean convertUtil,Object value,Class type){
		
		Converter converter = convertUtil.lookup(type);
		if(converter==null) return value;
		
		Object newValue=null;
		if (value instanceof String) {
		    newValue = converter.convert(type,(String) value);
		} else if (value instanceof String[]) {
		    newValue = converter.convert(type,((String[]) value)[0]);
		} else {
		    newValue = converter.convert(type,value);
		}
		return newValue;
	}

	/**
	 * 取得能转化类型的bean
	 */
	public static BeanUtilsBean getBeanUtils() {
		BeanUtilsBean beanUtilsBean = new BeanUtilsBean(convertUtilsBean, new PropertyUtilsBean());
		return beanUtilsBean;
	}
	
	/**
	 * 返回请求中的所有的对应的Map值
	 */
	public static Map getMapFromRequest(HttpServletRequest request){
	    	Map reqMap=request.getParameterMap();
	   	
	    	HashMap<String,Object> datas=new HashMap<String,Object>();
		Iterator it = reqMap.entrySet().iterator();
		
		while(it.hasNext()){
			Map.Entry entry = (Map.Entry)it.next();
			String key=(String)entry.getKey();
			String[] val=(String[])entry.getValue();
			if(val.length==1){
			    datas.put(key, val[0]);
			}else{
			    datas.put(key,val);
			}
		}
		return datas;
	}
}
