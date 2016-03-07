package com.coin.weinai.server.entities;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EMPowderMilkRep extends JpaRepository<EMPowderMilk, Long> { // Long是person主键(封装类型, 大写L).
	List<EMPowderMilk> findByAccountAndTimeBetween(String account, long from, long to);
	List<EMPowderMilk> findByAccountAndTime(String account, long time);
}
