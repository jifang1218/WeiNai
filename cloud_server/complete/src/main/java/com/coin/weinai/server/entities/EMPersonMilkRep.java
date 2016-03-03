package com.coin.weinai.server.entities;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EMPersonMilkRep extends JpaRepository<EMPersonMilk, Long> { // Long是person主键(封装类型, 大写L).
}
