package com.kzw.system.web;

import java.util.List;

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
import com.kzw.system.entity.Department;
import com.kzw.system.service.DepartmentService;

@Controller
@RequestMapping("/dept")
public class DepartmentAction {

	@Autowired
	private DepartmentService deptService;
	
	@RequestMapping("view")
	public String view() {
		return "system/dept_view";
	}
	
	@RequestMapping("list")
	public void list(HttpServletResponse response) {
		List<Department> list = deptService.listAll();
		String json = new JSON(list).buildWithFilters(3);
		ResponseUtils.renderJson(response, json);
	}
	
	/**
	 * 保存
	 * */
	@RequestMapping("save")
	@ResponseBody
	public Msg save(Department dept, Integer parentId) {
		if (dept.getId() == null) {
			dept.setLeaf(true);
			dept.setLevel(0);
			
			if(parentId != null) {
				Department parent = deptService.get(parentId);
				if(parent.getLeaf()) {
					parent.setLeaf(false);
				}
				dept.setLevel(parent.getLevel() + 1);
				dept.setParent(parent);
			}
			
			deptService.saveOrUpdate(dept);
		} else {
			Department orgDepartment = deptService.get(dept.getId());
			try {
				BeanUtil.copyNotNullProperties(orgDepartment, dept);		
				deptService.saveOrUpdate(orgDepartment);
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		return new Msg(true);
	}
	
	@RequestMapping("get/{id}")
	public String get(@PathVariable("id")int id, Model model) {
		Department dept = deptService.get(id);
		model.addAttribute("dept", dept);
		return "system/dept_form";
	}
	
	@RequestMapping("toAdd")
	public String toAdd(Model model) {
		List<String[]> depts = deptService.treeAll();
		model.addAttribute("depts", depts);
		return "system/dept_form";
	}
}
