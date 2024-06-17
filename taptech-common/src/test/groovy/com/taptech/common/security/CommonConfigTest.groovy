package com.taptech.common.security

import com.taptech.common.EnableCommonConfig
import com.fasterxml.jackson.databind.ObjectMapper
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.autoconfigure.condition.ConditionalOnBean
import org.springframework.boot.autoconfigure.web.WebProperties
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.http.HttpStatus
import org.springframework.http.codec.ServerCodecConfigurer
import org.springframework.web.reactive.config.EnableWebFlux
import spock.lang.Specification
import spock.mock.DetachedMockFactory

@EnableWebFlux
@SpringBootTest(classes = [TestConfig.class],
    properties = [
            "spring.main.allow-bean-definition-overriding=true"
        ])
class CommonConfigTest  extends Specification {

    private static final Logger logger = LoggerFactory.getLogger(CommonConfigTest.class);

    /*
    ./mvnw clean test -Dtest=CommonConfigTest
     */

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    //@Autowired
    //ReactiveExceptionHandler reactiveExceptionHandler;

    @Autowired
    Map<Class<? extends Exception>, HttpStatus> exceptionToStatusCode

    @Autowired
    HttpStatus defaultStatus

    def test_config() {
        expect:
       // reactiveExceptionHandler
        exceptionToStatusCode
        defaultStatus
    }

    @Configuration
    @EnableCommonConfig
    public static class TestConfig {

        @Bean
        ObjectMapper objectMapper() {
            return new ObjectMapper();
        }

        DetachedMockFactory mockFactory = new DetachedMockFactory()


        @Bean
        WebProperties webProperties() {
            return new WebProperties();
        }


        @Bean
        @ConditionalOnBean(ServerCodecConfigurer.class)
        ServerCodecConfigurer serverCodecConfigurer() {
            return ServerCodecConfigurer.create();
            //return mockFactory.Mock(ServerCodecConfigurer)
        }



    }
}
