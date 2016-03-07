package com.coin.weinai.server.entities;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

@Entity
@Table(name = "excrement")
public
class EMExcrement extends EMActivityBase {
	int weight;
	EMExcrementQuality quality;
	String memo;
	long time;
	String account;
	EMActivityType type;
	
	@Id
	long id;
	
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
	
	long getId() {
		return id;
	}
	void setId(long id) {
		this.id = id;
	}
	public long getTime() {
		return time;
	}
	public void setTime(long time) {
		this.time = time;
	}
	String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	public EMActivityType getType() {
		return type;
	}
	public void setType(EMActivityType type) {
		this.type = type;
	}
	public String getAccount() {
		return account;
	}
	public void setAccount(String account) {
		this.account = account;
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
		ObjectMapper mapper = new ObjectMapper();
		ObjectNode ret = mapper.createObjectNode();
		
		ret.put("weight", getWeight());
		ret.put("quality", getQuality().ordinal());
		ret.put("memo", getMemo());
		ret.put("time", getTime());
		ret.put("account", getAccount());
		ret.put("type", getType().ordinal());
		
		return ret;
	}
}
