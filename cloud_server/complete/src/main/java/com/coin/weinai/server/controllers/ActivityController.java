package com.coin.weinai.server.controllers;

import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.coin.weinai.server.controllers.exceptions.OptionConflictException;
import com.coin.weinai.server.entities.EMAccount;
import com.coin.weinai.server.entities.EMActivityBase;
import com.coin.weinai.server.entities.EMExcrementRep;
import com.coin.weinai.server.entities.EMPersonMilkRep;
import com.coin.weinai.server.entities.EMPissRep;
import com.coin.weinai.server.entities.EMPowderMilkRep;
import com.coin.weinai.server.entities.EMSleepRep;
import com.coin.weinai.server.entities.Person;
import com.coin.weinai.server.entities.PersonRep;
import com.coin.weinai.server.managers.AccountManagerImp;
import com.coin.weinai.server.managers.ActivityManagerImp;
import com.coin.weinai.server.managers.IAccountManager;
import com.coin.weinai.server.managers.IActivityManager;

@RestController
@RequestMapping("/weinai/activities")
public class ActivityController {
	
	@Autowired
	private IActivityManager activityManager;
	
	@Autowired
	private IAccountManager accountManager;

//    private static final String template = "Hello, %s!";
//    private final AtomicLong counter = new AtomicLong();
    
//    @Autowired
//    private PersonRep personRep;
    
    @Autowired
    EMPissRep pissRep;
    
    @Autowired 
    EMExcrementRep excrementRep;
    
    @Autowired
    EMPersonMilkRep personMilkRep;
    
    @Autowired
    EMPowderMilkRep powderMilkRep;
    
    @Autowired
    EMSleepRep sleepRep;

    @ResponseBody
    @RequestMapping(method=RequestMethod.GET, value="/{user}")
    public List<EMActivityBase> getActivities(@PathVariable("user") String user, 
    		@DateTimeFormat(iso=ISO.DATE) Date fromDay, 
    		@DateTimeFormat(iso=ISO.DATE) Date toDay) {
    	List<EMActivityBase> ret = null;
    	
    	//ret = activityManager.getActivities(user, fromDay, toDay);
    	IAccountManager mgr = accountManager;
    	EMAccount account = mgr.getCurrentAccount();
    	String name = account.getUsername();
    	
    	return ret;
    }
    
//    @RequestMapping("/")
//    public Greeting greeting1(@RequestParam(value="name", defaultValue="World") String name) {
//        return new Greeting(counter.incrementAndGet(),
//                            String.format(template, name));
//    }
//    
//    @RequestMapping("")
//    public Greeting greeting11(@RequestParam(value="name", defaultValue="World") String name) {
//        return new Greeting(counter.incrementAndGet(),
//                            String.format(template, name));
//    }
//    
//    @RequestMapping("/hello2/{nb1}/{nb2}")
//    public Greeting greeting2(@PathVariable("nb1") String nb1, @PathVariable("nb2") String nb2) {
//        return new Greeting(counter.incrementAndGet(),
//                            nb1 + "-kkk-" + nb2);
//    }
//    
//    @RequestMapping("/header1")
//    public Greeting header(@RequestHeader (value="host", defaultValue="hostDefault") String hostName,
//				           @RequestHeader (value="Accept", defaultValue="AcceptDefault") String acceptType,
//				    	   @RequestHeader (value="Accept-Language", defaultValue="Accept-Language-Default") String acceptLang,
//				    	   @RequestHeader (value="Accept-Encoding", defaultValue="Accept-Encoding-Default") String acceptEnc,
//				    	   @RequestHeader (value="Cache-Control", defaultValue="Cache-Control-Default") String cacheCon,
//				    	   @RequestHeader (value="Cookie", defaultValue="CookieDefault") String cookie,
//				    	   @RequestHeader (value="User-Agent", defaultValue="User-Agent-Default") String userAgent)
//    {
//    	System.out.println("Host : " + hostName);
//    	System.out.println("Accept : " + acceptType);
//    	System.out.println("Accept Language : " + acceptLang);
//    	System.out.println("Accept Encoding : " + acceptEnc);
//    	System.out.println("Cache-Control : " + cacheCon);
//    	System.out.println("Cookie : " + cookie);
//    	System.out.println("User-Agent : " + userAgent);
//    	return new Greeting(counter.incrementAndGet(), "jifang_header");
//    }
//
//    @RequestMapping("/header2")
//    public Greeting header2(HttpServletRequest request)
//    {
//    	Person p = new Person();
//    	p.setAge(18);
//    	p.setName("shab");
//    	
//    	personRep.save(p);
//    	return new Greeting(counter.incrementAndGet(), "jifang_header");
//    }
//    
//    @RequestMapping("/header3")
//    @ResponseStatus(HttpStatus.OK) // return 200 OK by default. 
//    public Greeting header3(HttpServletRequest request)
//    {
//    	boolean b = false;
//    	if (b) {
//    		// change return value to HttpStatus.CONFLICT (409)
//    		throw new OptionConflictException();
//    	}
//    	return new Greeting(counter.incrementAndGet(), "jifang_header");
//    }
//    
//    // /header4?a=1&b=334&c=1.11
//    @RequestMapping("/header4")
//    @ResponseStatus(HttpStatus.OK) // return 200 OK by default. 
//    public Greeting header4(int a, String b, double c)
//    {
//    	return new Greeting(counter.incrementAndGet(), "jifang_header");
//    }
}
