package com.coin.weinai.server.entities;

import java.util.Date;
import java.util.LinkedList;
import java.util.List;

public class EMDailyActivity {
	Date time;
	List<EMActivityBase> activities = new LinkedList<EMActivityBase>();
	public Date getTime() {
		return time;
	}
	void setTime(Date time) {
		this.time = time;
	}
	List<EMActivityBase> getActivities() {
		return activities;
	}
	void setActivities(List<EMActivityBase> activities) {
		this.activities = activities;
	}
	
	@SuppressWarnings("deprecation")
	boolean addActivity(EMActivityBase activity) {
		boolean ret = false;

		if(activity.time.getYear() == time.getYear() &&
		   activity.time.getMonth() == time.getMonth() &&
		   activity.time.getDate() == time.getDate()) {
			if (!activities.contains(activity)) {
				activities.add(activity);
			}
		}
		
		return ret;
	}
	
	boolean removeActivity(EMActivityBase activity) {
		boolean ret = false;
		
		if(activity.time.getYear() == time.getYear() &&
		   activity.time.getMonth() == time.getMonth() &&
		   activity.time.getDate() == time.getDate()) {
			if (activities.contains(activity)) {
				activities.remove(activity);
			}
		}
		
		return ret;
	}
}
