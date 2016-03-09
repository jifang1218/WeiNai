package com.coin.weinai.server.entities;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import com.fasterxml.jackson.databind.node.ObjectNode;

@Entity
@Table(name = "piss")
public class EMPiss extends EMActivityBase {
	int ml;
	EMPissColor color;
	
	boolean equals(EMPiss piss) {
		boolean ret = false;
		
		if (super.equals(piss)) {
			if (ml == piss.getMl() &&
				color == piss.getColor()) {
				ret = true;
			}
		}
		
		return ret;
	}
	
	@Id
	long getId() {
		return super.getId();
	}
	void setId(long id) {
		super.setId(id);
	}
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
		ObjectNode node = super.toJsonNode();
		
		node.put("ml", getMl());
		node.put("color", getColor().toString());
		
		return node;
	}
}
