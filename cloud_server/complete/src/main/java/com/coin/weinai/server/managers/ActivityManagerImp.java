package com.coin.weinai.server.managers;

import java.util.LinkedList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.coin.weinai.server.entities.EMActivityBase;
import com.coin.weinai.server.entities.EMActivityType;
import com.coin.weinai.server.entities.EMExcrement;
import com.coin.weinai.server.entities.EMExcrementRep;

@Component
public class ActivityManagerImp implements IActivityManager {
	@Autowired
	private EMExcrementRep excrementRep;
	
	private boolean containsActivity(String account, EMActivityType type, long time) {
		boolean ret = false;
		
		List<EMExcrement> excrements = excrementRep.findByAccountAndTypeAndTime(account, type, time);
		if (excrements.size() > 0) {
			ret = true;
		}
		
		return ret;
	}	
	
	public EMExcrement getActivity(String account, EMActivityType type, long time) {
		EMExcrement ret = null;
		
		List<EMExcrement> excrements = excrementRep.findByAccountAndTypeAndTime(account, type, time);
		if (excrements.size() > 0) {
			ret = excrements.get(0);
		}
		
		return ret;
	}
	
	@Override
	public List<EMActivityBase> getActivities(String account, EMActivityType type, long from, long to) {
		List<EMActivityBase> ret = new LinkedList<EMActivityBase>();
		
		List<EMExcrement> excrements = excrementRep.findByAccountAndTypeAndTimeBetween(account, type, from, to);
		ret.addAll(excrements);
		
		return ret;
	}

	@Override
	public boolean addExcrement(EMExcrement excrement) {
		boolean ret = false;
		
		if (!containsActivity(excrement.getAccount(), excrement.getType(), excrement.getTime())) {
			excrementRep.save(excrement);
			ret = true;
		}
		
		return ret;
	}

	@Override
	public boolean updateExcrement(EMExcrement excrement) {
		boolean ret = false;
		
		if (containsActivity(excrement.getAccount(), excrement.getType(), excrement.getTime())) {
			EMExcrement beUpdated = null;
			beUpdated = getActivity(excrement.getAccount(), excrement.getType(), excrement.getTime());
			if (beUpdated != null) {
				excrementRep.save(excrement);
				ret = true;
			}
		}
		
		return ret;	
	}

	@Override
	public boolean deleteExcrement(String account, EMActivityType type, long time) {
		boolean ret = false;
		
		EMExcrement excrement = null;
		excrement = getActivity(account, type, time);
		if (excrement != null) {
			excrementRep.delete(excrement);
			ret = true;
		}
		
		return ret;
	}
}
