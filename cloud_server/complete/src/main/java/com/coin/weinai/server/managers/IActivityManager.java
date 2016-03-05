package com.coin.weinai.server.managers;

import java.util.List;
import com.coin.weinai.server.entities.*;

public interface IActivityManager {
	List<EMActivityBase> getActivities(String account, long from, long to);
	boolean addExcrement(EMExcrement excrement);
}
