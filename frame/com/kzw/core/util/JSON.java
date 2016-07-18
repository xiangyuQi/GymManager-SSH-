package com.kzw.core.util;

import java.lang.reflect.Array;
import java.lang.reflect.Method;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import com.kzw.core.orm.Page;

/**
 * 
 * 将对象转为JSON字符串
 * <br/>
 * 2012/4/4
 * 更新功能：<br/>
 *  1.层级指定<br/>
 *  2.索引缓存 <br/>
 *  3.循环引用检测 (当子对象引用到父对象的时候设置为null)<br/>
 *  警告：<br/>
 * 		Map对象序列化的时候，请自信排除循环引用，否则后果自负，如：<br/>
 * 		Map testMap=new HashMap();<br/>
 * 		testMap.put("test",testMap);<br/>
 * 用法：<br/>
 * 		new JSON(yourbean).build();<br/>
 * 		new JSON(yourbean).buildWith...();<br/>
 * @author desire_long 
 *
 */
public class JSON {

    private static final int TYPE_COLLECTION = 1;
    private static final int TYPE_ARRAY = 2;
    private static final int TYPE_MAP = 3;
    private static final int TYPE_NULL = 0;
    private static final int TYPE_NUMBER = 4;
    private static final int TYPE_STRING = 5;
    private static final int TYPE_BOOLEAN = 6;
    private static final int TYPE_SIMPLECLASS = 7;
    private static final int TYPE_DATE=8;
    
    //需要过滤的公共属性
    private static Set<String> staticfilter = new HashSet<String>();
    //被屏蔽的方法
    private static String[] shieldField = {"property", "metaClass"};
    //需要被过滤的当个体属性
    private Set<String> filter = new HashSet<String>();
    private Set<String > selectors = null;
    private String dateFormater  = "yyyy-MM-dd";
    /**
     * 引用索引，避免循环引用
     */
    private Map<Integer, String> refs = new HashMap<Integer, String>();
    private String JSONString=null;
    private String refName=null;
    private Object bean;
    static {
        staticfilter.add("getProperty");
        staticfilter.add("getMetaClass");
    }
    private void init(Object bean,int level){
        try {
			this.JSONString=formObject(bean,level);
		} catch (Exception e) {
			e.printStackTrace();
			this.JSONString="erro!";
		}
    }
    
    /**
     * 直接渲染对象
     * */
    public JSON(Object bean, boolean ispure){
    	if(ispure) {
    		this.bean = bean;
    	} else {
        	this.bean = new ObjectJson(bean);
    	}
    }

    public JSON(Object bean){
    	if (!(bean instanceof Page)) {//如果不是page的话
    		bean = new ObjectJson(bean);
		}
    	this.bean = bean;
    }
    
    public JSON(Object bean,String dateFormater,  boolean ispure){
    	this.dateFormater = dateFormater;
    	if(ispure) {
    		this.bean = bean;
    	} else {
        	this.bean = new ObjectJson(bean);
    	}
    }

