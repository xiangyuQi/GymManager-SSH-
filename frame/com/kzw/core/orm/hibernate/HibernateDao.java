package com.kzw.core.orm.hibernate;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.CriteriaSpecification;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Disjunction;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projection;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.hibernate.internal.CriteriaImpl;
import org.hibernate.internal.CriteriaImpl.Subcriteria;
import org.hibernate.transform.ResultTransformer;

import com.kzw.core.orm.MatchType;
import com.kzw.core.orm.Page;
import com.kzw.core.orm.PageRequest;
import com.kzw.core.orm.PropertyFilter;
import com.kzw.core.orm.StringPropertyFilter;
import com.kzw.core.orm.PageRequest.Sort;
import com.kzw.core.util.AssertUtils;
import com.kzw.core.util.ReflectionUtils;
import com.kzw.core.util.StringUtil;

/**
 * 封装SpringSide扩展功能的Hibernat DAO泛型基类.
 * 
 * 扩展功能包括分页查询,按属性过滤条件列表查询.
 * 
 * @param <T> DAO操作的对象类型
 * @param <ID> 主键类型
 */
@SuppressWarnings("unchecked")
public class HibernateDao<T, ID extends Serializable> extends SimpleHibernateDao<T, ID> {

	public static final String DEFAULT_ALIAS = "x";

	/**
	 * 通过子类的泛型定义取得对象类型Class.
	 * eg.
	 * public class UserDao extends HibernateDao<User, Long>{
	 * }
	 */
	public HibernateDao() {
		super();
	}

	public HibernateDao(Class<T> entityClass) {
		super(entityClass);
	}
	
	/**
	 * 用于Service层直接使用SimpleHibernateDAO的构造函数.
	 * eg.
	 * SimpleHibernateDao<User, Long> userDao = new SimpleHibernateDao<User, Long>(sessionFactory, User.class);
	 */
	public HibernateDao(SessionFactory sessionFactory, Class<T> entityClass) {
		super(sessionFactory, entityClass);
	}

	//-- 分页查询函数 --//

	/**
	 * 分页获取全部对象.
	 */
	public Page<T> getAll(final PageRequest pageRequest) {
		return findPage(pageRequest);
	}

	/**
	 * 按HQL分页查询.
	 * 
	 * @param pageRequest 分页参数.
	 * @param hql hql语句.
	 * @param values 数量可变的查询参数,按顺序绑定.
	 * 
	 * @return 分页查询结果, 附带结果列表及所有查询输入参数.
	 */
	public Page<T> findPage(final PageRequest pageRequest, String hql, final Object... values) {
		AssertUtils.notNull(pageRequest, "pageRequest不能为空");

		Page<T> page = new Page<T>(pageRequest);

		if (pageRequest.isCountTotal()) {
			long totalCount = countHqlResult(hql, values);
			page.setTotalItems(totalCount);
		}

		if (pageRequest.isOrderBySetted()) {
			hql = setOrderParameterToHql(hql, pageRequest);
		}
		Query q = createQuery(hql, values);

		setPageParameterToQuery(q, pageRequest);

		List result = q.list();
		page.setResult(result);
		return page;
	}

	/**
	 * 按HQL分页查询.
	 * 
	 * @param page 分页参数.
	 * @param hql hql语句.
	 * @param values 命名参数,按名称绑定.
	 * 
	 * @return 分页查询结果, 附带结果列表及所有查询输入参数.
	 */
	public Page<T> findPage(final PageRequest pageRequest, String hql, final Map<String, ?> values) {
		AssertUtils.notNull(pageRequest, "page不能为空");

		Page<T> page = new Page<T>(pageRequest);

		if (pageRequest.isCountTotal()) {
			long totalCount = countHqlResult(hql, values);
			page.setTotalItems(totalCount);
		}

		if (pageRequest.isOrderBySetted()) {
			hql = setOrderParameterToHql(hql, pageRequest);
		}

		Query q = createQuery(hql, values);
		setPageParameterToQuery(q, pageRequest);

		List result = q.list();
		page.setResult(result);
		return page;
	}

	/**
	 * 按Criteria分页查询.
	 * 
	 * @param page 分页参数.
	 * @param criterions 数量可变的Criterion.
	 * 
	 * @return 分页查询结果.附带结果列表及所有查询输入参数.
	 */
	public Page<T> findPage(final PageRequest pageRequest, final Criterion... criterions) {
		AssertUtils.notNull(pageRequest, "page不能为空");

		Page<T> page = new Page<T>(pageRequest);

		Criteria c = createCriteria(criterions);

		if (pageRequest.isCountTotal()) {
			long totalCount = countCriteriaResult(c);
			page.setTotalItems(totalCount);
		}

		setPageRequestToCriteria(c, pageRequest);

		List result = c.list();
		page.setResult(result);
		return page;
	}
	
