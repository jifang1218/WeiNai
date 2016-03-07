package com.coin.weinai.server.entities;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

@Entity
@Table(name = "powdermilk")
public class EMPowderMilk {
	String memo;
	long time;
	String account;
	EMActivityType type;
	
	int ml;
	String brand;
	
	@Id
	long id;

	String getMemo() {
		return memo;
	}

	void setMemo(String memo) {
		this.memo = memo;
	}

	public long getTime() {
		return time;
	}

	void setTime(long time) {
		this.time = time;
	}

	public String getAccount() {
		return account;
	}

	void setAccount(String account) {
		this.account = account;
	}

	EMActivityType getType() {
		return type;
	}

	void setType(EMActivityType type) {
		this.type = type;
	}

	int getMl() {
		return ml;
	}

	void setMl(int ml) {
		this.ml = ml;
	}

	String getBrand() {
		return brand;
	}

	void setBrand(String brand) {
		this.brand = brand;
	}

	long getId() {
		return id;
	}

	void setId(long id) {
		this.id = id;
	}
	
	public ObjectNode toJsonNode() {
		ObjectMapper mapper = new ObjectMapper();
		ObjectNode ret = mapper.createObjectNode();
		
		ret.put("memo", getMemo());
		ret.put("time", getTime());
		ret.put("account", getAccount());
		ret.put("type", getType().ordinal());
		ret.put("ml", getMl());
		ret.put("brand", getBrand());
		
		return ret;
	}

	public void setActivityType(EMActivityType powdermilk) {
		// TODO Auto-generated method stub
		
	}
}
