package com.coin.weinai.server.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.coin.weinai.server.entities.EMActivityBase;
import com.coin.weinai.server.entities.EMExcrement;
import com.coin.weinai.server.managers.IAccountManager;
import com.coin.weinai.server.managers.IActivityManager;

@RestController
@RequestMapping("/weinai/activities")
public class ActivityController {
	
	@Autowired
	private IActivityManager activityManager;
	
	@Autowired
	private IAccountManager accountManager;
	
    @ResponseBody
    @RequestMapping(method=RequestMethod.GET, value="/{user}")
    public List<EMActivityBase> getActivities(@PathVariable("user") String user, long fromDay, long toDay) {
    	List<EMActivityBase> ret = null;
    	
    	if (accountManager.containsAccount(user)) {
    		ret = activityManager.getActivities(user, fromDay, toDay);
    	}
    	
    	return ret;
    }
    
    @ResponseBody
    @RequestMapping(method=RequestMethod.POST, value="/excrements")
    public EMExcrement addExcrement(@RequestBody EMExcrement excrement) {
    	EMExcrement ret = null;
    	
    	if (accountManager.containsAccount(excrement.getAccount())) {
	    	if (activityManager.addExcrement(excrement)) {
	    		ret = excrement;
	    	}
    	}
    	
    	return ret;
    }
}
