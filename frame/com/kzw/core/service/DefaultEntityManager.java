package com.kzw.core.service;

import java.io.Serializable;


import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.kzw.core.orm.hibernate.HibernateDao;
import com.kzw.core.util.ReflectionUtils;

/**
 * 含默认泛型DAO的EntityManager.
 *
 * @param <T> 领域对象类型
 * @param <ID> 领域对象的主键类型
 * 
 * eg.
 * public class UserManager extends DefaultEntityManager<User, Long>{ 
 * }
 * 
 */
public class DefaultEntityManager<T, ID extends Serializable> extends EntityManager<T, ID> {
	
	protected HibernateDao<T, ID> entityDao;//默认的泛型DAO成员变量.
	
	/**
	 * 通过注入的sessionFactory初始化默认的泛型DAO成员变量.
	 */
	@Autowired
	public void setSessionFactory(final SessionFactory sessionFactory) {
		entityClass = ReflectionUtils.getSuperClassGenricType(getClass());
		entityDao = new HibernateDao<T, ID>(sessionFactory, entityClass);
	}

	@Override
	protected HibernateDao<T, ID> getEntityDao() {
		return entityDao;
	}


}
