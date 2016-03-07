package com.coin.weinai.server.entities;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

@Entity
@Table(name = "piss")
public class EMPiss extends EMActivityBase {
	String memo;
	long time;
	String account;
	EMActivityType type;
	
	@Id
	long id;
	
	int ml;
	EMPissColor color;
	
	long getId() {
		return id;
	}
	void setId(long id) {
		this.id = id;
	}
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
	public void setType(EMActivityType type) {
		this.type = type;
	}
	int getMl() {
		return ml;
	}
	void setMl(int ml) {
		this.ml = ml;
	}
	EMPissColor getColor() {
		return color;
	}
	void setColor(EMPissColor color) {
		this.color = color;
	}
	public ObjectNode toJsonNode() {
		ObjectMapper mapper = new ObjectMapper();
		ObjectNode node = mapper.createObjectNode();
		node.put("memo", getMemo());
		node.put("time", getTime());
		node.put("account", getAccount());
		node.put("type", getType().ordinal());
		node.put("ml", getMl());
		node.put("color", getColor().ordinal());
		
		return node;
	}
}
