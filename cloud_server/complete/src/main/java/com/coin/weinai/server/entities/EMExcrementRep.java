package com.coin.weinai.server.entities;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EMExcrementRep extends JpaRepository<EMExcrement, Long> { // Long是person主键(封装类型, 大写L).
}
