package com.coin.weinai.server.managers;

import java.util.List;

import com.coin.weinai.server.entities.EMActivityBase;
import com.coin.weinai.server.entities.EMActivityType;
import com.coin.weinai.server.entities.EMExcrement;
import com.fasterxml.jackson.databind.node.ObjectNode;

public interface IActivityManager {
	List<EMActivityBase> getActivities(String account, EMActivityType type, long from, long to);
	EMExcrement getActivity(String account, EMActivityType type, long time);
	boolean addActivity(EMActivityType type, ObjectNode activityNode);
	boolean addExcrement(EMExcrement excrement);
	boolean updateExcrement(EMExcrement excrement);
	boolean deleteExcrement(String account, EMActivityType type, long time);
}
