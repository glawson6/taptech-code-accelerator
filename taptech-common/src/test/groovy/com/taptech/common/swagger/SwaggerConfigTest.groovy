package com.taptech.common.swagger

import com.fasterxml.jackson.databind.ObjectMapper
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import spock.lang.Specification
import spock.mock.DetachedMockFactory
import springfox.documentation.spring.web.plugins.Docket

@SpringBootTest(classes = [TestConfig.class],
        properties = [
                "spring.main.allow-bean-definition-overriding=true"
        ])
class SwaggerConfigTest extends Specification {
    private static final Logger logger = LoggerFactory.getLogger(SwaggerConfigTest.class);

    /*
    ./mvnw clean test -Dtest=SwaggerConfigTest
     */
    static String jdbcUrlFormat = "jdbc:postgresql://%s:%s/%s"


    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    @Autowired
    Docket api

    @Autowired
    SwaggerUiWebFluxConfigurer webFluxConfigurer

    def test_config() {
        expect:
        api
        webFluxConfigurer
    }

    @Configuration
    @EnableWebFluxSwagger
    public static class TestConfig {

        @Bean
        ObjectMapper objectMapper() {
            return new ObjectMapper();
        }

        DetachedMockFactory mockFactory = new DetachedMockFactory()

    }

}
