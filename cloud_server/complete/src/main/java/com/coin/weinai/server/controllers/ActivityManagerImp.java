package com.coin.weinai.server.controllers;

import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import com.coin.weinai.server.entities.EMDailyActivity;

class ActivityManagerImp implements IActivityManager {
	List<EMDailyActivity> dailyActivities = new LinkedList<EMDailyActivity>();

	@SuppressWarnings("deprecation")
	@Override
	public List<EMDailyActivity> getDailyActivities(Date from, Date to) {
		List<EMDailyActivity> ret = new LinkedList<EMDailyActivity>();
		
		int count = dailyActivities.size();
		for(int i=0; i<count; ++i) {
			EMDailyActivity daily = dailyActivities.get(i);
			Date fromDate = new Date();
			fromDate.setYear(from.getYear());
			fromDate.setMonth(from.getMonth());
			fromDate.setDate(from.getDate());
			fromDate.setHours(0);;
			fromDate.setMinutes(0);
			fromDate.setSeconds(0);
			
			Date toDate = new Date();
			toDate.setYear(to.getYear());
			toDate.setMonth(to.getMonth());
			toDate.setDate(to.getDate());
			toDate.setHours(23);;
			toDate.setMinutes(59);
			toDate.setSeconds(59);
			
			if (daily.getTime().getTime() >= fromDate.getTime() &&
				daily.getTime().getTime() <= toDate.getTime()) {
				ret.add(daily);
			}
		}
				
		return ret;
	}

	@Override
	public boolean addDailyActivity(EMDailyActivity daily) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean removeDailyActivity(Date time) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public int addDailyActivities(List<EMDailyActivity> activities) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int removeDailyActivities(List<EMDailyActivity> activities) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int removeDailyActivitiesByDate(Date from, Date to) {
		// TODO Auto-generated method stub
		return 0;
	}

}
