package com.kzw.system.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kzw.core.service.DefaultEntityManager;
import com.kzw.system.entity.Department;

@Service
@Transactional
public class DepartmentService extends
		DefaultEntityManager<Department, Integer> {

	/**
	 * 以树形结构返回
	 */
	@Transactional(readOnly = true)
	public List<Department> listAll() {
		List<Department> result = new ArrayList<Department>();
		String hql = "from Department where parent is null order by sn asc";
		List<Department> roots = getEntityDao().find(hql);
		for (Department dept : roots) {
			result.add(dept);
			getChildren(dept, result);
		}
		return result;
	}

	private void getChildren(Department dept, List<Department> list) {
		String hql = "from Department where parent=? order by sn asc";
		List<Department> depts = findByHQL(hql, dept);
		for (Department d : depts) {
			list.add(d);
			getChildren(d, list);
		}
	}

	@Transactional(readOnly = true)
	public List<String[]> treeAll() {
		List<String[]> result = new ArrayList<String[]>();
		result.add(new String[] { "", "root" });
		List<Department> list = listAll();
		for (Department m : list) {
			StringBuffer sb = new StringBuffer("├─");
			for (int i = 0; i < m.getLevel(); i++) {
				sb.append("──");
			}
			sb.append(m.getDname());
			result.add(new String[] { m.getId() + "", sb.toString() });
		}
		return result;
	}
}
