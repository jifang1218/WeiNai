package com.coin.weinai.server.entities;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import com.fasterxml.jackson.databind.node.ObjectNode;

@Entity
@Table(name = "personmilk")
public class EMPersonMilk extends EMMilk {
	String person;
	
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

	@Id
	long getId() {
		return super.getId();
	}

	void setId(long id) {
		super.setId(id);
	}
	
	public ObjectNode toJsonNode() {
		ObjectNode ret = super.toJsonNode();
		
		ret.put("person", person);
		
		return ret;
	}
	
	String getPerson() {
		return person;
	}

	void setPerson(String person) {
		this.person = person;
	}
}
