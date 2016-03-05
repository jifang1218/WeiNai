package com.coin.weinai.server.managers;

import com.coin.weinai.server.entities.EMAccount;

public interface IAccountManager {
	boolean containsAccount(String username);
	EMAccount getAccount(String username);
	boolean createAccount(EMAccount account);
	boolean updateAccount(EMAccount account);
	boolean deleteAccount(String username);
}
