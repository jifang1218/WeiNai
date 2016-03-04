package com.coin.weinai.server.managers;

import com.coin.weinai.server.entities.EMAccount;

public interface IAccountManager {
	boolean containsUser(String username);
	EMAccount getAccount(String username);
	boolean createAccount(String username, String password, String child);
	EMAccount getCurrentAccount();
	void setCurrentAccount(EMAccount account);
}
