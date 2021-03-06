package com.coin.weinai.server.entities;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import com.fasterxml.jackson.databind.node.ObjectNode;

@Entity
@Table(name = "powdermilk")
public class EMPowderMilk extends EMMilk {
	String brand;
	
	String getMemo() {
		return super.getMemo();
	}

	void setMemo(String memo) {
		super.setMemo(memo);
	}

	public long getTime() {
		return super.getTime();
	}

	void setTime(long time) {
		super.setTime(time);
	}

	public String getAccount() {
		return super.getAccount();
	}

	void setAccount(String account) {
		super.setAccount(account);
	}

	EMActivityType getType() {
		return super.getType();
	}

	public void setType(EMActivityType type) {
		super.setType(type);
	}

	int getMl() {
		return super.getMl();
	}

	void setMl(int ml) {
		super.setMl(ml);
	}

	String getBrand() {
		return brand;
	}

	void setBrand(String brand) {
		this.brand = brand;
	}

	@Id
	long getId() {
		return super.getId();
	}

	void setId(long id) {
		super.setId(id);
	}
	
	public ObjectNode toJsonNode() {
		ObjectNode ret = super.toJsonNode();
		
		ret.put("brand", getBrand());
		
		return ret;
	}
}
