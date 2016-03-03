package com.coin.weinai.server.entities;

import org.hibernate.SessionFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnBean;
import org.springframework.boot.orm.jpa.EntityScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.persistence.EntityManagerFactory;

/**
 * @author jifang @ milan.it
 */
@Configuration
@EntityScan("com.coin.weinai.server.entities") // entity path
@EnableJpaRepositories("com.coin.weinai.server.entities") // jpa path. 
@EnableTransactionManagement
public class PersistenceConfiguration {
    @Bean
    @ConditionalOnBean(EntityManagerFactory.class)
    public SessionFactory getSessionFactory(EntityManagerFactory entityManagerFactory) {
        if (entityManagerFactory.unwrap(SessionFactory.class) == null) {
            throw new NullPointerException("factory is not a hibernate factory");
        }
        return entityManagerFactory.unwrap(SessionFactory.class);
    }

}
