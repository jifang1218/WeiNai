package com.coin.weinai.server.managers;

import java.util.List;
import com.coin.weinai.server.entities.EMExcrement;

public interface IActivityManager {
	List<EMExcrement> getExcrements(String account, long from, long to);
	EMExcrement getExcrement(String account, long time);
	boolean addExcrement(EMExcrement excrement);
	boolean updateExcrement(EMExcrement excrement);
	boolean deleteExcrement(String account, long time);
}
