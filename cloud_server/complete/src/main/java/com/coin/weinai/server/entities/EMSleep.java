package com.coin.weinai.server.entities;

import javax.persistence.Entity;
import javax.persistence.Table;

enum EMSleepQuality {
    SleepQuality_Medium,
    SleepQuality_Shallow,
    SleepQuality_Deep
}

@Entity
@Table(name = "SLEEP")
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
