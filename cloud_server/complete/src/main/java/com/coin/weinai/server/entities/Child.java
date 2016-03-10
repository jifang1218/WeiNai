package com.coin.weinai.server.entities;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Id;

//child一方 @JoinColumn（name="parent_id"） 是指增加外键
@Entity
@Table(name = "children")
public class Child {
	@Id
	long id;
	String name;
	
	EMAccount account;
	
	long getId() {
		return id;
	}
	void setId(long id) {
		this.id = id;
	}
	String getName() {
		return name;
	}
	void setName(String name) {
		this.name = name;
	}
	
	@ManyToOne
	@JoinColumn(name="account_id") // column name in child table. external key to account table.  
	EMAccount getAccount() {
		return account;
	}
	void setAccount(EMAccount account) {
		this.account = account;
	}

}
