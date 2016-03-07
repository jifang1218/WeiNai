package com.coin.weinai.server.managers;

import java.util.List;

import com.coin.weinai.server.entities.EMExcrement;
import com.coin.weinai.server.entities.EMPersonMilk;
import com.coin.weinai.server.entities.EMPiss;
import com.coin.weinai.server.entities.EMPowderMilk;
import com.coin.weinai.server.entities.EMSleep;

public interface IActivityManager {
	List<EMExcrement> getExcrements(String account, long from, long to);
	List<EMPiss> getPisses(String account, long from, long to);
	List<EMSleep> getSleeps(String account, long from, long to);
	List<EMPowderMilk> getPowderMilks(String account, long from, long to);
	List<EMPersonMilk> getPersonMilks(String account, long from, long to);
	
	EMExcrement getExcrement(String account, long time);
	EMPiss getPiss(String account, long time);
	EMSleep getSleep(String account, long time);
	EMPowderMilk getPowderMilk(String account, long time);
	EMPersonMilk getPersonMilk(String account, long time);
	
	boolean addExcrement(EMExcrement excrement);
	boolean addPiss(EMPiss piss);
	boolean addSleep(EMSleep sleep);
	boolean addPowderMilk(EMPowderMilk powderMilk);
	boolean addPersonMilk(EMPersonMilk personMilk);
	
	boolean updateExcrement(EMExcrement excrement);
	boolean updatePiss(EMPiss piss);
	boolean updateSleep(EMSleep sleep);
	boolean updatePowderMilk(EMPowderMilk powderMilk);
	boolean updatePersonMilk(EMPersonMilk personMilk);
	
	boolean deleteExcrement(String account, long time);
	boolean deletePiss(String account, long time);
	boolean deleteSleep(String account, long time);
	boolean deletePowderMilk(String account, long time);
	boolean deletePersonMilk(String account, long time);
}
