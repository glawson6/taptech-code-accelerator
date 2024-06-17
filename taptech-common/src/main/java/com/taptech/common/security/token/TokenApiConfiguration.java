package com.taptech.common.security.token;

import com.taptech.common.security.keycloak.KeyCloakAuthenticationManager;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class TokenApiConfiguration {
    private static final Logger logger = LoggerFactory.getLogger(TokenApiConfiguration.class);

    @Bean
    TokenApiApiDelegate tokenApiDelegate(KeyCloakAuthenticationManager authenticationManager, ObjectMapper objectMapper){
        logger.info("Creating TokenApiDelegate");
        return KeyCloakTokenApiDelegate.builder()
                .keyCloakAuthenticationManager(authenticationManager)
                //.objectMapper(objectMapper)
                .build();
    }

    @Bean
    TokenApiController tokenApiController(KeyCloakTokenApiDelegate tokenApiDelegate){
        logger.info("Creating TokenApiController");
        return new TokenApiController(tokenApiDelegate);
    }
}
