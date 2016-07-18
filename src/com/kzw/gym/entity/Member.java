package com.kzw.gym.entity;



import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;








import com.kzw.system.entity.Dictionary;

@Entity
@Table(name="gym_member")
public class Member {
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Integer id;
	
	//姓名
	private String name;
	
	//性别
	@ManyToOne
	@JoinColumn(name="dict_sex")
	private Dictionary sex;
	//年龄
	private Integer age;
	//联系方式
	private String phone;
	//身高
	private Double height;
	//体重
	private Double weight;
	//会员照片URL地址
	private String imgUrl;
	//会员卡
	@OneToOne
	@JoinColumn(name="card_id")
	private Card card;
	
	//私人教练
	@ManyToOne
	@JoinColumn(name="coach_id")
	private Employee coach;
	
	//拥有多个固定私人租柜
	@OneToMany(mappedBy="member")
	private Set<Lockers>lockers = new HashSet<Lockers>();

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Dictionary getSex() {
		return sex;
	}

	public void setSex(Dictionary sex) {
		this.sex = sex;
	}

	public Integer getAge() {
		return age;
	}

	public void setAge(Integer age) {
		this.age = age;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public Double getHeight() {
		return height;
	}

	public void setHeight(Double height) {
		this.height = height;
	}

	public Double getWeight() {
		return weight;
	}

	public void setWeight(Double weight) {
		this.weight = weight;
	}

	public Card getCard() {
		return card;
	}

	public void setCard(Card card) {
		this.card = card;
	}

	public Employee getCoach() {
		return coach;
	}

	public void setCoach(Employee coach) {
		this.coach = coach;
	}



	public String getImgUrl() {
		return imgUrl;
	}

	public void setImgUrl(String imgUrl) {
		this.imgUrl = imgUrl;
	}

	public Set<Lockers> getLockers() {
		return lockers;
	}

	public void setLockers(Set<Lockers> lockers) {
		this.lockers = lockers;
	}

	


}
