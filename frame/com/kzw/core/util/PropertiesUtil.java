package com.kzw.core.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.Reader;
import java.util.Properties;

public class PropertiesUtil {
	/**
	 * get properties from file
	 * @param filename include the fullpath ,for example: d:/abc.properties
	 * @param encode
	 * @return
	 */
	public static Properties getFromFile(String filename,String encode){
		FileInputStream fis=null;
		Properties props=new Properties();
		Reader reader=null;
		try{
			fis=new FileInputStream(filename);
			reader = new InputStreamReader(fis, encode); 
			props.load(reader);
		}catch(Exception ex){
			ex.printStackTrace();
		}finally{
			try{
				if(reader!=null)reader.close();
				if(fis!=null) fis.close();
			}catch(Exception e){}
		}
		return props;
	}
	
	/**
	 * get properties from file,default encode is utf-8
	 * @param filename include the fullpath ,for example: d:/abc.properties
	 * @return
	 */
	public static Properties getFromFile(String filename){
		return getFromFile(filename,"UTF-8");
	}
	
	/**
	 * write the key to file
	 * @param filename  include the fullpath ,for example: d:/abc.properties
	 * @param key
	 * @param value
	 */
	public static void writeKey(String filename,String key,String value){
		Properties orgProps=getFromFile(filename);
		orgProps.setProperty(key, value);
		try{
			OutputStream outStream=new FileOutputStream(new File(filename));
			orgProps.store(outStream, "set");
		}catch(Exception ex){
			ex.printStackTrace();
		}
	}
	
}
