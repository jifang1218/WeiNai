package com.coin.weinai.server.managers;

import java.util.List;

import com.coin.weinai.server.entities.*;

public interface IActivityManager {
	List<EMActivityBase> getActivities(String account, EMActivityType type, long from, long to);
	EMExcrement getActivity(String account, EMActivityType type, long time);
	boolean addExcrement(EMExcrement excrement);
	boolean updateExcrement(EMExcrement excrement);
	boolean deleteExcrement(String account, EMActivityType type, long time);
}
