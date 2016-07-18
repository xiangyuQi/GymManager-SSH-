package com.kzw.gym.web;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kzw.comm.vo.Msg;
import com.kzw.core.orm.Page;
import com.kzw.core.orm.PageRequest;
import com.kzw.core.orm.StringPropertyFilter;
import com.kzw.core.util.BeanUtil;
import com.kzw.core.util.JSON;
import com.kzw.core.util.web.ResponseUtils;
import com.kzw.gym.entity.Goods;
import com.kzw.gym.entity.Lockers;
import com.kzw.gym.service.GoodsService;

@Controller
@RequestMapping("/goods")
public class GoodsAction {
	
	@Autowired
	private GoodsService goodsService ;
	
	@RequestMapping("view")
	public String view() {
		return "gym/goods_view";
	}
	
	@RequestMapping("list")
	public void list(PageRequest pageRequest,HttpServletRequest request, HttpServletResponse response) {
		// 获得查询条件
		List<StringPropertyFilter> filters = StringPropertyFilter.buildFromHttpRequest(request);
		Page<Goods> page = goodsService.search2(pageRequest, filters);
		String json = new JSON(page).buildWithFilters(3);
		ResponseUtils.renderJson(response, json);		
	}
	
	@RequestMapping("save")
	@ResponseBody
	public Msg save(HttpServletRequest request,Goods goods) {
		String base = request.getContextPath();
		String url = goods.getImgUrl();
		if(url.startsWith(base)) {
			url = url.replaceFirst(base, "");
		}
		goods.setImgUrl(url);
		if (goods.getId() == null) {
			goodsService.saveOrUpdate(goods);
		} else {
			Goods orgGoods = goodsService.get(goods.getId());
			try {
				BeanUtil.copyNotNullProperties(orgGoods, goods);
				
				goodsService.saveOrUpdate(orgGoods);
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		return new Msg(true);
	}
	@RequestMapping("get/{id}")
	public String get(@PathVariable("id")int id, Model model) {
		Goods goods = goodsService.get(id);
		model.addAttribute("goods", goods);
		return "gym/goods_form";
	}
	
	@ResponseBody
	@RequestMapping("del")
	public Msg delete(String ids) {
		goodsService.remove(ids);
		return new Msg(true);
	}
	@InitBinder
	public void initBinder1(WebDataBinder binder) {
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		binder.registerCustomEditor(Date.class, new CustomDateEditor(df, true));
	}
}
