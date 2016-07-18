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
import com.kzw.core.util.BeanUtil;
import com.kzw.core.util.JSON;
import com.kzw.core.util.web.ResponseUtils;
import com.kzw.system.entity.Menu;
import com.kzw.system.service.MenuService;

@Controller
@RequestMapping("/menu")
public class MenuAction {

	@Autowired
	private MenuService menuService;
	
	@RequestMapping("view")
	public String view() {
		return "system/menu_view";
	}
	
	@RequestMapping("list")
	public void list(HttpServletRequest request, HttpServletResponse response) {
		List<Menu> list = menuService.listAll(); // 注意顺序问题
		String json = new JSON(list).buildWithFilters(3);
		ResponseUtils.renderJson(response, json);
	}
	
	/**
	 * 保存
	 * */
	@RequestMapping("save")
	@ResponseBody
	public Msg save(Menu menu, Integer parentId) {
		if (menu.getId() == null) {
			menu.setLeaf(true);
			if(parentId == null) {
				menu.setLevel(0);
				menu.setParent(null);
			} else {
				Menu parent = menuService.get(parentId);
				if(parent.getLeaf()) {
					parent.setLeaf(false);
				}
				menu.setLevel(parent.getLevel() + 1);
				menu.setParent(parent);
			}
			menuService.saveOrUpdate(menu);
		} else {
			Menu orgMenu = menuService.get(menu.getId());
			try {
				BeanUtil.copyNotNullProperties(orgMenu, menu);		
				menuService.saveOrUpdate(orgMenu);
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		return new Msg(true);
	}
	
	@RequestMapping("get/{id}")
	public String get(@PathVariable("id")int id, Model model) {
		Menu menu = menuService.get(id);
		model.addAttribute("menu", menu);
		return "system/menu_form";
	}
	
	@RequestMapping("addUI")
	public String addUI(Model model) {
		List<String[]> menus = menuService.treeAll();
		model.addAttribute("menus", menus);
		return "system/menu_form";
	}
	
	@ResponseBody
	@RequestMapping("del/{id}")
	public Msg del(@PathVariable("id")int id) {
		// 是否为叶子结点
		try {
			menuService.deleteMenu(id);
			return new Msg(true);
		} catch(Exception e) {
			return new Msg(false, "存在下级菜单，请先删除下级菜单！");
		}
		
	}
}
