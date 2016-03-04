package com.coin.weinai.server.entities;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "account")
public class EMAccount {
	String username;
	String password;
	String child;
	@Id
	long id;
	
	boolean equals(EMAccount account) {
		boolean ret = false;
		
		if ((username != null && username.equals(account.username)) &&
			(password != null && password.equals(account.password)) &&
			(child != null && child.equals(account.child))) {
			ret = true;
		}
		
		return ret;
	}
	
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getChild() {
		return child;
	}
	public void setChild(String child) {
		this.child = child;
	}
}
