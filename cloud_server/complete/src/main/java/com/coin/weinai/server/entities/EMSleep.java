package com.coin.weinai.server.entities;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import com.fasterxml.jackson.databind.node.ObjectNode;

@Entity
@Table(name = "sleep")
public class EMSleep extends EMActivityBase {	
	int durationInMinutes;
	EMSleepQuality quality;
	
	boolean equals(EMSleep sleep) {
		boolean ret = false;
		
		if (super.equals(sleep)) {
			if (durationInMinutes == sleep.getDurationInMinutes() &&
				quality == sleep.getQuality()) {
				ret = true;
			}
		}
		
		return ret;
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
		return EMActivityType.Sleep;
	}
	public void setType(EMActivityType type) {
	}
	
	@Id
	long getId() {
		return super.getId();
	}
	void setId(long id) {
		super.setId(id);
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
		ObjectNode node = super.toJsonNode();
		
		node.put("quality", getQuality().ordinal());
		node.put("durationInMinutes", getDurationInMinutes());
		node.put("type", getType().toString());
		
		return node;
	}
}
