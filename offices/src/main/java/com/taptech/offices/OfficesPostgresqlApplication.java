package com.taptech.offices;

import com.taptech.common.EnableCommonConfig;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.data.redis.RedisAutoConfiguration;
import org.springframework.boot.autoconfigure.data.redis.RedisReactiveAutoConfiguration;

// Exclude Redis  auto configure classes
@SpringBootApplication(exclude = {RedisAutoConfiguration.class, RedisReactiveAutoConfiguration.class})
@EnableCommonConfig
public class OfficesPostgresqlApplication {

    public static void main(String[] args) {
        SpringApplication.run(OfficesPostgresqlApplication.class, args);
    }

}
