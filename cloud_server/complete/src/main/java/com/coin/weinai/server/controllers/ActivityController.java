package com.coin.weinai.server.controllers;

import java.util.Iterator;
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

import com.coin.weinai.server.entities.EMExcrement;
import com.coin.weinai.server.managers.IAccountManager;
import com.coin.weinai.server.managers.IActivityManager;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
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
    public ObjectNode getExcrements(@PathVariable("user") String user, long fromDay, long toDay) {
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode ret = mapper.createObjectNode();
    	
    	List<EMExcrement> excrements = activityManager.getExcrements(user, fromDay, toDay);
    	ArrayNode excrementNodes = mapper.createArrayNode();
    	Iterator<EMExcrement> pos=excrements.iterator();
    	while(pos.hasNext()) {
    		EMExcrement excrement = pos.next();
    		ObjectNode excrementNode = excrement.toJsonNode();
    		excrementNodes.add(excrementNode);
    	}
    	
    	ret.put("error_code", 0);
    	ret.put("entities", excrementNodes);
    	
    	return ret;
    }
    
    @ResponseBody
    @RequestMapping(method=RequestMethod.POST, value="/excrements")
    public ObjectNode addExcrement(@RequestBody EMExcrement excrement) {
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode ret = mapper.createObjectNode();
    	
    	if (activityManager.addExcrement(excrement)) {
    		log.info("excrement added.");
    		ret.put("error_code", 0);
    		ret.set("entity", excrement.toJsonNode());
    	} else {
    		log.info("failed to add excrement.");
    		ret.put("error_code", -1);
    	}
    	
    	return ret;
    }
    
    @ResponseBody
    @RequestMapping(method=RequestMethod.PUT, value="/excrements")
    public ObjectNode updateExcrement(@RequestBody EMExcrement excrement) {
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode ret = mapper.createObjectNode();

    	if (accountManager.containsAccount(excrement.getAccount())) {
    		if (activityManager.updateExcrement(excrement)) {
    			ret.put("error_code", 0);
    			ret.set("entity", excrement.toJsonNode());
    			log.info("updated activity : " + ret);
    		} else {
    			log.info("failed to update activity : " + excrement);
    			ret.put("error_code", -1);
    		}
    	} else {
    		log.info("account not exists : " + excrement.getAccount());
    		ret.put("error_code", -1);
    	}
    	
    	return ret;
    }
    
    @ResponseBody
    @RequestMapping(method=RequestMethod.DELETE, value="/excrements/{user}")
    public ObjectNode deleteExcrement(@PathVariable("user") String username, long time) {
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode ret = mapper.createObjectNode();
    	
    	if (accountManager.containsAccount(username)) {
	    	EMExcrement deletedExcrement = activityManager.getExcrement(username, time);
	    	if (activityManager.deleteExcrement(username, time)) {
	    		ret.put("error_code", 0);
	    		ret.set("entity", deletedExcrement.toJsonNode());
	    		log.info("deleted activity : " + ret);
	    	} else {
	    		log.info("failed to delete activity : " + deletedExcrement);
	    		ret.put("error_code", -1);
	    	}
    	} else {
    		log.info("account not exists : " + username);
    		ret.put("error_code", -1);
    	}

    	return ret;
    }
}
