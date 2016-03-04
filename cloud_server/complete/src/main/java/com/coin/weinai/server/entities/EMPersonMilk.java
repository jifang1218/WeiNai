package com.coin.weinai.server.entities;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "PERSONMILK")
class EMPersonMilk extends EMMilk {
	String person;

	boolean equals(EMPersonMilk personMilk) {
		boolean ret = false;
		
		if (super.equals(personMilk)) {
			if (person.equals(personMilk.person)) {
				ret = true;
			}
		}
		
		return ret;
	}
	
	@Id
	long id;
	long getId() {
		return id;
	}
	void setId(long id) {
		this.id = id;
	}
	String getPerson() {
		return person;
	}

	void setPerson(String person) {
		this.person = person;
	}
}
