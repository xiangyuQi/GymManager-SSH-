package com.kzw.gym.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import com.kzw.system.entity.Dictionary;

@Entity
@Table(name="gym_goods")
public class Goods {

	@Id
	@GeneratedValue
	private Integer id;
	
	//名称
	private String name;
	//类别
	@ManyToOne
	@JoinColumn(name="dict_category")
	private Dictionary category;
	//价格
	private String price;
	//详细说明
	private String detail;
	//图片
	private String imgUrl;
	//库存量
	private int stock;
	
	
	public Dictionary getCategory() {
		return category;
	}
	public void setCategory(Dictionary category) {
		this.category = category;
	}
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
	
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}
	public String getDetail() {
		return detail;
	}
	public void setDetail(String detail) {
		this.detail = detail;
	}
	public String getImgUrl() {
		return imgUrl;
	}
	public void setImgUrl(String img) {
		this.imgUrl = img;
	}
	public int getStock() {
		return stock;
	}
	public void setStock(int stock) {
		this.stock = stock;
	}
}
