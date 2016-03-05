package com.coin.weinai.server.entities;

import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EMPersonMilkRep extends JpaRepository<EMPersonMilk, Long> { // Long是person主键(封装类型, 大写L).
	List<EMPersonMilk> findByAccountAndFromGreaterThanAndToLessThan(String account, Date from, Date to);
}
