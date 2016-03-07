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
import com.coin.weinai.server.entities.EMPiss;
import com.coin.weinai.server.entities.EMSleep;
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
    @RequestMapping(method=RequestMethod.GET, value="/pisses/{user}")
    public ObjectNode getPisses(@PathVariable("user") String user, long fromDay, long toDay) {
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode ret = mapper.createObjectNode();
    	
    	List<EMPiss> pisses = activityManager.getPisses(user, fromDay, toDay);
    	ArrayNode pissNodes = mapper.createArrayNode();
    	Iterator<EMPiss> pos=pisses.iterator();
    	while(pos.hasNext()) {
    		EMPiss piss = pos.next();
    		ObjectNode pissNode = piss.toJsonNode();
    		pissNodes.add(pissNode);
    	}
    	
    	ret.put("error_code", 0);
    	ret.put("entities", pissNodes);
    	
    	return ret;
    }
    
    @ResponseBody
    @RequestMapping(method=RequestMethod.GET, value="/sleeps/{user}")
    public ObjectNode getSleeps(@PathVariable("user") String user, long fromDay, long toDay) {
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode ret = mapper.createObjectNode();
    	
    	List<EMSleep> sleeps = activityManager.getSleeps(user, fromDay, toDay);
    	ArrayNode sleepNodes = mapper.createArrayNode();
    	Iterator<EMSleep> pos=sleeps.iterator();
    	while(pos.hasNext()) {
    		EMSleep sleep = pos.next();
    		ObjectNode sleepNode = sleep.toJsonNode();
    		sleepNodes.add(sleepNode);
    	}
    	
    	ret.put("error_code", 0);
    	ret.put("entities", sleepNodes);
    	
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
    @RequestMapping(method=RequestMethod.POST, value="/pisses")
    public ObjectNode addPiss(@RequestBody EMPiss piss) {
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode ret = mapper.createObjectNode();
    	
    	if (activityManager.addPiss(piss)) {
    		log.info("piss added.");
    		ret.put("error_code", 0);
    		ret.set("entity", piss.toJsonNode());
    	} else {
    		log.info("failed to add excrement.");
    		ret.put("error_code", -1);
    	}
    	
    	return ret;
    }
    
    @ResponseBody
    @RequestMapping(method=RequestMethod.POST, value="/sleeps")
    public ObjectNode addSleep(@RequestBody EMSleep sleep) {
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode ret = mapper.createObjectNode();
    	
    	if (activityManager.addSleep(sleep)) {
    		log.info("sleep added.");
    		ret.put("error_code", 0);
    		ret.set("entity", sleep.toJsonNode());
    	} else {
    		log.info("failed to add sleep.");
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
    @RequestMapping(method=RequestMethod.PUT, value="/pisses")
    public ObjectNode updatePiss(@RequestBody EMPiss piss) {
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode ret = mapper.createObjectNode();

    	if (accountManager.containsAccount(piss.getAccount())) {
    		if (activityManager.updatePiss(piss)) {
    			ret.put("error_code", 0);
    			ret.set("entity", piss.toJsonNode());
    			log.info("updated activity : " + ret);
    		} else {
    			log.info("failed to update activity : " + piss);
    			ret.put("error_code", -1);
    		}
    	} else {
    		log.info("account not exists : " + piss.getAccount());
    		ret.put("error_code", -1);
    	}
    	
    	return ret;
    }
    
    @ResponseBody
    @RequestMapping(method=RequestMethod.PUT, value="/sleeps")
    public ObjectNode updateSleep(@RequestBody EMSleep sleep) {
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode ret = mapper.createObjectNode();

    	if (accountManager.containsAccount(sleep.getAccount())) {
    		if (activityManager.updateSleep(sleep)) {
    			ret.put("error_code", 0);
    			ret.set("entity", sleep.toJsonNode());
    			log.info("updated sleep : " + ret);
    		} else {
    			log.info("failed to update sleep : " + sleep);
    			ret.put("error_code", -1);
    		}
    	} else {
    		log.info("account not exists : " + sleep.getAccount());
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
    
    @ResponseBody
    @RequestMapping(method=RequestMethod.DELETE, value="/pisses/{user}")
    public ObjectNode deletePiss(@PathVariable("user") String username, long time) {
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode ret = mapper.createObjectNode();
    	
    	if (accountManager.containsAccount(username)) {
	    	EMPiss deletedPiss = activityManager.getPiss(username, time);
	    	if (activityManager.deleteExcrement(username, time)) {
	    		ret.put("error_code", 0);
	    		ret.set("entity", deletedPiss.toJsonNode());
	    		log.info("deleted activity : " + ret);
	    	} else {
	    		log.info("failed to delete activity : " + deletedPiss);
	    		ret.put("error_code", -1);
	    	}
    	} else {
    		log.info("account not exists : " + username);
    		ret.put("error_code", -1);
    	}

    	return ret;
    }
    
    @ResponseBody
    @RequestMapping(method=RequestMethod.DELETE, value="/sleeps/{user}")
    public ObjectNode deleteSleep(@PathVariable("user") String username, long time) {
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode ret = mapper.createObjectNode();
    	
    	if (accountManager.containsAccount(username)) {
	    	EMSleep deletedSleep = activityManager.getSleep(username, time);
	    	if (activityManager.deleteSleep(username, time)) {
	    		ret.put("error_code", 0);
	    		ret.set("entity", deletedSleep.toJsonNode());
	    		log.info("deleted activity : " + ret);
	    	} else {
	    		log.info("failed to delete activity : " + deletedSleep);
	    		ret.put("error_code", -1);
	    	}
    	} else {
    		log.info("account not exists : " + username);
    		ret.put("error_code", -1);
    	}

    	return ret;
    }
}
