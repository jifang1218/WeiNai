package com.coin.weinai.server.entities;

import java.util.List;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "ACCOUNT")
public
class EMAccount {
	String mother;
	String father;
	String password;
	List<String> children;
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
	
	long getId() {
		return id;
	}
	void setId(long id) {
		this.id = id;
	}
	String getMother() {
		return mother;
	}
	void setMother(String mother) {
		this.mother = mother;
	}
	String getFather() {
		return father;
	}
	void setFather(String father) {
		this.father = father;
	}
	String getPassword() {
		return password;
	}
	void setPassword(String password) {
		this.password = password;
	}
	List<String> getChildren() {
		return children;
	}
	void setChildren(List<String> children) {
		this.children = children;
	}
}
