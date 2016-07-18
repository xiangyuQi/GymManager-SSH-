package com.kzw.gym.entity;


import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import com.kzw.system.entity.Dictionary;

@Entity
@Table(name="gym_card")
public class Card {

	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Integer id;
	
	//会员卡号
	private String cardNo;

	
	//会员卡等级(白银,黄金,钻石)
	@ManyToOne
	@JoinColumn(name="dict_level")
	private Dictionary level;
	//开卡日期
	private Date beginTime;
	//到期日期
	private Date endTime;
	
	//办卡金额
	private Double amount;
	
	@OneToOne(mappedBy="card")
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

	public String getCardNo() {
		return cardNo;
	}

	public Dictionary getLevel() {
		return level;
	}

	public Date getBeginTime() {
		return beginTime;
	}

	public Date getEndTime() {
		return endTime;
	}

	public Member getMember() {
		return member;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	public void setLevel(Dictionary level) {
		this.level = level;
	}

	public void setBeginTime(Date beginTime) {
		this.beginTime = beginTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	public void setMember(Member menber) {
		this.member = menber;
	}
	
}
