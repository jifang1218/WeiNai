package com.coin.weinai.server.entities;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

enum EMSleepQuality {
    SleepQuality_Medium,
    SleepQuality_Shallow,
    SleepQuality_Deep
}

@Entity
@Table(name = "SLEEP")
public
class EMSleep extends EMActivityBase {
	int durationInMinutes;
	EMSleepQuality quality;
	
	boolean equals(EMSleep sleep) {
		boolean ret = false;
		
		if (super.equals(sleep)) {
			if (durationInMinutes == sleep.durationInMinutes &&
				quality == sleep.quality) {
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
	int getDurationInMinutes() {
		return durationInMinutes;
	}
	void setDurationInMinutes(int durationInMinutes) {
		this.durationInMinutes = durationInMinutes;
	}
	EMSleepQuality getQuality() {
		return quality;
	}
	void setQuality(EMSleepQuality quality) {
		this.quality = quality;
	}
}
