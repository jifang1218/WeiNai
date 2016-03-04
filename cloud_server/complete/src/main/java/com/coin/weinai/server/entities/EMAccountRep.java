package com.coin.weinai.server.entities;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EMAccountRep extends JpaRepository<EMAccount, Long> { // Long是person主键(封装类型, 大写L).
	//List<EMAccount> findByUsernameLikeAndAgeAndXXX(String username, int age, T XXX);
	List<EMAccount> findByUsername(String username);
}