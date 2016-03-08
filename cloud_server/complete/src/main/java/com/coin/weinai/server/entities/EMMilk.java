package com.coin.weinai.server.entities;

import com.fasterxml.jackson.databind.node.ObjectNode;

abstract class EMMilk extends EMActivityBase {
	int ml;

	int getMl() {
		return ml;
	}

	void setMl(int ml) {
		this.ml = ml;
	}
	
	boolean equals(EMMilk milk) {
		boolean ret = false;
		
		if (super.equals(milk)) {
			if (ml == milk.getMl()) {
				ret = true;
			}
		}
		
		return ret;
	}
	
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
	String getAccount() {
		return super.getAccount();
	}
	void setAccount(String account) {
		super.setAccount(account);
	}
	EMActivityType getType() {
		return super.getType();
	}
	void setType(EMActivityType type) {
		super.setType(type);
	}
	
	ObjectNode toJsonNode() {
		ObjectNode ret = super.toJsonNode();
		
		ret.put("ml", ml);
		
		return ret;
	}
}
