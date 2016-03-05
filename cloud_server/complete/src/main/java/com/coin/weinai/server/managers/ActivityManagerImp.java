package com.coin.weinai.server.managers;

import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.coin.weinai.server.entities.EMActivityBase;
import com.coin.weinai.server.entities.EMExcrement;
import com.coin.weinai.server.entities.EMExcrementRep;

@Component
public class ActivityManagerImp implements IActivityManager {
	@Autowired
	private EMExcrementRep excrementRep;
	
	@Override
	public List<EMActivityBase> getActivities(String account, long from, long to) {
		List<EMActivityBase> ret = new LinkedList<EMActivityBase>();
		
		List<EMExcrement> excrements = excrementRep.findByAccountAndTimeBetween(account, from, to);
		ret.addAll(excrements);
		
		return ret;
	}

	@Override
	public boolean addExcrement(EMExcrement excrement) {
		boolean ret = false;
		excrementRep.save(excrement);
		ret = true;
		
		return ret;
	}
}
