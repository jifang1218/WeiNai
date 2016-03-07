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

import com.coin.weinai.server.entities.EMActivityType;
import com.coin.weinai.server.entities.EMExcrement;
import com.coin.weinai.server.entities.EMPersonMilk;
import com.coin.weinai.server.entities.EMPiss;
import com.coin.weinai.server.entities.EMPowderMilk;
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
    @RequestMapping(method=RequestMethod.GET, value="/powdermilks/{user}")
    public ObjectNode getPowderMilks(@PathVariable("user") String user, long fromDay, long toDay) {
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode ret = mapper.createObjectNode();
    	
    	List<EMPowderMilk> powderMilks = activityManager.getPowderMilks(user, fromDay, toDay);
    	ArrayNode powderMilkNodes = mapper.createArrayNode();
    	Iterator<EMPowderMilk> pos=powderMilks.iterator();
    	while(pos.hasNext()) {
    		EMPowderMilk powderMilk = pos.next();
    		ObjectNode powderMilkNode = powderMilk.toJsonNode();
    		powderMilkNodes.add(powderMilkNode);
    	}
    	
    	ret.put("error_code", 0);
    	ret.put("entities", powderMilkNodes);
    	
    	return ret;
    }
    
    @ResponseBody
    @RequestMapping(method=RequestMethod.GET, value="/personmilks/{user}")
    public ObjectNode getPersonMilks(@PathVariable("user") String user, long fromDay, long toDay) {
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode ret = mapper.createObjectNode();
    	
    	List<EMPersonMilk> personMilks = activityManager.getPersonMilks(user, fromDay, toDay);
    	ArrayNode personMilkNodes = mapper.createArrayNode();
    	Iterator<EMPersonMilk> pos=personMilks.iterator();
    	while(pos.hasNext()) {
    		EMPersonMilk personMilk = pos.next();
    		ObjectNode personMilkNode = personMilk.toJsonNode();
    		personMilkNodes.add(personMilkNode);
    	}
    	
    	ret.put("error_code", 0);
    	ret.put("entities", personMilkNodes);
    	
    	return ret;
    }
    
    @ResponseBody
    @RequestMapping(method=RequestMethod.POST, value="/excrements")
    public ObjectNode addExcrement(@RequestBody EMExcrement excrement) {
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode ret = mapper.createObjectNode();
    	
    	excrement.setType(EMActivityType.Excrement);
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
    	
    	piss.setType(EMActivityType.Piss);
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
    	
    	sleep.setActivityType(EMActivityType.Sleep);
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
    @RequestMapping(method=RequestMethod.POST, value="/powdermilks")
    public ObjectNode addPowderMilk(@RequestBody EMPowderMilk powderMilk) {
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode ret = mapper.createObjectNode();
    	
    	powderMilk.setActivityType(EMActivityType.PowderMilk);
    	if (activityManager.addPowderMilk(powderMilk)) {
    		log.info("powder milk added.");
    		ret.put("error_code", 0);
    		ret.set("entity", powderMilk.toJsonNode());
    	} else {
    		log.info("failed to add powder milk.");
    		ret.put("error_code", -1);
    	}
    	
    	return ret;
    }
    
    @ResponseBody
    @RequestMapping(method=RequestMethod.POST, value="/personmilks")
    public ObjectNode addPersonMilk(@RequestBody EMPersonMilk personMilk) {
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode ret = mapper.createObjectNode();
    	
    	personMilk.setActivityType(EMActivityType.PersonMilk);
    	if (activityManager.addPersonMilk(personMilk)) {
    		log.info("person milk added.");
    		ret.put("error_code", 0);
    		ret.set("entity", personMilk.toJsonNode());
    	} else {
    		log.info("failed to add person milk.");
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

    	piss.setType(EMActivityType.Piss);
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

    	sleep.setActivityType(EMActivityType.Sleep);
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
    @RequestMapping(method=RequestMethod.PUT, value="/powdermilks")
    public ObjectNode updatePowderMilk(@RequestBody EMPowderMilk powderMilk) {
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode ret = mapper.createObjectNode();

    	powderMilk.setActivityType(EMActivityType.PowderMilk);
    	if (accountManager.containsAccount(powderMilk.getAccount())) {
    		if (activityManager.updatePowderMilk(powderMilk)) {
    			ret.put("error_code", 0);
    			ret.set("entity", powderMilk.toJsonNode());
    			log.info("updated powder milk : " + ret);
    		} else {
    			log.info("failed to update powder milk : " + powderMilk);
    			ret.put("error_code", -1);
    		}
    	} else {
    		log.info("account not exists : " + powderMilk.getAccount());
    		ret.put("error_code", -1);
    	}
    	
    	return ret;
    }
    
    @ResponseBody
    @RequestMapping(method=RequestMethod.PUT, value="/personmilks")
    public ObjectNode updatePersonMilk(@RequestBody EMPersonMilk personMilk) {
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode ret = mapper.createObjectNode();

    	personMilk.setActivityType(EMActivityType.PersonMilk);
    	if (accountManager.containsAccount(personMilk.getAccount())) {
    		if (activityManager.updatePersonMilk(personMilk)) {
    			ret.put("error_code", 0);
    			ret.set("entity", personMilk.toJsonNode());
    			log.info("updated person milk : " + ret);
    		} else {
    			log.info("failed to update person milk : " + personMilk);
    			ret.put("error_code", -1);
    		}
    	} else {
    		log.info("account not exists : " + personMilk.getAccount());
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
    
    @ResponseBody
    @RequestMapping(method=RequestMethod.DELETE, value="/powdermilks/{user}")
    public ObjectNode deletePowderMilk(@PathVariable("user") String username, long time) {
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode ret = mapper.createObjectNode();
    	
    	if (accountManager.containsAccount(username)) {
	    	EMPowderMilk deletedPowderMilk = activityManager.getPowderMilk(username, time);
	    	if (activityManager.deletePowderMilk(username, time)) {
	    		ret.put("error_code", 0);
	    		ret.set("entity", deletedPowderMilk.toJsonNode());
	    		log.info("deleted activity : " + ret);
	    	} else {
	    		log.info("failed to delete activity : " + deletedPowderMilk);
	    		ret.put("error_code", -1);
	    	}
    	} else {
    		log.info("account not exists : " + username);
    		ret.put("error_code", -1);
    	}

    	return ret;
    }
    
    @ResponseBody
    @RequestMapping(method=RequestMethod.DELETE, value="/personmilks/{user}")
    public ObjectNode deletePersonMilk(@PathVariable("user") String username, long time) {
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode ret = mapper.createObjectNode();
    	
    	if (accountManager.containsAccount(username)) {
	    	EMPersonMilk deletedPersonMilk = activityManager.getPersonMilk(username, time);
	    	if (activityManager.deletePersonMilk(username, time)) {
	    		ret.put("error_code", 0);
	    		ret.set("entity", deletedPersonMilk.toJsonNode());
	    		log.info("deleted activity : " + ret);
	    	} else {
	    		log.info("failed to delete activity : " + deletedPersonMilk);
	    		ret.put("error_code", -1);
	    	}
    	} else {
    		log.info("account not exists : " + username);
    		ret.put("error_code", -1);
    	}

    	return ret;
    }
}
