package com.coin.weinai.server.managers;

import java.util.List;

import com.coin.weinai.server.entities.EMExcrement;
import com.coin.weinai.server.entities.EMPiss;
import com.coin.weinai.server.entities.EMSleep;

public interface IActivityManager {
	List<EMExcrement> getExcrements(String account, long from, long to);
	List<EMPiss> getPisses(String account, long from, long to);
	List<EMSleep> getSleeps(String account, long from, long to);
	EMExcrement getExcrement(String account, long time);
	EMPiss getPiss(String account, long time);
	EMSleep getSleep(String account, long time);
	boolean addExcrement(EMExcrement excrement);
	boolean addPiss(EMPiss piss);
	boolean addSleep(EMSleep sleep);
	boolean updateExcrement(EMExcrement excrement);
	boolean updatePiss(EMPiss piss);
	boolean updateSleep(EMSleep sleep);
	boolean deleteExcrement(String account, long time);
	boolean deletePiss(String account, long time);
	boolean deleteSleep(String account, long time);
}
