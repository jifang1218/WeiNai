package com.coin.weinai.server.entities;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "account")
public class EMAccount {
	String mother;
	String father;
	String password;
	String children;
	@Id
	long id;
	
	boolean equals(EMAccount account) {
		boolean ret = false;
		
		if ((mother != null && mother.equals(account.mother)) ||
			(father != null && father.equals(account.father))) {
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
	public String getMother() {
		return mother;
	}
	public void setMother(String mother) {
		this.mother = mother;
	}
	public String getFather() {
		return father;
	}
	public void setFather(String father) {
		this.father = father;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getChildren() {
		return children;
	}
	public void setChildren(String children) {
		this.children = children;
	}
}
