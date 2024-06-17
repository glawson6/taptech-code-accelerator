package com.taptech.offices.service;

import com.taptech.offices.server.OfficesApiController;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@Configuration
@EnableAutoConfiguration
@EntityScan(basePackages = {"com.taptech.offices.service"})
@EnableJpaRepositories("com.taptech.offices.service")
@ComponentScan(basePackages = {"com.taptech.offices.service"})
public class OfficesConfiguration {

    @Bean
    OfficesServiceDelegate officesServiceDelegate(OfficeRepository officeRepository){
        return new OfficesServiceDelegate(officeRepository);
    }

    @Bean
    OfficesApiController officesApiController(OfficesServiceDelegate officesServiceDelegate){
        return new OfficesApiController(officesServiceDelegate);
    }
}
