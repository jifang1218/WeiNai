package com.coin.weinai.server.entities;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import com.fasterxml.jackson.databind.node.ObjectNode;

@Entity
@Table(name = "excrement")
public
class EMExcrement extends EMActivityBase {
	int weight;
	EMExcrementQuality quality;
	
	boolean equals(EMExcrement excrement) {
		boolean ret = false;
		
		if (super.equals(excrement)) {
			if (weight == excrement.weight &&
				quality == excrement.quality) {
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
	public long getTime() {
		return super.getTime();
	}
	public void setTime(long time) {
		super.setTime(time);
	}
	String getMemo() {
		return super.getMemo();
	}
	public void setMemo(String memo) {
		super.setMemo(memo);
	}
	public EMActivityType getType() {
		return super.getType();
	}
	public void setType(EMActivityType type) {
		super.setType(type);
	}
	public String getAccount() {
		return super.getAccount();
	}
	public void setAccount(String account) {
		super.setAccount(account);
	}
	int getWeight() {
		return weight;
	}
	public void setWeight(int weight) {
		this.weight = weight;
	}
	EMExcrementQuality getQuality() {
		return quality;
	}
	public void setQuality(EMExcrementQuality quality) {
		this.quality = quality;
	}
	
	public ObjectNode toJsonNode() {
		ObjectNode ret = super.toJsonNode();
		
		ret.put("weight", getWeight());
		ret.put("quality", getQuality().ordinal());
		
		return ret;
	}
}
