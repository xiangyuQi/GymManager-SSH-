package com.kzw.system.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kzw.core.orm.StringPropertyFilter;
import com.kzw.core.util.JSON;
import com.kzw.core.util.web.ResponseUtils;
import com.kzw.system.entity.GlobalType;
import com.kzw.system.service.GlobalTypeService;

@Controller
@RequestMapping("/globalType")
public class GlobalTypeAction {

	@Autowired
	private GlobalTypeService globalTypeService;

	@RequestMapping("view")
	public String view() {
		return "system/globalType_view";
	}

	@RequestMapping("save")
	public String save(GlobalType globalType) {
		globalTypeService.saveOrUpdate(globalType);
		return "redirect:/dict/list";
	}

	@RequestMapping("list")
	public void list(HttpServletRequest request, HttpServletResponse response) {
		List<StringPropertyFilter> filters = StringPropertyFilter.buildFromHttpRequest(request);
		List<GlobalType> list = globalTypeService.search(filters);
		String json = new JSON(list).buildWithFilters(3);
		ResponseUtils.renderJson(response, json);
	}
}
