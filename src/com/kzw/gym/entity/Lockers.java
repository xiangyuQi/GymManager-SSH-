package com.kzw.gym.entity;

import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;
//固定租用衣柜
@Entity
@Table(name="gym_lockers")
public class Lockers {
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Integer id;
	
	//柜子 编号
	private String no;
	
	//租用日期
	private Date beginTime;
	//到期日期
	private Date endTime;
		
	//租用金额
	private Double amount;
	
	
	//用户有0-N个租柜
	@ManyToOne
	@JoinColumn(name="member_id")
	private Member member;

	
	public Double getAmount() {
		return amount;
	}

	public void setAmount(Double amount) {
		this.amount = amount;
	}

	public Integer getId() {
		return id;
	}

	public String getNo() {
		return no;
	}

	public Date getBeginTime() {
		return beginTime;
	}

	public void setBeginTime(Date beginTime) {
		this.beginTime = beginTime;
	}

	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public void setNo(String no) {
		this.no = no;
	}

	public Member getMember() {
		return member;
	}

	public void setMember(Member member) {
		this.member = member;
	}



}
