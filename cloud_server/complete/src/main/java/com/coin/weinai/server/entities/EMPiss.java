package com.coin.weinai.server.entities;

import javax.persistence.Entity;
import javax.persistence.Table;

enum EMPissColor {
    PissColor_White,
    PissColor_Yellow
}

@Entity
@Table(name = "PISS")
class EMPiss extends EMActivityBase {
	int ml; 
	EMPissColor color;
	
	boolean equals(EMPiss piss) {
		boolean ret = false;
		
		if (super.equals(piss)) {
			if (ml == piss.ml &&
				color == piss.color) {
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
	EMPissColor getColor() {
		return color;
	}
	void setColor(EMPissColor color) {
		this.color = color;
	}
}