	/**
	 * 已创建Criteria
	 * @param page
	 * @param c
	 */
	@SuppressWarnings("unchecked")
	public Page<T> findPage(final PageRequest pageRequest, final Criteria c) {
		AssertUtils.notNull(pageRequest, "page不能为空");
		Page<T> page = new Page<T>(pageRequest);
		if (pageRequest.isCountTotal()) {
			long totalCount = countCriteriaResult(c);
			page.setTotalItems(totalCount);
		}
		setPageRequestToCriteria(c, pageRequest);
		List result = c.list();
		page.setResult(result);
		return page;
	}
	
	/**
	 * 在HQL的后面添加分页参数定义的orderBy, 辅助函数.
	 */
	protected String setOrderParameterToHql(final String hql, final PageRequest pageRequest) {
		StringBuilder builder = new StringBuilder(hql);
		builder.append(" order by");

		for (Sort orderBy : pageRequest.getSort()) {
			//builder.append(String.format(" %s.%s %s,", DEFAULT_ALIAS, orderBy.getProperty(), orderBy.getDir()));朱隐于2011.11.13
			builder.append(String.format(" %s %s,", orderBy.getProperty(), orderBy.getDir()));
		}

		builder.deleteCharAt(builder.length() - 1);

		return builder.toString();
	}

	/**
	 * 设置分页参数到Query对象,辅助函数.
	 */
	protected Query setPageParameterToQuery(final Query q, final PageRequest pageRequest) {
		q.setFirstResult(pageRequest.getOffset());
		q.setMaxResults(pageRequest.getPageSize());
		return q;
	}

	/**
	 * 设置分页参数到Criteria对象,辅助函数.
	 */
	protected Criteria setPageRequestToCriteria(final Criteria c, final PageRequest pageRequest) {
		AssertUtils.isTrue(pageRequest.getPageSize() > 0, "Page Size must larger than zero");

		c.setFirstResult(pageRequest.getOffset());
		c.setMaxResults(pageRequest.getPageSize());

		if (pageRequest.isOrderBySetted()) {
			for (Sort sort : pageRequest.getSort()) {
				if (Sort.ASC.equals(sort.getDir())) {
					c.addOrder(Order.asc(sort.getProperty()));
				} else {
					c.addOrder(Order.desc(sort.getProperty()));
				}
			}
		}
		return c;
	}

	/**
	 * 执行count查询获得本次Hql查询所能获得的对象总数.
	 * 
	 * 本函数只能自动处理简单的hql语句,复杂的hql查询请另行编写count语句查询.
	 */
	protected long countHqlResult(final String hql, final Object... values) {
		String countHql = prepareCountHql(hql);

		try {
			Long count = findUnique(countHql, values);
			return count;
		} catch (Exception e) {
			throw new RuntimeException("hql can't be auto count, hql is:" + countHql, e);
		}
	}

	/**
	 * 执行count查询获得本次Hql查询所能获得的对象总数.
	 * 
	 * 本函数只能自动处理简单的hql语句,复杂的hql查询请另行编写count语句查询.
	 */
	protected long countHqlResult(final String hql, final Map<String, ?> values) {
		String countHql = prepareCountHql(hql);

		try {
			Long count = findUnique(countHql, values);
			return count;
		} catch (Exception e) {
			throw new RuntimeException("hql can't be auto count, hql is:" + countHql, e);
		}
	}

	private String prepareCountHql(String orgHql) {
		String countHql = "select count (*) " + removeSelect(removeOrders(orgHql));
		return countHql;
	}

	private static String removeSelect(String hql) {
		int beginPos = hql.toLowerCase().indexOf("from");
		return hql.substring(beginPos);
	}

	private static String removeOrders(String hql) {
		Pattern p = Pattern.compile("order\\s*by[\\w|\\W|\\s|\\S]*", Pattern.CASE_INSENSITIVE);
		Matcher m = p.matcher(hql);
		StringBuffer sb = new StringBuffer();
		while (m.find()) {
			m.appendReplacement(sb, "");
		}
		m.appendTail(sb);
		return sb.toString();
	}

