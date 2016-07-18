package com.kzw.gym.entity;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.kzw.system.entity.Department;
import com.kzw.system.entity.Dictionary;

@Entity
@Table(name="gym_emp")
public class Employee {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;
	
	//姓名
	private String name;
	
	//性别
	@ManyToOne
	@JoinColumn(name="dict_sex")
	private Dictionary sex;
	
	//年龄
	private Integer age;
	//部门
	@ManyToOne
	@JoinColumn(name="dept_id")
	private Department dept;
	
	//职位
	@ManyToOne
	@JoinColumn(name="dict_job")
	private Dictionary job;
	
	//教练有学员
	@OneToMany(mappedBy="coach")
	private Set<Member> members = new HashSet<Member>();
	
	private String address;
	
	private String phone;
	
	private String imgUrl;
	
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}



	
	public Department getDept() {
		return dept;
	}

	public void setDept(Department dept) {
		this.dept = dept;
	}

	public Integer getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public Dictionary getSex() {
		return sex;
	}

	public Integer getAge() {
		return age;
	}

	public Dictionary getJob() {
		return job;
	}

	public Set<Member> getMembers() {
		return members;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setSex(Dictionary sex) {
		this.sex = sex;
	}

	public void setAge(Integer age) {
		this.age = age;
	}

	public void setJob(Dictionary job) {
		this.job = job;
	}

	public void setMenbers(Set<Member> menbers) {
		this.members = menbers;
	}

	public void setMembers(Set<Member> members) {
		this.members = members;
	}

	public String getImgUrl() {
		return imgUrl;
	}

	public void setImgUrl(String imgUrl) {
		this.imgUrl = imgUrl;
	}
	
	
}
