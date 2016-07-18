package com.kzw.core.service;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.transaction.annotation.Transactional;

import com.kzw.core.orm.Page;
import com.kzw.core.orm.PageRequest;
import com.kzw.core.orm.PropertyFilter;
import com.kzw.core.orm.StringPropertyFilter;
import com.kzw.core.orm.hibernate.HibernateDao;

/**
 * 领域对象业务管理类基类.
 * 
 * @param <T> 领域对象类型
 * @param <ID> 领域对象的主键类型
 * 
 * eg.
 * public class UserManager extends EntityManager<User, Long>{ 
 * }
 * 
 */
@Transactional
public abstract class EntityManager<T, ID extends Serializable> {

	protected Logger logger = LoggerFactory.getLogger(getClass());

	protected abstract HibernateDao<T, ID> getEntityDao(); 

	protected Class<T> entityClass;
		
	// CRUD函数 //

	/**
	 * 按id获取对象.
	 */
	@Transactional(readOnly = true)
	public T get(final ID id) {
		return getEntityDao().get(id);
	}

	/**
	 * 分页获取全部对象.
	 */
	@Transactional(readOnly = true)
	public Page<T> getAll(final PageRequest pageRequest) {
		return getEntityDao().getAll(pageRequest);
	}
	
	/**
	 * 按id列表获取对象列表.
	 */
	@Transactional(readOnly = true)
	public List<T> getByIds(final Collection<ID> ids) {
		return getEntityDao().get(ids);
	}
	
	@Transactional(readOnly=true)
	public List<T> findByHQL(String hql, Object... values) {
		return getEntityDao().find(hql, values);
	}

	/**
	 *	获取全部对象.
	 */
	@Transactional(readOnly = true)
	public List<T> getAll() {
		return getEntityDao().getAll();
	}
	
	/**
	 *	获取全部对象, 支持按属性行序.
	 */
	@Transactional(readOnly = true)
	public List<T> getAll(String orderByProperty, boolean isAsc) {
		return getEntityDao().getAll(orderByProperty, isAsc);
	}
	
	/**
	 * 按属性查找对象列表, 匹配方式为相等.
	 */
	@Transactional(readOnly = true)
	public List<T> findBy(final String propertyName, final Object value) {
		return getEntityDao().findBy(propertyName, value);
	}
	
	/**
	 * 按属性查找唯一对象, 匹配方式为相等.
	 */
	@Transactional(readOnly = true)
	public T findUniqueBy(final String propertyName, final Object value) {
		return getEntityDao().findUniqueBy(propertyName, value);
	}
	
	/**
	 * 根据StringPropertyFilter查找
	 * */
	@Transactional(readOnly = true)
	public Page<T> search2(final PageRequest pageRequest, final List<StringPropertyFilter> filters) {
		return getEntityDao().findByStringFilters(pageRequest, filters);
	}
	
	/**
	 * 根据StringPropertyFilter查找
	 * */
	@Transactional(readOnly = true)
	public Page<T> search2(final PageRequest pageRequest, StringPropertyFilter... filters) {
		return getEntityDao().findByStringFilters(pageRequest, filters);
	}
	
	/**
	 * 根据StringPropertyFilter查找
	 * */
	@Transactional(readOnly = true)
	public List<T> search(final StringPropertyFilter... filters) {
		return getEntityDao().findByStringFilters(filters);
	}
	/**
	 * 根据StringPropertyFilter查找
	 * */
	@Transactional(readOnly = true)
	public List<T> search(final List<StringPropertyFilter> filters) {
		return getEntityDao().findByStringFilters(filters);
	}
	
	/**
	 * 根据PropertyFilter查找
	 * */
	@Transactional(readOnly = true)
	public Page<T> search(final PageRequest pageRequest, final List<PropertyFilter> filters) {
		return getEntityDao().findByFilters(pageRequest, filters);
	}
	
	/**
	 * 根据PropertyFilter查找
	 * */
	@Transactional(readOnly = true)
	public Page<T> search(final PageRequest pageRequest, PropertyFilter... filters) {
		return getEntityDao().findByFilters(pageRequest, filters);
	}
	
	/**
	 * 根据PropertyFilter查找
	 * */
	@Transactional(readOnly = true)
	public List<T> search(final PropertyFilter... filters) {
		return getEntityDao().findByFilters(filters);
	}

	/**
	 * 保存新增或修改的对象.
	 */
	public void saveOrUpdate(final T entity) {
		getEntityDao().saveOrUpdate(entity);
	}

	/**
	 * 按id删除对象.
	 */
	public void remove(final ID id) {
		getEntityDao().delete(id);
	}
	/**
	 * 按ids删除对象 
	 * @param ids
	 */
	public void remove(String ids) {
		if (ids == null || ids.equals(";") || ids.equals("")) return ;
		getEntityDao().createQuery("delete from "+entityClass.getSimpleName()+" where id in "+com.kzw.core.util.StrUtils.idStrToIds(ids)).executeUpdate();
	}
	public void remove(String[] ids) {
		remove(StringUtils.join(ids, ";"));
	}
	/**
	 * 删除对象.
	 * @param entity 对象必须是session中的对象或含id属性的transient对象.
	 */
	public void remove(final T entity) {
		getEntityDao().delete(entity);
	}
	
}
