package com.coin.weinai.server.entities;

import javax.persistence.Entity;
import javax.persistence.Id;

enum EMActivityType {
	Milk, 
	Piss, 
	Excrement, 
	Sleep
}

public class EMActivityBase {
	boolean equals(EMActivityBase activity) {
		return true;
	}
}
