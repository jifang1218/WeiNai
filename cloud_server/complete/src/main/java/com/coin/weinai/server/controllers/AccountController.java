package com.coin.weinai.server.controllers;

import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.coin.weinai.server.controllers.exceptions.AccountNotFoundException;
import com.coin.weinai.server.entities.EMAccount;
import com.coin.weinai.server.entities.EMActivityBase;
import com.coin.weinai.server.managers.IAccountManager;

@RestController
@RequestMapping("/weinai/users")
public class AccountController {
	@Autowired
	private IAccountManager accountManager;
	
	private static Logger log = LoggerFactory.getLogger(AccountController.class);
	
	@ResponseBody
    @RequestMapping(value="/{user}", method=RequestMethod.GET)
    public EMAccount getAccountInfo(@PathVariable("user") String account) {
    	EMAccount ret = null;
    	
    	if (accountManager.containsAccount(account)) {
    		ret = accountManager.getAccount(account);
    	} else {
    		throw new AccountNotFoundException();
    	}
    	
    	return ret;
    }
    
    @ResponseBody
    @RequestMapping(method=RequestMethod.POST)
    public EMAccount createAccount(@RequestBody EMAccount account) {
    	if (accountManager.containsAccount(account.getUsername())) {
    		log.info("already exists.");
    	} else {
    		log.info("create new user: " + account.getUsername() + 
    				" password: " + account.getPassword() + 
    				" child: " + account.getChild());
    		if (accountManager.createAccount(account)) {
    		} else {
    			log.info("failed to create user.");
    		}
    	}
    	
    	return account;
    }
    
    @ResponseBody
    @RequestMapping(method=RequestMethod.PUT)
    public EMAccount updateAccount(@RequestBody EMAccount account) {
    	EMAccount ret = null;
    	
    	if (accountManager.containsAccount(account.getUsername())) {
    		if (accountManager.updateAccount(account)) {
    			ret = account;
    		}
    	}
    	
    	return ret;
    }
    
    @ResponseBody
    @RequestMapping(value="{user}", method=RequestMethod.DELETE) 
    public EMAccount deleteAccount(@PathVariable("user") String username) {
    	EMAccount ret = null;
    	
    	if (accountManager.containsAccount(username)) {
    		EMAccount account = accountManager.getAccount(username);
    		if (accountManager.deleteAccount(username)) {
    			ret = account;
    		}
    	}
    	
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
