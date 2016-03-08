package com.coin.weinai.server.entities;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

abstract class EMActivityBase {
	String memo;
	long time;
	String account;
	EMActivityType type;
	long id;
	
	boolean equals(EMActivityBase activity) {
		boolean ret = false;
		
		if (memo.equals(activity.getMemo()) &&
			time == activity.getTime() &&
			account.equals(activity.getAccount()) &&
			type == activity.getType()) {
			ret = true;
		}
		
		return ret;
	}

	String getMemo() {
		return memo;
	}

	void setMemo(String memo) {
		this.memo = memo;
	}

	long getTime() {
		return time;
	}

	void setTime(long time) {
		this.time = time;
	}

	String getAccount() {
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
	
	ObjectNode toJsonNode() {
		ObjectMapper mapper = new ObjectMapper();
		ObjectNode ret = mapper.createObjectNode();
		
		ret.put("memo", getMemo());
		ret.put("time", getTime());
		ret.put("account", getAccount());
		
		return ret;
	}
}