    public JSON(Object bean, String dateFormater){
    	this.dateFormater = dateFormater;
    	if (!(bean instanceof Page)) {//如果不是page的话
    		bean = new ObjectJson(bean);
		}
    	this.bean = bean;
    }
//    /**
//     * 
//     * @param bean
//     * @param filters 不需要输出的属性
//     */
//    public JSON(Object bean, String ... filters) {
//        for (String s : filters) {
//            filter.add(s);
//        }
//        init(bean,-1);
//    } 
//    /**
//     * 
//     * @param bean
//     * @param level 引用的层级，输出的最大引用级数
//     * @param filters 不需要输出的属性
//     */
//    public JSON(Object bean, int level,String ... filters) {
//        for (String s : filters) {
//            filter.add(s);
//        }
//        init(bean,level);
//    }
    public String build(){
        init(bean,-1);
    	return this.JSONString;
    }
    /**
     * 自动增加 success, data, result
     * 
     * @param level 层级
     * 如list<student> stds 如只要student类的属性,层级为1，则new JSON(stds).buildWithFilters(1)
     * @param filters 不输出的属性
     * @return
     */
    public String buildWithFilters(int level,String ... filters){
    	  for (String s : filters) {
              filter.add(s);
          }
    	  if (!(bean instanceof Page)) {//如果不是page的话 zhujb
    		  level++;
    	  }
          init(bean,level);
    	return this.JSONString;
    }
    /**
     * 
     * @param filters 不输出的属性
     * @return
     */
    public String buildWithFilters(String ... filters){
  	  for (String s : filters) {
            filter.add(s);
        }
        init(bean,-1);
  	return this.JSONString;
  }
    /**
     * 
     * @param level 层级
     * @param selectors 只输出的属性
     * @return
     */
    public String buildWithSelectors(int level,String ... selectors){
    	this.selectors = new HashSet<String>();
    	for(String s : selectors){
    		this.selectors.add(s);
    	}
    	init(this.bean, level);
    	return this.JSONString;
    }
    /**
     * 
     * @param selectors 只输出的属性
     * @return
     */
    public String buildWithSelectors(String ... selectors){
    	this.selectors = new HashSet<String>();
    	for(String s : selectors){
    		this.selectors.add(s);
    	}
    	init(this.bean, -1);
    	return this.JSONString;
    }
//    /**
//     * 
//     * @param bean
//     * @param refName 输出的引用属性名,可以用于属性的循环引用
//     * @param level 引用的层级，输出的最大引用级数
//     * @param filters 不需要输出的属性
//     */
//    public JSON(Object bean,String refName, int level,String ... filters) {
//        for (String s : filters) {
//            filter.add(s);
//        }
//        this.refName = refName;
//        init(bean,level);
//    } 
    /**
     * 设置隐藏字段
     * @param fieldName 字段名
     */
    public static void setShieldField(String fieldName) {
        staticfilter.add(fieldName);
    }

    /**
     * 删除已设置的隐藏字段
     * @param field 字段名
     */
    public static void delShieldField(String field) {
        staticfilter.remove(field);
    }
    
    //获取对象类型
    private int getObjectType(Object obj) {

        if (obj == null) {
            return TYPE_NULL;
        }
        // 如果为数组类型
        if (obj.getClass().isArray()) {
            return TYPE_ARRAY;
        }
        if(obj instanceof Collection){
        	return TYPE_COLLECTION;
        }
        if(obj instanceof Map){
        	return TYPE_MAP;
        }
        if(obj instanceof String){
        	return TYPE_STRING;
        }
        if(obj instanceof Number){
        	return TYPE_NUMBER;
        }
        if(obj instanceof Boolean){
        	return TYPE_BOOLEAN;
        }
        if(obj instanceof Date || obj instanceof Timestamp){
        	return TYPE_DATE;
        }
        // 如果为自定义类
        return TYPE_SIMPLECLASS;
    }

    @SuppressWarnings({ "rawtypes" })
    private String formObject(Object obj, int level) throws Exception {
        int type = getObjectType(obj);
        switch (type) {
            case TYPE_NUMBER:
            case TYPE_BOOLEAN:
                return obj.toString();
            case TYPE_STRING:
            	 return new StringBuilder("\"").append(obj.toString().trim().replaceAll("\r\n", "\\\\\\\\r\\\\\\\\n").replaceAll("\"", "“").trim()).append("\"").toString();
            case TYPE_DATE:
                return new StringBuilder("\"").append(new SimpleDateFormat(dateFormater).format((Date)obj)).append("\"").toString();
            case TYPE_COLLECTION:
            case TYPE_ARRAY:
                return formArray(obj,level);
            case TYPE_SIMPLECLASS:
                return formSimpleClass(obj,level);
            case TYPE_MAP:
                return formMap((Map) obj,level);
        }
        return "null";
    }

