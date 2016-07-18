package com.kzw.system.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kzw.core.service.DefaultEntityManager;
import com.kzw.system.entity.AppUser;
import com.kzw.system.entity.Menu;

@Service
@Transactional
public class MenuService extends DefaultEntityManager<Menu, Integer> {

	@Transactional(readOnly=true)
	public List<Menu> listAll() {
		List<Menu> result = new ArrayList<Menu>();
		String hql = "from Menu where parent is null order by sn asc";
		List<Menu> roots = findByHQL(hql);
		for(Menu menu : roots) {
			result.add(menu);
			getChildren(menu, result);
		}
		
		return result;
	}
	
	/**
	 * 当前用户的菜单
	 * */
	@Transactional(readOnly=true)
	public List<Menu> listMyMenu(AppUser user) {
		String roleIds = user.getRoleIds();
		List<Menu> result = new ArrayList<Menu>();
		
		if(StringUtils.isNotBlank(roleIds)) {
			Set<String> ids = new HashSet<String>();
			String hql = "select menuIds from Role where id in ("+roleIds+")";
			List<String> list = getEntityDao().find(hql);
			for(String menuIds : list) {
				Collections.addAll(ids, menuIds.split(","));
			}
			
			List<Menu> menus = listAll();
			if(ids.contains("_ALL")) {
				return menus;
			}
			
			for(Menu m : menus) {
				if(ids.contains(m.getId()+"")) {
					result.add(m);
				}
			}
		}
		
		return result;
	}
	
	
	/**
	 * 树形结构展示
	 * */
	@Transactional(readOnly=true)
	public List<String[]> treeAll() {
		List<String[]> result = new ArrayList<String[]>();
		result.add(new String[] {"", "root"});
		List<Menu> menus = listAll();
		for(Menu m : menus) {
			StringBuffer sb = new StringBuffer("├─");
			for(int i=0; i<m.getLevel(); i++) {
				sb.append("──");
			}
			sb.append(m.getName());
			result.add(new String[] {m.getId()+"", sb.toString()});
		}
		
		return result;
	}
	
	private void getChildren(Menu menu, List<Menu> list) {
		String hql = "from Menu where parent=? order by sn asc";
		List<Menu> menus = findByHQL(hql, menu);
		for(Menu m : menus) {
			list.add(m);
			getChildren(m, list);
		}
	}

	@Transactional
	public void deleteMenu(Integer id) {
		Menu menu = get(id);
		Menu parent = menu.getParent();
		
		if(parent != null) {
			String hql = "select count(*) from Menu where parent=?";
			Object cnt = getEntityDao().findUnique(hql, parent);
			menu.setParent(null);
			if(Integer.parseInt(cnt+"") == 1) {
				// 将其parent的leaf置为true
				parent.setLeaf(true);
				saveOrUpdate(parent);
			} 
		}
		remove(menu);
	}
}
