package com.kzw.system.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.Hibernate;
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
import com.kzw.core.util.BeanUtil;
import com.kzw.core.util.JSON;
import com.kzw.core.util.MD5;
import com.kzw.core.util.web.ResponseUtils;
import com.kzw.system.entity.AppUser;
import com.kzw.system.service.AppUserService;

@Controller
@RequestMapping("/user")
public class AppUserAction {

	@Autowired
	private AppUserService userService;
	
	@RequestMapping("view")
	public String view() {
		return "system/user_view";
	}
	
	/**
	 * 登陆
	 * */
	@RequestMapping("login")
	public String login(HttpServletRequest request, String uname, String passwd) {
		AppUser user = userService.findUniqueBy("uname", uname);
		if(user!=null && user.getPasswd().equals(MD5.encode(passwd))) {
			Hibernate.initialize(user.getDept());
			Hibernate.initialize(user.getSex());
			request.getSession().setAttribute("USER", user);
			return "redirect:/index.jsp";
		}
		
		request.setAttribute("msg", "用户或密码错误！");
		return "forward:/login.jsp";
	}
	
	
	/**
	 * 退出
	 * */
	@RequestMapping("logout")
	public String logout(HttpServletRequest request) {
		request.getSession().invalidate();
		return "redirect:/login.jsp";
	}
	
	@RequestMapping("list")
	public void list(PageRequest pageRequest, HttpServletRequest request, HttpServletResponse response) {
		List<StringPropertyFilter> filters = StringPropertyFilter.buildFromHttpRequest(request);
		Page<AppUser> page = userService.search2(pageRequest, filters);
		String json = new JSON(page).buildWithFilters(3);
		ResponseUtils.renderJson(response, json);
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Msg save(AppUser user ) {
		user.setPasswd(MD5.encode(user.getPasswd()));
		if (user.getId() == null) {
			userService.saveOrUpdate(user);
		} else {
			AppUser orgUser = userService.get(user.getId());
			try {
				BeanUtil.copyNotNullProperties(orgUser, user);
				userService.saveOrUpdate(orgUser);
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		return new Msg(true);
	}
	
	@RequestMapping("get/{id}")
	public String get(@PathVariable("id")int id, Model model) {
		AppUser user = userService.get(id);
		model.addAttribute("user", user);
		return "system/user_form";
	}
	
	@ResponseBody
	@RequestMapping("delete")
	public Msg delete(String ids) {
		userService.remove(ids);
		return new Msg(true);
	}
}
