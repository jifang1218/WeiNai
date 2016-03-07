package com.coin.weinai.server.managers;

import java.util.LinkedList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.coin.weinai.server.entities.EMExcrement;
import com.coin.weinai.server.entities.EMExcrementRep;

@Component
public class ActivityManagerImp implements IActivityManager {
	@Autowired
	private EMExcrementRep excrementRep;
	
	private boolean containsExcrement(String account, long time) {
		boolean ret = false;
		
		List<EMExcrement> excrements = excrementRep.findByAccountAndTime(account, time);
		if (excrements.size() > 0) {
			ret = true;
		}
		
		return ret;
	}	
	
	public EMExcrement getExcrement(String account, long time) {
		EMExcrement ret = null;
		
		List<EMExcrement> excrements = excrementRep.findByAccountAndTime(account, time);
		if (excrements.size() > 0) {
			ret = excrements.get(0);
		}
		
		return ret;
	}
	
	@Override
	public List<EMExcrement> getExcrements(String account, long from, long to) {
		List<EMExcrement> ret = new LinkedList<EMExcrement>();
		
		List<EMExcrement> excrements = excrementRep.findByAccountAndTimeBetween(
				account, from, to);
		ret.addAll(excrements);

		return ret;
	}

	@Override
	public boolean addExcrement(EMExcrement excrement) {
		boolean ret = false;
		
		if (!containsExcrement(excrement.getAccount(), excrement.getTime())) {
			excrementRep.save(excrement);
			ret = true;
		}
		
		return ret;
	}

	@Override
	public boolean updateExcrement(EMExcrement excrement) {
		boolean ret = false;
		
		if (containsExcrement(excrement.getAccount(), excrement.getTime())) {
			EMExcrement beUpdated = null;
			beUpdated = getExcrement(excrement.getAccount(), excrement.getTime());
			if (beUpdated != null) {
				excrementRep.save(excrement);
				ret = true;
			}
		}
		
		return ret;	
	}

	@Override
	public boolean deleteExcrement(String account, long time) {
		boolean ret = false;
		
		EMExcrement excrement = null;
		excrement = getExcrement(account, time);
		if (excrement != null) {
			excrementRep.delete(excrement);
			ret = true;
		}
		
		return ret;
	}
}
