package com.coin.weinai.server.entities;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

enum EMExcrementQuality {
    ExcrementQualityGood,
    ExcrementQualityBad
} 

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
	long getTime() {
		return time;
	}
	void setTime(long time) {
		this.time = time;
	}
	String getMemo() {
		return memo;
	}
	void setMemo(String memo) {
		this.memo = memo;
	}
	EMActivityType getType() {
		return type;
	}
	void setType(EMActivityType type) {
		this.type = type;
	}
	public String getAccount() {
		return account;
	}
	void setAccount(String account) {
		this.account = account;
	}
	int getWeight() {
		return weight;
	}
	void setWeight(int weight) {
		this.weight = weight;
	}
	EMExcrementQuality getQuality() {
		return quality;
	}
	void setQuality(EMExcrementQuality quality) {
		this.quality = quality;
	}
}