    private String formSimpleClass(Object obj,int level) throws Exception {
    	if(level == 0)
    		return "{}";
//    	int key = obj.hashCode();
//    	if(refs.containsKey(key)){
//    		return refs.get(key);
//    	}else{
//    		refs.put(key, "null");
//    		/**if(refName!=null){
//    			refs.put(key, "\"_ref:"+key+"\"");
//    		}**/
//    	}
        StringBuffer json = new StringBuffer();
        int i = 0;
        json.append("{");
  
        for (Method method : obj.getClass().getDeclaredMethods()) {
        	 //如果方法参数数量不为0 则跳过
            if(method.getParameterTypes().length>0){
            	continue;
            }
            String mName = method.getName();
            String filedName = mName.replaceFirst("get\\w", String.valueOf(
                    mName.charAt(3)).toLowerCase());
            try {
                if (mName.startsWith("get") && !isShieldField(filedName)) {
                    if (i != 0) {
                        json.append(",");
                    }
                    /**else if(refName!=null){
            			//refs.put(key, "\"_ref:"+key+"\"");
                    	json.append("\"");
            			json.append(refName);
            			json.append("\":\"");
            			json.append(key);
            			json.append(",");
            		}**/
                    json.append("\"");
                    json.append(filedName);
                    json.append("\"");
                    json.append(":");
                    try {
                        json.append(formObject(method.invoke(obj),level-1));
                    } catch (Exception e) {
                        e.printStackTrace();
                        json.append("");
                    }
                    i++;
                }
            } catch (Exception e) {
                e.printStackTrace();
                break;
            }
        }
        json.append("}");
        String rs = json.toString();
        //refs.put(key, rs);
        return rs;
    }

    @SuppressWarnings("rawtypes")
	private String formMap( Map obj,int level) throws Exception {
    	if(level ==0){
    		return "{}";
    	}
//    	int key = obj.hashCode();
//    	if(refs.containsKey(key)){
//    		return refs.get(key);
//    	}else{
//    		refs.put(key, "null");
//    	}
        StringBuffer json = new StringBuffer();
        json.append("{");
        int i = 0;
        Set s = obj.keySet();
        for (Object object : s) {
            if (i != 0) {
                json.append(",");
            }
            json.append("\"")
            .append(object.toString())
            .append( "\":")
            .append(formObject(obj.get(object),level));
        //   json.append("\""+object.toString()+"\":"+formObject(obj.get(object),level-1));
            i++;
        }
        json.append("}");
        String rs = json.toString();
//        refs.put(key, rs);
        return rs;
    }

	@SuppressWarnings("rawtypes")
	private String formArray(Object obj,int level) throws Exception {
		if(level==0){
			return "[]";
		}
//		int key = obj.hashCode();
//    	if(refs.containsKey(key)){
//    		return refs.get(key);
//    	}else{
//    		refs.put(key, "null");
//    	}
        if (getObjectType(obj) == TYPE_COLLECTION) {
        	try {
        		obj = ((Collection) obj).toArray();
        	} catch(Exception e) {
        		e.printStackTrace();
        	}
        }
        StringBuffer json = new StringBuffer();
        int size = 0;
        json.append("[");
        size = Array.getLength(obj);
        for (int i = 0; i < size; i++) {
            Object o = Array.get(obj, i);
            if (i != 0) {
                json.append(",");
            }
            json.append(formObject(o, level));
        }
        json.append("]");
        String rs = json.toString();
//		refs.put(key, rs);
        return rs;
    }

    @Override
    public String toString() {
        return this.JSONString;
    }

    private boolean isShieldField(String methodName) {
    	if(selectors != null){
    		return !selectors.contains(methodName);
    	}
        for (String s : shieldField) {
            if (methodName.equals(s)) {
                return true;
            }
        }
        if(staticfilter.contains(methodName)){
        	return true;
        }
        if(filter.contains(methodName)){
        	return true;
        }
        return false;
    }

	public String getDateFormater() {
		return dateFormater;
	}

	public void setDateFormater(String dateFormater) {
		this.dateFormater = dateFormater;
	}
}
