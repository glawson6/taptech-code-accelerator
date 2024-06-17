package com.taptech.common;

import com.taptech.common.exception.CannotValidateTokenException;
import com.taptech.common.exception.ReactiveExceptionHandler;
import com.taptech.common.exception.UserNotFoundException;
import com.fasterxml.jackson.annotation.JsonInclude;
import org.springframework.boot.autoconfigure.condition.ConditionalOnBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnWebApplication;
import org.springframework.boot.autoconfigure.web.WebProperties;
import org.springframework.boot.web.reactive.error.DefaultErrorAttributes;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpStatus;
import org.springframework.http.codec.ServerCodecConfigurer;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.security.authentication.AuthenticationCredentialsNotFoundException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.oauth2.jwt.BadJwtException;
import org.springframework.security.oauth2.jwt.JwtException;
import org.springframework.security.oauth2.jwt.JwtValidationException;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import java.util.HashMap;
import java.util.Map;

import static com.taptech.common.security.utils.SecurityUtils.LOCAL_DATETIME_SERIALIZER;

@Configuration
public class CommonConfig {

    @Bean
    public MappingJackson2HttpMessageConverter mappingJackson2HttpMessageConverter() {
        Jackson2ObjectMapperBuilder builder = new Jackson2ObjectMapperBuilder().serializers(LOCAL_DATETIME_SERIALIZER)
                .serializationInclusion(JsonInclude.Include.NON_NULL);
        return new MappingJackson2HttpMessageConverter(builder.build());
    }
    @Bean
    @Order(-2)
    @ConditionalOnWebApplication(type = ConditionalOnWebApplication.Type.REACTIVE)
    public ReactiveExceptionHandler reactiveExceptionHandler(WebProperties webProperties, ApplicationContext applicationContext, ServerCodecConfigurer configurer) {
        ReactiveExceptionHandler exceptionHandler = new ReactiveExceptionHandler(
                new DefaultErrorAttributes(), webProperties.getResources(), applicationContext, exceptionToStatusCode(), HttpStatus.INTERNAL_SERVER_ERROR
        );
        exceptionHandler.setMessageWriters(configurer.getWriters());
        exceptionHandler.setMessageReaders(configurer.getReaders());
        return exceptionHandler;
    }

    @Bean("exceptionToStatusCode")
    public Map<Class<? extends Exception>, HttpStatus> exceptionToStatusCode() {

        Map<Class<? extends Exception>, HttpStatus> exceptionToStatusCode = new HashMap<>();
        exceptionToStatusCode.put(UserNotFoundException.class, HttpStatus.NOT_FOUND);
        exceptionToStatusCode.put(IllegalArgumentException.class, HttpStatus.BAD_REQUEST);
        exceptionToStatusCode.put(BadJwtException.class, HttpStatus.BAD_REQUEST);
        exceptionToStatusCode.put(AuthenticationCredentialsNotFoundException.class, HttpStatus.UNAUTHORIZED);
        exceptionToStatusCode.put(WebClientResponseException.Unauthorized.class, HttpStatus.UNAUTHORIZED);
        exceptionToStatusCode.put(WebClientResponseException.Forbidden.class, HttpStatus.FORBIDDEN);
        exceptionToStatusCode.put(WebClientResponseException.BadRequest.class, HttpStatus.BAD_REQUEST);
        exceptionToStatusCode.put(WebClientResponseException.Conflict.class, HttpStatus.CONFLICT);
        exceptionToStatusCode.put(JwtValidationException.class, HttpStatus.UNAUTHORIZED);
        exceptionToStatusCode.put(BadCredentialsException.class, HttpStatus.UNAUTHORIZED);
        exceptionToStatusCode.put(CannotValidateTokenException.class, HttpStatus.UNAUTHORIZED);
        return exceptionToStatusCode;
    }

    @Bean
    public HttpStatus defaultStatus() {
        return HttpStatus.INTERNAL_SERVER_ERROR;
    }


}
