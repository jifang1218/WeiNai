package com.coin.weinai.server.managers;

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
		
		List<EMAccount> accounts = accountRep.findByUsername(username);
		if (accounts.size() > 0) {
			ret = true;
		}
			
		return ret;
	}

	@Override
	public EMAccount getAccount(String username) {
		EMAccount ret = null;

		List<EMAccount> accounts = accountRep.findByUsername(username);
		if (accounts.size() > 0) {
			ret = accounts.get(0);
		}
		
		return ret;
	}
	
	@Override
	public
	boolean createAccount(EMAccount account) {
		boolean ret = false;
		
		if (!containsUser(account.getUsername())) {
			accountRep.save(account);
			ret = true;
		}
		
		return ret;
	}
}
