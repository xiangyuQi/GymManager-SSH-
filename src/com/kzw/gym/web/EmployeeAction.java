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
import com.kzw.gym.entity.Employee;
import com.kzw.gym.service.EmployeeService;


@Controller
@RequestMapping("/emp")
public class EmployeeAction {
	
	@Autowired
	private EmployeeService employeeService ;
	
	@RequestMapping("view")
	public String view() {
		return "gym/emp_view";
	}
	//教练视图
	@RequestMapping("coach_view")
	public String coach_view() {
		return "gym/coach_view";
	}
	
	@RequestMapping("list")
	public void list(PageRequest pageRequest, HttpServletRequest request, HttpServletResponse response) {
		// 获得查询条件
		List<StringPropertyFilter> filters = StringPropertyFilter.buildFromHttpRequest(request);
		Page<Employee> page = employeeService.search2(pageRequest, filters);
		String json = new JSON(page).buildWithFilters(3);
		ResponseUtils.renderJson(response, json);		
	}	
	@RequestMapping("listCoach")
	public void listCoach(PageRequest pageRequest, HttpServletRequest request, HttpServletResponse response) {
		// 获得查询条件
		List<StringPropertyFilter> filters = StringPropertyFilter.buildFromHttpRequest(request);
		filters.add(new StringPropertyFilter("LKS_dept.dname","教练部"));
		Page<Employee> page = employeeService.search2(pageRequest, filters);
		String json = new JSON(page).buildWithFilters(3);
		ResponseUtils.renderJson(response, json);		
	}	
	
	/**
	 * 保存
	 * */
	@RequestMapping("save")
	@ResponseBody
	public Msg save(HttpServletRequest request, Employee employee) {
		String base = request.getContextPath();
		String url = employee.getImgUrl();
		if(url.startsWith(base)) {
			url = url.replaceFirst(base, "");
		}
		employee.setImgUrl(url);
		
		if (employee.getId() == null) {
			employeeService.saveOrUpdate(employee);
		} else {
			Employee orgemployee = employeeService.get(employee.getId());
			try {
				BeanUtil.copyNotNullProperties(orgemployee, employee);			
				employeeService.saveOrUpdate(orgemployee);
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		return new Msg(true);
	}
	
	
	@RequestMapping("get/{id}")
	public String get(@PathVariable("id")int id, Model model) {
		Employee employee = employeeService.get(id);
		model.addAttribute("employee", employee);
		return "gym/emp_form";
	}
	
	@RequestMapping("delete")
	@ResponseBody
	public Msg delete(String ids) {
		employeeService.remove(ids);
		return new Msg(true);
	}
	
	@InitBinder
	public void initBinder1(WebDataBinder binder) {
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		binder.registerCustomEditor(Date.class, new CustomDateEditor(df, true));
	}
	
	
}
