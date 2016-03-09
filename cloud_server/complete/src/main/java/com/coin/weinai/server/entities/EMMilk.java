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
	
	ObjectNode toJsonNode() {
		ObjectNode ret = super.toJsonNode();
		
		ret.put("ml", ml);
		
		return ret;
	}
}
