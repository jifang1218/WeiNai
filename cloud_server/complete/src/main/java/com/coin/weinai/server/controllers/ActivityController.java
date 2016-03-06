package com.coin.weinai.server.controllers;

import java.io.IOException;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.coin.weinai.server.entities.EMAccount;
import com.coin.weinai.server.entities.EMActivityBase;
import com.coin.weinai.server.entities.EMActivityType;
import com.coin.weinai.server.entities.EMExcrement;
import com.coin.weinai.server.managers.IAccountManager;
import com.coin.weinai.server.managers.IActivityManager;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

@RestController
@RequestMapping("/weinai/activities")
public class ActivityController {
	
	@Autowired
	private IActivityManager activityManager;
	
	@Autowired
	private IAccountManager accountManager;
	
	private static Logger log = LoggerFactory.getLogger(ActivityController.class);
	
    @ResponseBody
    @RequestMapping(method=RequestMethod.GET, value="/excrements/{user}")
    public List<EMActivityBase> getActivities(@PathVariable("user") String user, int itype, long fromDay, long toDay) {
    	List<EMActivityBase> ret = null;
    	/*
    	if (accountManager.containsAccount(user)) {
    		EMActivityType type = EMActivityType.Excrement;
    		ret = activityManager.getActivities(user, type, fromDay, toDay);
    		log.info("get activities : " + ret);
    	} else {
    		log.info("account not exists : " + user);
    	}
    	*/
    	return ret;
    }
    
    @ResponseBody
    @RequestMapping(method=RequestMethod.POST)
    public ObjectNode addActivity(@RequestBody ObjectNode activityNode) {
    	ObjectNode ret = null;

    	int inttype = activityNode.get("type").asInt(0);
    	EMActivityType type;
    	switch (inttype) {
	    	case 0: {
	    		type = EMActivityType.Excrement;
	    	} break;
	    	case 1: {
	    		type = EMActivityType.Excrement;
	    	} break;
	    	case 2: {
	    		type = EMActivityType.Excrement;
	    	} break;
	    	case 3: {
	    		type = EMActivityType.Excrement;
	    	} break;
	    	default: {
	    		type = EMActivityType.Excrement;
	    	}
    	}
    	
    	if (activityManager.addActivity(type, activityNode)) {
    		log.info("activity added.");
    	} else {
    		log.info("failed to add activity : " + activityNode.asText());
    	}
    	
    	return ret;
    }
    
    @ResponseBody
    @RequestMapping(method=RequestMethod.PUT, value="/excrements")
    public EMExcrement updateExcrement(@RequestBody EMExcrement excrement) {
    	EMExcrement ret = null;
    	
    	if (accountManager.containsAccount(excrement.getAccount())) {
    		if (activityManager.updateExcrement(excrement)) {
    			ret = excrement;
    			log.info("updated activity : " + ret);
    		} else {
    			log.info("failed to update activity : " + excrement);
    		}
    	} else {
    		log.info("account not exists : " + excrement.getAccount());
    	}
    	
    	return ret;
    }
    
    @ResponseBody
    @RequestMapping(method=RequestMethod.DELETE, value="/excrements/{user}")
    public EMExcrement deleteExcrement(@PathVariable("user") String username, EMActivityType type, long time) {
    	EMExcrement ret = null;
    	
    	if (accountManager.containsAccount(username)) {
	    	EMExcrement deletedExcrement = activityManager.getActivity(username, type, time);
	    	if (activityManager.deleteExcrement(username, type, time)) {
	    		ret = deletedExcrement;
	    		log.info("deleted activity : " + ret);
	    	} else {
	    		log.info("failed to delete activity : " + deletedExcrement);
	    	}
    	} else {
    		log.info("account not exists : " + username);
    	}

    	return ret;
    }
}
