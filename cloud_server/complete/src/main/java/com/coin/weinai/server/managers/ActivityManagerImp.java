package com.coin.weinai.server.managers;

import java.util.LinkedList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.coin.weinai.server.entities.EMExcrement;
import com.coin.weinai.server.entities.EMExcrementRep;
import com.coin.weinai.server.entities.EMPiss;
import com.coin.weinai.server.entities.EMPissRep;
import com.coin.weinai.server.entities.EMSleep;
import com.coin.weinai.server.entities.EMSleepRep;

@Component
public class ActivityManagerImp implements IActivityManager {
	@Autowired
	private EMExcrementRep excrementRep;
	
	@Autowired
	private EMPissRep pissRep;
	
	@Autowired
	private EMSleepRep sleepRep;
	
	private boolean containsExcrement(String account, long time) {
		boolean ret = false;
		
		List<EMExcrement> excrements = excrementRep.findByAccountAndTime(account, time);
		if (excrements.size() > 0) {
			ret = true;
		}
		
		return ret;
	}
	
	private boolean containsPiss(String account, long time) {
		boolean ret = false;
		
		List<EMPiss> pisses = pissRep.findByAccountAndTime(account, time);
		if (pisses.size() > 0) {
			ret = true;
		}
		
		return ret;
	}
	
	private boolean containsSleep(String account, long time) {
		boolean ret = false;
		
		List<EMSleep> sleeps = sleepRep.findByAccountAndTime(account, time);
		if (sleeps.size() > 0) {
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

	@Override
	public List<EMPiss> getPisses(String account, long from, long to) {
		List<EMPiss> ret = new LinkedList<EMPiss>();
		
		List<EMPiss> pisses = pissRep.findByAccountAndTimeBetween(
				account, from, to);
		ret.addAll(pisses);

		return ret;
	}

	@Override
	public EMPiss getPiss(String account, long time) {
		EMPiss ret = null;
		
		List<EMPiss> pisses = pissRep.findByAccountAndTime(account, time);
		if (pisses.size() > 0) {
			ret = pisses.get(0);
		}
		
		return ret;
	}

	@Override
	public boolean addPiss(EMPiss piss) {
		boolean ret = false;
		
		if (!containsExcrement(piss.getAccount(), piss.getTime())) {
			pissRep.save(piss);
			ret = true;
		}
		
		return ret;
	}

	@Override
	public boolean updatePiss(EMPiss piss) {
		boolean ret = false;
		
		if (containsPiss(piss.getAccount(), piss.getTime())) {
			EMPiss beUpdated = null;
			beUpdated = getPiss(piss.getAccount(), piss.getTime());
			if (beUpdated != null) {
				pissRep.save(piss);
				ret = true;
			}
		}
		
		return ret;
	}

	@Override
	public boolean deletePiss(String account, long time) {
		boolean ret = false;
		
		EMPiss piss = null;
		piss = getPiss(account, time);
		if (piss != null) {
			pissRep.delete(piss);
			ret = true;
		}
		
		return ret;
	}

	@Override
	public EMSleep getSleep(String account, long time) {
		EMSleep ret = null;
		
		List<EMSleep> sleeps = sleepRep.findByAccountAndTime(account, time);
		if (sleeps.size() > 0) {
			ret = sleeps.get(0);
		}
		
		return ret;
	}

	@Override
	public boolean addSleep(EMSleep sleep) {
		boolean ret = false;
		
		if (!containsSleep(sleep.getAccount(), sleep.getTime())) {
			sleepRep.save(sleep);
			ret = true;
		}
		
		return ret;
	}

	@Override
	public boolean updateSleep(EMSleep sleep) {
		boolean ret = false;
		
		if (containsSleep(sleep.getAccount(), sleep.getTime())) {
			EMSleep beUpdated = null;
			beUpdated = getSleep(sleep.getAccount(), sleep.getTime());
			if (beUpdated != null) {
				sleepRep.save(sleep);
				ret = true;
			}
		}
		
		return ret;
	}

	@Override
	public boolean deleteSleep(String account, long time) {
		boolean ret = false;
		
		EMSleep sleep = null;
		sleep = getSleep(account, time);
		if (sleep != null) {
			sleepRep.delete(sleep);
			ret = true;
		}
		
		return ret;
	}

	@Override
	public List<EMSleep> getSleeps(String account, long from, long to) {
		List<EMSleep> ret = new LinkedList<EMSleep>();
		
		List<EMSleep> sleeps = sleepRep.findByAccountAndTimeBetween(
				account, from, to);
		ret.addAll(sleeps);

		return ret;
	}
}