	/**
	 * 执行count查询获得本次Criteria查询所能获得的对象总数.
	 */
	protected long countCriteriaResult(final Criteria c) {
		CriteriaImpl impl = (CriteriaImpl) c;

		// 先把Projection、ResultTransformer、OrderBy取出来,清空三者后再执行Count操作
		Projection projection = impl.getProjection();
		ResultTransformer transformer = impl.getResultTransformer();

		List<CriteriaImpl.OrderEntry> orderEntries = null;
		try {
			orderEntries = (List) ReflectionUtils.getFieldValue(impl, "orderEntries");
			ReflectionUtils.setFieldValue(impl, "orderEntries", new ArrayList());
		} catch (Exception e) {
			logger.error("不可能抛出的异常:{}", e.getMessage());
		}

		// 执行Count查询, 返回类型为Integer或者Long
		long totalCount;
		try {
			Long totalCountObject = (Long) c.setProjection(Projections.rowCount()).uniqueResult();
			totalCount = (totalCountObject != null) ? totalCountObject : 0;
		} catch (ClassCastException e) {
			Integer totalCountObject = (Integer) c.setProjection(Projections.rowCount()).uniqueResult();
			totalCount = (totalCountObject != null) ? totalCountObject : 0;
		}

		// 将之前的Projection,ResultTransformer和OrderBy条件重新设回去
		c.setProjection(projection);

		if (projection == null) {
			c.setResultTransformer(CriteriaSpecification.ROOT_ENTITY);
		}
		if (transformer != null) {
			c.setResultTransformer(transformer);
		}
		try {
			ReflectionUtils.setFieldValue(impl, "orderEntries", orderEntries);
		} catch (Exception e) {
			logger.error("不可能抛出的异常:{}", e.getMessage());
		}

		return totalCount;
	}

	//-- 属性过滤条件(PropertyFilter)查询函数 --//

	/**
	 * 按属性查找对象列表,支持多种匹配方式.
	 * 
	 * @param matchType 匹配方式,目前支持的取值见PropertyFilter的MatcheType enum.
	 */
	public List<T> findByStringFilters(final String propertyName, final Object value, final MatchType matchType) {
		Criteria criteria = getSession().createCriteria(entityClass);
		appendCriteria(criteria, propertyName, value, matchType);
		return criteria.list();
	}

	/**
	 * 按属性过滤条件列表查找对象列表.
	 */
	public List<T> findByStringFilters(List<StringPropertyFilter> filters) {
		return buildCriterionByStringPropertyFilter(filters).list();
	}
	public List<T> findByStringFilters(StringPropertyFilter... filters) {
		List<StringPropertyFilter> list = Arrays.asList(filters);
		return findByStringFilters(list);
	}
	
	public List<T> findByFilters(List<PropertyFilter> filters) {
		return buildCriterionByPropertyFilter(filters).list();
	}
	public List<T> findByFilters(PropertyFilter... filters) {
		List<PropertyFilter> list = Arrays.asList(filters);
		return findByFilters(list);
	}

	/**
	 * 按属性过滤条件列表分页查找对象.
	 */
	public Page<T> findByStringFilters(final PageRequest pageRequest, final List<StringPropertyFilter> filters) {
		Criteria criteria = buildCriterionByStringPropertyFilter(filters);
		criteria.setCacheable(true);
		return findPage(pageRequest, criteria);
	}
	/**
	 * 按属性过滤条件列表分页查找对象.
	 */
	public Page<T> findByStringFilters(final PageRequest pageRequest, final StringPropertyFilter... filters) {
		List<StringPropertyFilter> list = Arrays.asList(filters);
		return findByStringFilters(pageRequest, list);
	}
	/**
	 * 按属性过滤条件列表分页查找对象.
	 */
	public Page<T> findByFilters(final PageRequest pageRequest, final List<PropertyFilter> filters) {
		Criteria criteria = buildCriterionByPropertyFilter(filters);
		criteria.setCacheable(true);
		return findPage(pageRequest, criteria);
	}
	/**
	 * 按属性过滤条件列表分页查找对象.
	 */
	public Page<T> findByFilters(final PageRequest pageRequest, final PropertyFilter... filters) {
		List<PropertyFilter> list = Arrays.asList(filters);
		return findByFilters(pageRequest, list);
	}
	
