package com.taptech.common.security.keycloak

import com.taptech.common.security.UserEntity
import com.taptech.common.security.user.InMemoryUserContextPermissionsService
import com.fasterxml.jackson.databind.ObjectMapper
import org.keycloak.admin.client.Keycloak
import org.keycloak.representations.idm.UserRepresentation
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.core.env.Environment
import spock.mock.DetachedMockFactory

import java.util.stream.Collectors


@SpringBootTest(classes = [TestConfig.class, BaseKeyCloakInfraStructure.UserLoadConfig.class],
        properties = [
                "spring.main.allow-bean-definition-overriding=true",
                "idp.provider.keycloak.realm=offices",
                "idp.provider.keycloak.initialize-on-startup=true",
                "idp.provider.keycloak.initialize-realms-on-startup=true",
                "idp.provider.keycloak.initialize-users-on-startup=true",
                "idp.provider.keycloak.init-keycloak-users-path=users/init-keycloak-users.json"
        ])
class KeyCloakInitializerTest extends BaseKeyCloakInfraStructure {
    private static final Logger logger = LoggerFactory.getLogger(KeyCloakInitializerTest.class);

    /*
    ./mvnw clean test -Dtest=KeyCloakInitializerTest

    ./mvnw clean test -Dtest=KeyCloakAuthenticationManagerTest#test_passwordGrantLoginMap
    ./mvnw clean test -Dtest=KeyCloakAuthenticationManagerTest#test_security_credentials_provider
     */

    @Autowired
    Keycloak keycloak

    @Autowired
    KeyCloakAuthenticationManager keyCloakAuthenticationManager

    @Autowired
    InMemoryUserContextPermissionsService userContextPermissionsService

    @Autowired
    KeyCloakService keyCloakService

    @Autowired
    KeyCloakIdpProperties keyCloakIdpProperties

    @Autowired
    KeyCloakJwtDecoderFactory keyCloakJwtDecoderFactory


    @Autowired
    KeyCloakInitializer keyCloakInitializer

    @Autowired
    Environment env


    def test_config() {
        expect:
        keycloak != null
        keyCloakAuthenticationManager != null
        keyCloakService != null
        keyCloakInitializer != null


    }

    static toBasicAuthCreds(String s1, String s2) {
        return Base64.getEncoder().encodeToString((s1 + ":" + s2).getBytes());
    }


    def test_expected_users_loaded_from_json() {
        given:
        def expectedUsers = ["admin.bart@cc.com","user.lisa@cc.com","user.maggy@cc.com"]
        ObjectMapper objectMapper = new ObjectMapper();
        String initKeycloakUsersPath = env.getProperty("idp.provider.keycloak.init-keycloak-users-path")
        List<UserEntity> users = keyCloakInitializer.loadUserEntitiesFromClassPath(objectMapper).apply(initKeycloakUsersPath)

        expect:
        users != null
        List<String> userList = users.stream()
                .map(user -> user.getEmail())
                .collect(Collectors.toList())
        logger.info("userList: {}", userList)
        userList.containsAll(expectedUsers)

    }

    def test_users_initialized() {
        given:
        def expectedUsers = ["admin.bart@cc.com","user.lisa@cc.com","user.maggy@cc.com"]
        List<UserRepresentation> users = keyCloakService.findUsersListFromRealm(OFFICES)

        expect:
        users != null
        List<String> userList = users.stream()
                .map(UserRepresentation::getUsername)
                .collect(Collectors.toList())
        logger.info("userList: {}", userList)
        userList.containsAll(expectedUsers)

    }


    @Configuration
    @EnableKeyCloak
    public static class TestConfig {

        @Bean("keyCloakObjectMapper")
        ObjectMapper objectMapper() {
            return new ObjectMapper();
        }

        DetachedMockFactory mockFactory = new DetachedMockFactory()

    }


}
