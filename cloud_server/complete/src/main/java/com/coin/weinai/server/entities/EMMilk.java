package com.coin.weinai.server.entities;

class EMMilk extends EMActivityBase {
	int ml;

	boolean equals(EMMilk milk) {
		boolean ret = false;
		
		if (super.equals(milk)) {
			if (ml == milk.ml) {
				ret = true;
			}
		}
		
		return ret;
	}
	
	int getMl() {
		return ml;
	}

	void setMl(int ml) {
		this.ml = ml;
	}
}