	/**
	 * 增加查询条件，可以解决关联对象属性
	 * */
	protected void appendCriteria(Criteria criteria, final String propertyName, final Object propertyValue, final MatchType matchType) {
		PropertyFilter pf = new PropertyFilter(propertyName, propertyValue, matchType);
		appendCriteria(criteria, pf);
	}
	/**
	 * 解决同一个引用的多属性的错误：duplicate association path: clazz
	 * */
	private Subcriteria getCritria(Criteria pCriteria, String pAlias) {
	    Iterator<Subcriteria> iter = ((CriteriaImpl)pCriteria).iterateSubcriteria();
	    while (iter.hasNext()){
	        Subcriteria sub = iter.next();
	        if (pAlias.equals(sub.getAlias())){
	            return sub;
	        }
	    }
	    return null;
	}
	/**
	 * 增加查询条件，可以解决关联对象属性
	 * */
	protected void appendCriteria(Criteria criteria, PropertyFilter filter) {
		// 直接修改criteria的引用
		Criteria cc = criteria;
		// catalog.name a.b.c
		String propName = filter.getPropertyName();
		String[] names = propName.split("\\.");
		int len = names.length;
		if (len > 1) {
			// 有对象导航
			for (int i = 0; i < len - 1; i++) {
				Criteria ct = getCritria(criteria, names[i]); 
				if(ct == null) {
					cc = cc.createCriteria(names[i], names[i]);
				} else {
					cc = ct;
				}
			}
			// 属性名为数组最后一个元素
			propName = names[len - 1];
		}
		Object value = filter.getValue();
		MatchType type = filter.getMatchType();
		if (type == MatchType.EQ) {
			cc.add(Restrictions.eq(propName, value));
		} else if (type == MatchType.LK) {
			cc.add(Restrictions.like(propName, (String)value, MatchMode.ANYWHERE));
		} else if (type == MatchType.STARTLK) {
			cc.add(Restrictions.like(propName, (String)value, MatchMode.START));
		} else if (type == MatchType.GT) {
			cc.add(Restrictions.gt(propName, value));
		} else if (type == MatchType.GE) {
			cc.add(Restrictions.ge(propName, value));
		} else if (type == MatchType.LT) {
			cc.add(Restrictions.lt(propName, value));
		} else if (type == MatchType.LE) {
			cc.add(Restrictions.le(propName, value));
		} else if(type == MatchType.NE) {
			cc.add(Restrictions.ne(propName, value));
		} else if(type == MatchType.IN) {
			if(value instanceof String) {
				List ls = StringUtil.idInStrToArr(value.toString());
				cc.add(Restrictions.in(propName, ls));
			} else if((value instanceof Collection)) {
				cc.add(Restrictions.in(propName, (Collection)value));
			} else {
				cc.add(Restrictions.in(propName, (Object[])value));
			}
		}
	}

	/**
	 * 按属性条件列表创建Criterion数组,辅助函数.
	 */
	protected Criteria buildCriterionByStringPropertyFilter(final List<StringPropertyFilter> filters) {
		Criteria criteria = getSession().createCriteria(entityClass);
		criteria.setCacheable(true);
		for (StringPropertyFilter filter : filters) {
			if (!filter.hasMultiProperties()) { //只有一个属性需要比较的情况.
				appendCriteria(criteria, filter.getPropertyName(), filter.getMatchValue(), filter.getMatchType());
			} else {//包含多个属性需要比较的情况,进行or处理.
				Disjunction disjunction = Restrictions.disjunction();
				for (String param : filter.getPropertyNames()) {
					appendCriteria(criteria, param, filter.getMatchValue(), filter.getMatchType());
					criteria.add(disjunction);
				}
			}
		}
		return criteria;
	}
	
	/**
	 * 按属性条件列表创建Criterion数组,辅助函数. 同上一个方法参数不同
	 */
	protected Criteria buildCriterionByPropertyFilter(List<PropertyFilter> filters) {
		Criteria criteria = getSession().createCriteria(entityClass);
		criteria.setCacheable(true);
		for (PropertyFilter filter : filters) {
			String propertyName = filter.getPropertyName();

			boolean multiProperty = StringUtils.contains(propertyName, "|");
			if (!multiProperty) { //properNameName中只有一个属性的情况.
				appendCriteria(criteria, propertyName, filter.getValue(), filter.getMatchType());
			} else {//properName中包含多个属性的情况,进行or处理.
				Disjunction disjunction = Restrictions.disjunction();
				String[] params = StringUtils.split(propertyName, '|');

				for (String param : params) {
					appendCriteria(criteria, param, filter.getValue(), filter.getMatchType());
					criteria.add(disjunction);
				}
			}
		}
		return criteria;
	}
}
