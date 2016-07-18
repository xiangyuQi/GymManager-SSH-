package com.kzw.system.entity;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

/**
 * 登陆用户
 */
@Entity
@Table(name = "sys_appuser")
public class AppUser {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;
	// 账号
	private String uname;
	// 密码
	private String passwd;
	// 真实姓名
	private String realName;
	// 状态: 0(正常), 1(禁用)
	private int status;
	// 创建日期
	private Date ctime = new Date();
	// 性别
	@ManyToOne
	@JoinColumn(name = "dict_sex")
	private Dictionary sex;

	// 所属部门
	@ManyToOne
	@JoinColumn(name = "dept_id")
	private Department dept;

	// 多个角色：
	private String roleIds;
	private String roleNames;

	public String getRoleIds() {
		return roleIds;
	}

	public void setRoleIds(String roleIds) {
		this.roleIds = roleIds;
	}

	public String getRoleNames() {
		return roleNames;
	}

	public void setRoleNames(String roleNames) {
		this.roleNames = roleNames;
	}

	public AppUser() {
	}

	public AppUser(Integer id) {
		this.id = id;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getUname() {
		return uname;
	}

	public void setUname(String uname) {
		this.uname = uname;
	}

	public String getPasswd() {
		return passwd;
	}

	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}

	public String getRealName() {
		return realName;
	}

	public void setRealName(String realName) {
		this.realName = realName;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public Dictionary getSex() {
		return sex;
	}

	public void setSex(Dictionary sex) {
		this.sex = sex;
	}

	public Department getDept() {
		return dept;
	}

	public void setDept(Department dept) {
		this.dept = dept;
	}

	public Date getCtime() {
		return ctime;
	}

	public void setCtime(Date ctime) {
		this.ctime = ctime;
	}

}
