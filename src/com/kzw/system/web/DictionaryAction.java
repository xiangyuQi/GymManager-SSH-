package com.kzw.system.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kzw.comm.vo.Msg;
import com.kzw.core.orm.Page;
import com.kzw.core.orm.PageRequest;
import com.kzw.core.orm.StringPropertyFilter;
import com.kzw.core.util.JSON;
import com.kzw.core.util.web.ResponseUtils;
import com.kzw.system.entity.Dictionary;
import com.kzw.system.service.DictionaryService;

@Controller
@RequestMapping("/dict")
public class DictionaryAction {

	@Autowired
	private DictionaryService dictionaryService;
	
	@RequestMapping("view")
	public String view() {
		return "system/dictionary_view";
	}
	
	@RequestMapping("save")
	public String save(Dictionary dict) {
		dictionaryService.saveOrUpdate(dict);
		return "redirect:/dict/list";
	}
	
	@RequestMapping("list")
	public void list(PageRequest pageRequest, HttpServletRequest request, HttpServletResponse response) {
		List<StringPropertyFilter> filters = StringPropertyFilter.buildFromHttpRequest(request);
		Page<Dictionary> page = dictionaryService.search2(pageRequest, filters);
		String json = new JSON(page).buildWithFilters(3);
		ResponseUtils.renderJson(response, json);
	}
	
	@RequestMapping("get/{id}")
	public String get(@PathVariable("id")int id, Model model) {
		Dictionary dict = dictionaryService.get(id);
		model.addAttribute("dict", dict);
		return "system/dictionary_form";
	}
	
	@ResponseBody
	@RequestMapping("delete")
	public Msg delete(String ids) {
		dictionaryService.remove(ids);
		return new Msg(true);
	}
}
