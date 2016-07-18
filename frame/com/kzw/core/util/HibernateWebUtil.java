package com.kzw.core.util;

import java.util.Collection;
import java.util.Iterator;

import org.apache.commons.beanutils.PropertyUtils;

/**
 * Hibernate针对Web应用的Util函数集合.
 */
public class HibernateWebUtil {

	private HibernateWebUtil() {
	}

	/**
	 * 根据对象ID集合,整理合并集合.
	 * 
	 * 默认对象主键的名称名为"id".
	 * @see #mergeByCheckedIds(Collection, Collection, Class, String) 
	 */
	public static <T, ID> void mergeByCheckedIds(final Collection<T> srcObjects, final Collection<ID> checkedIds,
			final Class<T> clazz) throws Exception {
		mergeByCheckedIds(srcObjects, checkedIds, clazz, "id");
	}

	/**
	 * 根据对象ID集合,整理合并集合.
	 * 
	 * 页面发送变更后的子对象id列表时,删除原来的子对象集合再根据页面id列表创建一个全新的集合这种看似最简单的做法是不行的.
	 * 因此需采用如此的整合算法：在源集合中删除id不在ID集合中的对象,根据ID集合中的id创建对象并添加到源集合中.
	 * 
	 * @param srcObjects 源对象集合
	 * @param checkedIds  目标集合
	 * @param clazz  集合中对象的类型
	 * @param idName 对象主键的名称
	 */
	public static <T, ID> void mergeByCheckedIds(final Collection<T> srcObjects, final Collection<ID> checkedIds,
			final Class<T> clazz, final String idName) throws Exception {

		//目标ID集合为空,删除源集合中所有对象后直接返回.
		if (checkedIds == null) {
			srcObjects.clear();
			return;
		}

		//遍历源集合,如果其id不在目标ID集合中的对象,进行删除.
		//同时,在目标ID集合中删除已在源集合中的id,使得目标ID集合中剩下的id均为源集合中没有的ID.
		Iterator<T> srcIterator = srcObjects.iterator();

		while (srcIterator.hasNext()) {
			T element = srcIterator.next();
			Object id = PropertyUtils.getProperty(element, idName);
			if (!checkedIds.contains(id)) {
				srcIterator.remove();
			} else {
				checkedIds.remove(id);
			}
		}

		//ID集合目前剩余的id均不在源集合中,创建对象,为id属性赋值并添加到源集合中.
		for (ID id : checkedIds) {
			T obj = clazz.newInstance();
			PropertyUtils.setProperty(obj, idName, id);
			srcObjects.add(obj);
		}
	}

}
