package com.coin.weinai.server.entities;

import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "POWDERMILK")
class EMPowderMilk extends EMMilk {
	String brand;

	boolean equals(EMPowderMilk powderMilk) {
		boolean ret = false;
		
		if (super.equals(powderMilk)) {
			if (brand.equals(powderMilk.brand)) {
				ret = true;
			}
		}
		
		return ret;
	}
	
	String getBrand() {
		return brand;
	}

	void setBrand(String brand) {
		this.brand = brand;
	}
}
