package com.coin.weinai.server.entities;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

//account一方 mappedBy = "child一方的parent"关系有对方维护
@Entity
@Table(name = "account")
public class EMAccount {
	String username;
	String password;
	String child;
	
	List<Child> children;
	
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

	// account is table name. 
	@OneToMany(mappedBy = "account",cascade = {CascadeType.ALL},fetch = FetchType.EAGER)
	List<Child> getChildren() {
		return children;
	}

	void setChildren(List<Child> children) {
		this.children = children;
	}
	
	
}
