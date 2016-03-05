package com.coin.weinai.server.entities;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "POWDERMILK")
public
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
	
	@Id
	long id;
	long getId() {
		return id;
	}
	void setId(long id) {
		this.id = id;
	}
	String getBrand() {
		return brand;
	}

	void setBrand(String brand) {
		this.brand = brand;
	}
}
