package com.taptech.offices


import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.Import
import org.springframework.security.web.server.SecurityWebFilterChain
import spock.lang.Specification
import spock.mock.DetachedMockFactory

@SpringBootTest(classes = [


        TestNonSecureConfig.class],
        properties = [
                "spring.main.allow-bean-definition-overriding=true",
                "spring.profiles.active=default",
        ])
class SecurityNonSecureConfigTest extends Specification {

    private static final Logger logger = LoggerFactory.getLogger(SecurityNonSecureConfigTest.class);

    /*
   ./mvnw clean test -Dtest=SecurityNonSecureConfigTest
    */

    @Autowired
    SecurityWebFilterChain securityWebFilterChain

    def test_config() {

        expect:
        securityWebFilterChain != null

    }

    @Configuration
    @Import(SecurityConfig.class)
    public static class TestNonSecureConfig {


        TestNonSecureConfig() {
            logger.info("####################### TestNonSecureConfig created");
        }
        DetachedMockFactory mockFactory = new DetachedMockFactory()



    }
}
