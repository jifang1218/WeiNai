package com.coin.weinai.server.entities;

import java.util.Date;

import javax.persistence.Id;

enum EMActivityType {
	Milk, 
	Piss, 
	Excrement, 
	Sleep
}
	
public class EMActivityBase {
	String memo;
	Date time;
	
	EMActivityType type;
	
	boolean equals(EMActivityBase activity) {
		boolean ret = false;
		
		if (memo.equals(activity.memo) &&
			time.equals(activity.time) &&
			type == activity.type) {
			ret = true;
		}
		
		return ret;
	}
	Date getTime() {
		return time;
	}
	void setTime(Date time) {
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
}
