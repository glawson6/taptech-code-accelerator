package com.taptech.offices

import com.taptech.common.EnableCommonConfig
import com.taptech.common.security.keycloak.EnableKeyCloak
import com.taptech.common.security.user.UserContextPermissionsConfig
import com.taptech.offices.service.OfficesConfiguration
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.autoconfigure.AutoConfigureAfter
import org.springframework.boot.test.autoconfigure.web.reactive.AutoConfigureWebFlux
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.Import
import org.springframework.security.oauth2.jwt.ReactiveJwtDecoder
import org.testcontainers.containers.PostgreSQLContainer
import spock.mock.DetachedMockFactory


@AutoConfigureWebFlux
@SpringBootTest(classes = [
        TestOfficeConfig.class],
        properties = [
                "spring.main.allow-bean-definition-overriding=true",
                "spring.data.jpa.repositories.enabled=true",
                "spring.profiles.active=secure-jwk",
                "spring.security.oauth2.resourceserver.jwt.jwk-set-uri=http://localhost:8080/auth/realms/office/protocol/openid-connect/certs",
        "user.context.permissions.base-url=http://localhost:8080",
        "user.context.permissions.service=http-read"
        ])
class SecureJwkConfigTest extends BaseKeyCloakInfraStructure {

    private static final Logger logger = LoggerFactory.getLogger(SecureJwkConfigTest.class);

    /*
    ./mvnw clean test -Dtest=SecureJwkConfigTest
     */
    static String jdbcUrlFormat = "jdbc:postgresql://%s:%s/%s"
    static PostgreSQLContainer<?> container = createPostgresqlContainer()

    static PostgreSQLContainer createPostgresqlContainer() {
        PostgreSQLContainer container = new PostgreSQLContainer<>("postgres:15-alpine")
        return container
    }

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {
        container.start()
        //String jdbcUrl = String.format(jdbcUrlFormat, container.getHost(), container.getMappedPort(5432), container.getDatabaseName());

        String jdbcUrl = container.getJdbcUrl()
        logger.info("JDBC URL: {}", jdbcUrl)
        System.setProperty("spring.datasource.url", jdbcUrl)
        System.setProperty("spring.datasource.username", container.getUsername())
        System.setProperty("spring.datasource.password", container.getPassword())
        System.setProperty("spring.datasource.driverClassName", "org.postgresql.Driver");
        System.setProperty("POSTGRES_URL", jdbcUrl)
        System.setProperty("POSRGRES_USER", container.getUsername())
        System.setProperty("POSRGRES_PASSWORD", container.getPassword());

    }     // run before the first feature method
    def cleanupSpec() {
        container.stop()
    }   // run after


    @Autowired
    ReactiveJwtDecoder jwtDecoder

    def test_config() {

        expect:
        jwtDecoder != null

    }


    @Configuration
    @AutoConfigureAfter(OfficesConfiguration.class)
    @EnableCommonConfig
    @Import([UserContextPermissionsConfig.class, SecurityConfig.class])
    @EnableKeyCloak
    //@EnableTokenApi
    public static class TestOfficeConfig {


        TestOfficeConfig() {
            logger.info("####################### TestOfficeConfig created");
        }
        DetachedMockFactory mockFactory = new DetachedMockFactory()

        /*
        @Bean
        UserContextPermissionsService inMemoryUserContextPermissionsService() {
            InMemoryUserContextPermissionsService inMemoryUserContextPermissionsService = new InMemoryUserContextPermissionsService();
            return inMemoryUserContextPermissionsService;

        }

         */

    }
}