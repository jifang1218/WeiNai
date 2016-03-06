package com.coin.weinai.server.entities;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EMExcrementRep extends JpaRepository<EMExcrement, Long> { // Long是person主键(封装类型, 大写L).
	List<EMExcrement> findByAccountAndTypeAndTimeBetween(String account, EMActivityType type, long from, long to);
	List<EMExcrement> findByAccountAndTypeAndTime(String account, EMActivityType type, long time);
}
