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
	
	@Id
	long id;
	long getId() {
		return id;
	}
	void setId(long id) {
		this.id = id;
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
