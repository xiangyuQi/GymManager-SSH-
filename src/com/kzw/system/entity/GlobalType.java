package com.kzw.system.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 全局类型
 */
@Entity
@Table(name="sys_global_type")
public class GlobalType {
	/**
	 * 代表产品分类
	 */
	public static final String CAT_PRODUCT_TYPE = "PT";
	/**
	 * 计量分类
	 */
	public static final String CAT_CAL_UNIT = "CT";
	/**
	 * 数字字典
	 */
	public static final String CAT_DICTIONARY = "DIC";

	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	protected Integer proTypeId;
	// 类型名称
	protected String typeName;
	// 路径
	protected String path;
	// 深度
	protected Integer depth;
	// 父结点
	protected Integer parentId;
	protected String nodeKey;
	protected String catKey;
	protected Integer sn;
	protected Integer userId;

	public GlobalType() {
	}

	public GlobalType(Integer proTypeId) {
		this.proTypeId = proTypeId;
	}

	public Integer getProTypeId() {
		return proTypeId;
	}

	public void setProTypeId(Integer proTypeId) {
		this.proTypeId = proTypeId;
	}

	public String getTypeName() {
		return typeName;
	}

	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public Integer getDepth() {
		return depth;
	}

	public void setDepth(Integer depth) {
		this.depth = depth;
	}

	public Integer getParentId() {
		if(parentId == 0) return null;
		return parentId;
	}

	public void setParentId(Integer parentId) {
		this.parentId = parentId;
	}

	public String getNodeKey() {
		return nodeKey;
	}

	public void setNodeKey(String nodeKey) {
		this.nodeKey = nodeKey;
	}

	public String getCatKey() {
		return catKey;
	}

	public void setCatKey(String catKey) {
		this.catKey = catKey;
	}

	public Integer getSn() {
		return sn;
	}

	public void setSn(Integer sn) {
		this.sn = sn;
	}

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	public boolean getLoaded() {
		return true;
	}
}
