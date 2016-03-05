package com.coin.weinai.server.managers;

import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.coin.weinai.server.entities.EMActivityBase;
import com.coin.weinai.server.entities.EMExcrement;
import com.coin.weinai.server.entities.EMExcrementRep;
import com.coin.weinai.server.entities.EMPersonMilk;
import com.coin.weinai.server.entities.EMPersonMilkRep;
import com.coin.weinai.server.entities.EMPiss;
import com.coin.weinai.server.entities.EMPissRep;
import com.coin.weinai.server.entities.EMPowderMilk;
import com.coin.weinai.server.entities.EMPowderMilkRep;
import com.coin.weinai.server.entities.EMSleep;
import com.coin.weinai.server.entities.EMSleepRep;

@Component
public class ActivityManagerImp implements IActivityManager {
	@Autowired
	private EMExcrementRep excrementRep;
	
	@Autowired
	private EMPersonMilkRep personMilkRep;
	
	@Autowired
	private EMPowderMilkRep powderMilkRep;
	
	@Autowired
	private EMPissRep pissRep;
	
	@Autowired
	private EMSleepRep sleepRep;
	
	public List<EMActivityBase> getActivities(String account, Date from, Date to) {
		List<EMActivityBase> ret = new LinkedList<EMActivityBase>();
		
		InfoCenter info = InfoCenter.getInstance();
		String username = info.getCurrentAccount().getUsername();
		
		List<EMExcrement> excrements = excrementRep.findByAccountAndTimeBetween(account, from, to);
		ret.addAll(excrements);
		
		List<EMPersonMilk> personMilks = personMilkRep.findByAccountAndFromGreaterThanAndToLessThan(account, from, to);
		ret.addAll(personMilks);
		
		List<EMPowderMilk> powderMilks = powderMilkRep.findByAccountAndFromGreaterThanAndToLessThan(account, from, to);
		ret.addAll(powderMilks);
		
		List<EMPiss> pisses = pissRep.findByAccountAndFromGreaterThanAndToLessThan(account, from, to);
		ret.addAll(pisses);
		
		List<EMSleep> sleeps = sleepRep.findByAccountAndFromGreaterThanAndToLessThan(account, from, to);
		ret.addAll(sleeps);
				
		return ret;
	}

//	@Override
//	public boolean addDailyActivity(EMDailyActivity daily) {
//		// TODO Auto-generated method stub
//		return false;
//	}
//
//	@Override
//	public boolean removeDailyActivity(Date time) {
//		// TODO Auto-generated method stub
//		return false;
//	}
//
//	@Override
//	public int addDailyActivities(List<EMDailyActivity> activities) {
//		// TODO Auto-generated method stub
//		return 0;
//	}
//
//	@Override
//	public int removeDailyActivities(List<EMDailyActivity> activities) {
//		// TODO Auto-generated method stub
//		return 0;
//	}
//
//	@Override
//	public int removeDailyActivitiesByDate(Date from, Date to) {
//		// TODO Auto-generated method stub
//		return 0;
//	}

}
