package com.coin.weinai.server.entities;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

@Entity
@Table(name = "piss")
public class EMSleep {
	String memo;
	long time;
	String account;
	EMActivityType type;
	
	@Id
	long id;
	
	int durationInMinutes;
	EMSleepQuality quality;
	
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
	long getId() {
		return id;
	}
	void setId(long id) {
		this.id = id;
	}
	int getDurationInMinutes() {
		return durationInMinutes;
	}
	void setDurationInMinutes(int durationInMinutes) {
		this.durationInMinutes = durationInMinutes;
	}
	EMSleepQuality getQuality() {
		return quality;
	}
	void setQuality(EMSleepQuality quality) {
		this.quality = quality;
	}
	
	public ObjectNode toJsonNode() {
		ObjectMapper mapper = new ObjectMapper();
		ObjectNode node = mapper.createObjectNode();
		node.put("memo", getMemo());
		node.put("time", getTime());
		node.put("account", getAccount());
		node.put("type", getType().ordinal());
		node.put("quality", getQuality().ordinal());
		node.put("durationInMinutes", getDurationInMinutes());
		
		return node;
	}
	public void setActivityType(EMActivityType sleep) {
		// TODO Auto-generated method stub
		
	}
}
