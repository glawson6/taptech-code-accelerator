package com.taptech.common.security.user;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.util.Assert;

@Configuration
public class UserContextPermissionsConfig {
    private static final Logger logger = LoggerFactory.getLogger(UserContextPermissionsConfig.class);

    @Bean
    @ConditionalOnProperty(prefix="user.context.permissions", name = "service", havingValue = "in-memory", matchIfMissing = true)
    UserContextPermissionsService inMemoryUserContextPermissionsService() {
        InMemoryUserContextPermissionsService inMemoryUserContextPermissionsService = new InMemoryUserContextPermissionsService();
        return inMemoryUserContextPermissionsService;

    }

    @Bean
    @ConditionalOnProperty(prefix="user.context.permissions", name = "service", havingValue = "http-read", matchIfMissing = false)
    UserContextPermissionsService httpReadingUserContextPermissionsService(Environment env) {
        String baseUrl = env.getProperty("user.context.permissions.base-url");
        HttpReadingUserContextPermissionsService httpUserContextPermissionsService = HttpReadingUserContextPermissionsService.builder()
                .baseUrl(baseUrl)
                .build();
        return httpUserContextPermissionsService;

    }
}
