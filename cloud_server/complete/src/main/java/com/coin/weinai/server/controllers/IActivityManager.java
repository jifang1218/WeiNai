package com.coin.weinai.server.controllers;

import java.util.Date;
import java.util.List;
import com.coin.weinai.server.entities.*;

interface IActivityManager {
	List<EMDailyActivity> getDailyActivities(Date from, Date to); 
	boolean addDailyActivity(EMDailyActivity daily);
	boolean removeDailyActivity(Date time);
	int addDailyActivities(List<EMDailyActivity> activities);
	int removeDailyActivities(List<EMDailyActivity> activities);
	int removeDailyActivitiesByDate(Date from, Date to);
}
