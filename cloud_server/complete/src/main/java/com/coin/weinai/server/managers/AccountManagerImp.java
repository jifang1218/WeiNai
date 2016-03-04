package com.coin.weinai.server.managers;

import java.util.Iterator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.coin.weinai.server.entities.EMAccount;
import com.coin.weinai.server.entities.EMAccountRep;

@Component
public class AccountManagerImp implements IAccountManager {
	
	@Autowired
	private EMAccountRep accountRep;
	
	private EMAccount currentAccount;

	@Override
	public EMAccount getCurrentAccount() {
		return currentAccount;
	}
	
	@Override
	public void setCurrentAccount(EMAccount account) {
		currentAccount = account;
	}
	
	@Override
	public boolean containsUser(String username) {
		boolean ret = false;
		
		if (accountRep != null) {
			List<EMAccount> accounts = accountRep.findAll();
			Iterator<EMAccount> pos = accounts.iterator();
			while (pos.hasNext()) {
				EMAccount account = pos.next();
				if (account.getFather().equals(username) ||
					account.getMother().equals(username)) {
					ret = true;
					break;
				}
			}
		}
			
		return ret;
	}

	@Override
	public EMAccount getAccount(String username) {
		EMAccount ret = null;

//		String hql="from Health as g where g.id=:id";
//		Query query=session.createQuery(hql);
//		query.setString("id", id);s
//		queryString.append("from Health as h where h.userid=:userid and h.date = :date");
//		Query query = session.createQuery(queryString.toString());	
//		query.setString("userid", userid);
//		query.setString("date", date);
		
	
		List<EMAccount> accounts = accountRep.findAll();
		Iterator<EMAccount> pos = accounts.iterator();
		while (pos.hasNext()) {
			EMAccount account = pos.next();
			if (account.getFather().equals(username) ||
				account.getMother().equals(username)) {
				ret = account;
				break;
			}
		}
		
		return ret;
	}
	
	@Override
	public
	boolean createAccount(String username, String spouseName, String password, String children) {
		boolean ret = false;
		
		if (!containsUser(username) && 
			!containsUser(spouseName)) {
			EMAccount account = new EMAccount();
			account.setChildren(children);
			account.setFather(spouseName);
			account.setMother(username);
			account.setPassword(password);
			accountRep.save(account);
			ret = true;
		}
		
		return ret;
	}
	

}
