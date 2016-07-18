package com.kzw.comm.tag;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import org.apache.commons.lang3.StringUtils;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.kzw.system.entity.Dictionary;
import com.kzw.system.service.DictionaryService;

/**
 * <k:dictSelect id="" name="" value="" className="" itemName="" itemIds=""/>
 * */
public class DictionarySelectTag extends SimpleTagSupport {

	private DictionaryService dictionaryService;

	@Override
	public void doTag() throws JspException, IOException {
		PageContext context = (PageContext) getJspContext();
		if (dictionaryService == null) {
			ApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(context.getServletContext());
			dictionaryService = ctx.getBean(DictionaryService.class);
		}

		StringBuffer sb = new StringBuffer();
		sb.append("<select name=\"" + name + "\" ");
		if (StringUtils.isNotBlank(id)) {
			sb.append("id=\"" + id + "\" ");
		}
		if (StringUtils.isNotBlank(className)) {
			sb.append("class=\"" + className + "\" ");
		}
		sb.append(">");

		// 请选择
		if (headerKey != null) {
			sb.append("<option value=\"" + headerKey + "\">");
			sb.append(headerValue);
			sb.append("</option>");
		}

		boolean flag = StringUtils.isNotBlank(value);
		int selId = -999;
		try {
			if(flag) {
				selId = Integer.parseInt(value);
			}
		} catch (Exception e) {
			flag = false;
		}

		// 如果ids或typeId或typeName不都为空，则获得数据。优先级为：ids>typeId>typeName, 一般只需指定其中一个
		if (StringUtils.isNotBlank(itemIds) || StringUtils.isNotBlank(itemName)) {
			if (StringUtils.isNotBlank(itemIds)) {
				String[] idStrArr = itemIds.split(",");
				List<Integer> idList = new ArrayList<Integer>();
				for (String idStr : idStrArr) {
					idList.add(Integer.parseInt(idStr));
				}
				List<Dictionary> dicts = dictionaryService.getByIds(idList);
				for (Dictionary dict : dicts) {
					if (flag && selId == dict.getId()) {
						sb.append("<option value=\"" + dict.getId() + "\" selected=\"true\">");
						sb.append(dict.getItemValue());
						sb.append("</option>");
					} else {
						sb.append("<option value=\"" + dict.getId() + "\">");
						sb.append(dict.getItemValue());
						sb.append("</option>");
					}
				}
			} else if (StringUtils.isNotBlank(itemName)) {
				List<Dictionary> dicts = dictionaryService.findByItemName(itemName);
				for (Dictionary dict : dicts) {
					if (flag && selId == dict.getId()) {
						sb.append("<option value=\"" + dict.getId() + "\" selected=\"true\">");
						sb.append(dict.getItemValue());
						sb.append("</option>");
					} else {
						sb.append("<option value=\"" + dict.getId() + "\">");
						sb.append(dict.getItemValue());
						sb.append("</option>");
					}
				}
			}
		}
		sb.append("</select>");

		try {
			getJspContext().getOut().print(sb.toString());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private String id;
	private String name;
	private String className;
	private String headerKey;	// 请选择的值
	private String headerValue = "--请选择--";

	private String itemName; 	// 字典类型名称
	private String itemIds; 	// 字典选项值
	private String value; 		// 选中项

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getClassName() {
		return className;
	}

	public void setClassName(String className) {
		this.className = className;
	}

	public String getHeaderKey() {
		return headerKey;
	}

	public void setHeaderKey(String headerKey) {
		this.headerKey = headerKey;
	}

	public String getHeaderValue() {
		return headerValue;
	}

	public void setHeaderValue(String headerValue) {
		this.headerValue = headerValue;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public String getItemIds() {
		return itemIds;
	}

	public void setItemIds(String itemIds) {
		this.itemIds = itemIds;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

}
