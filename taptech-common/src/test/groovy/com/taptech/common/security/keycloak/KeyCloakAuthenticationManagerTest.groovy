package com.taptech.common.security.keycloak

import com.taptech.common.EnableCommonConfig
import com.taptech.common.security.user.InMemoryUserContextPermissionsService
import com.taptech.common.security.user.SecurityUser
import com.fasterxml.jackson.databind.ObjectMapper
import org.keycloak.admin.client.Keycloak
import org.keycloak.representations.idm.ClientRepresentation
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.oauth2.jwt.JwtDecoder
import org.springframework.security.oauth2.server.resource.authentication.BearerTokenAuthenticationToken
import reactor.test.StepVerifier
import spock.mock.DetachedMockFactory

/**
 * The `KeyCloakAuthenticationManagerTest` is a test class written in Groovy using the Spock testing framework. It is designed to test the functionality of the `KeyCloakAuthenticationManager` class in the context of a Spring Boot application. Here's a breakdown of what this test class is doing:

 1. **Setup**: The class sets up a shared network and a PostgreSQL container for testing. It also sets up a Keycloak container with specific environment variables. System properties are set to configure the Keycloak instance.

 2. **Test Config**: A nested static configuration class `TestConfig` is defined to provide certain beans like `ObjectMapper` for the Spring context during testing.

 3. **Test Cases**: The class contains several test methods (prefixed with `test_`) each designed to test a specific functionality of the `KeyCloakAuthenticationManager`. These include:
 - `test_config`: Tests that the necessary beans are not null and have been properly initialized.
 - `test_retrieve_user_username`: Tests the `retrieveUser` method with a username.
 - `test_passwordGrantLoginMap`: Tests the `passwordGrantLoginMap` method with a username, password, and context.
 - `test_retrieveUser_with_authentication`: Tests the `retrieveUser` method with an authentication token.
 - `test_retrieveUser_with_username_context`: Tests the `retrieveUser` method with a username and context.
 - `test_authentication`: Tests the `authenticate` method with a bearer token.
 - `test_validLoginJwt`: Tests the `validLoginJwt` method with an access token.
 - `test_security_credentials_provider`: Tests the retrieval of access credentials from the `ClientSecretKeyCloakSecurityCredentialsProvider`.
 - `test_KeyCloakService_KCRealmRepresentation_KCRealmRepresentationBuilder`: Tests the `KCRealmRepresentationBuilder` of the `KeyCloakService`.
 - `test_KeyCloakService_ProtocolMapperRepresentation_ProtocolMapperRepresentationBuilder`: Tests the `ProtocolMapperRepresentationBuilder` of the `KeyCloakService`.

 4. **Helper Methods**: The class also contains several helper methods like `setUpUsers`, `logSomeStuff`, `toBasicAuthCreds`, and `basicAuthCredsFrom` which are used to assist in setting up and executing the tests.

 5. **Lifecycle Methods**: The `setupSpec` and `cleanupSpec` methods are used to perform setup and cleanup activities before and after the entire test suite is run. The `setup` and `cleanup` methods are used to perform setup and cleanup activities before and after each test method is run.

 In summary, this test class is ensuring that the `KeyCloakAuthenticationManager` is working as expected and is able to interact correctly with a Keycloak server for user authentication and authorization.
 */

@SpringBootTest(classes = [TestConfig.class,BaseKeyCloakInfraStructure.UserLoadConfig.class],
        properties = [
                "spring.main.allow-bean-definition-overriding=true",
                "idp.provider.keycloak.initialize-on-startup=true",
                "idp.provider.keycloak.initialize-realms-on-startup=true",
                "idp.provider.keycloak.initialize-users-on-startup=true"
        ])
class KeyCloakAuthenticationManagerTest extends BaseKeyCloakInfraStructure {
    private static final Logger logger = LoggerFactory.getLogger(KeyCloakAuthenticationManagerTest.class);

    /*
    ./mvnw clean test -Dtest=KeyCloakAuthenticationManagerTest

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

    def test_config() {
        expect:
        keycloak != null
        keyCloakAuthenticationManager != null
        keyCloakService != null
    }

    // write test for retrieveUser

    def test_retrieve_user_username() {
        given:
        String username = "admin"
        String realm = "master"

        userContextPermissionsService.addPermissions(username, realm, Set.of("admin"))
        userContextPermissionsService.addPermissions(username, "master-realm", Set.of("admin"))

        userContextPermissionsService.addPermissions(username, OFFICES, Set.of("admin"))
        userContextPermissionsService.addPermissions(username, KeyCloakConstants.ADMIN_CLI, Set.of("admin"))

        when:
        def results = keyCloakAuthenticationManager.retrieveUser(username)

        then:
        results != null
        StepVerifier.create(results)
                .assertNext(user -> {
                    user != null
                    user.getUsername() == username
                    user instanceof SecurityUser
                    logger.info("User getPassword: {}", user.getPassword())

                })
                .verifyComplete()
    }


    def logSomeStuff(String contextId) {
        ClientRepresentation clientRepresentation = keycloak.realm(contextId).clients().findAll().stream()
                .peek(cr -> logger.info("clientRepresentation => {}", cr.getClientId()))
                .filter(cr -> cr.getClientId().equals(contextId))
                .findAny().orElseThrow(() -> new KeyCloakClientNotFoundException(new StringBuilder(contextId).append(" not found").toString()));
        String clientSecret = keycloak.realm(contextId).clients().get(clientRepresentation.getId()).getSecret().getValue();

        logger.info("clientRepresentation.getClientId() => {}, clientSecret => {}", contextId, clientSecret);

    }

    def test_passwordGrantLoginMap() {
        given:

        when:
        def results = keyCloakAuthenticationManager.passwordGrantLoginMap(BaseKeyCloakInfraStructure.adminCC, "admin", OFFICES)

        then:
        results != null
        StepVerifier.create(results)
                .assertNext(auth -> {
                    auth != null
                    auth instanceof Map
                    logger.info("Auth: {}", auth)
                    auth.get("access_token") != null
                })
                .verifyComplete()
    }

    def test_passwordGrantLoginMap_no_context() {
        given:

        when:
        def results = keyCloakAuthenticationManager.passwordGrantLoginMap(BaseKeyCloakInfraStructure.adminCC, "admin")

        then:
        results != null
        StepVerifier.create(results)
                .assertNext(auth -> {
                    auth != null
                    auth instanceof Map
                    logger.info("Auth: {}", auth)
                    auth.get("access_token") != null
                })
                .verifyComplete()
    }


    def test_retreiveUser_with_authentication() {
        given:

        String authCreds = toBasicAuthCreds(BaseKeyCloakInfraStructure.adminCC, "admin")
        UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(BaseKeyCloakInfraStructure.adminCC, "admin")

        when:
        def results = keyCloakAuthenticationManager.retrieveUser(authentication)

        then:
        results != null
        StepVerifier.create(results)
                .assertNext(auth -> {
                    auth != null
                    auth instanceof SecurityUser
                    logger.info("Auth: {}", auth)

                })
                .verifyComplete()
    }

    def test_retreiveUser_with_username_context() {
        given:

        when:
        def results = keyCloakAuthenticationManager.retrieveUser(BaseKeyCloakInfraStructure.adminCC, OFFICES)

        then:
        results != null
        StepVerifier.create(results)
                .assertNext(auth -> {
                    auth != null
                    auth instanceof SecurityUser
                    logger.info("Auth: {}", auth)

                })
                .verifyComplete()
    }


    def test_authentication() {
        given:

        def credMap = keyCloakAuthenticationManager.passwordGrantLoginMap(BaseKeyCloakInfraStructure.adminCC, "admin", OFFICES).toFuture().join()
        String accessToken = credMap.get("access_token");

        when:
        def results = keyCloakAuthenticationManager.authenticate(new BearerTokenAuthenticationToken(accessToken))

        then:
        results != null
        StepVerifier.create(results)
                .assertNext(auth -> {
                    auth != null
                    auth instanceof SecurityUser
                    logger.info("Auth: {}", auth)
                })
                .verifyComplete()
    }

    def test_validLoginJwt() {
        given:

        def credMap = keyCloakAuthenticationManager.passwordGrantLoginMap(BaseKeyCloakInfraStructure.adminCC, "admin", OFFICES).block()
        String accessToken = credMap.get("access_token");

        when:
        def results = keyCloakAuthenticationManager.validLoginJwt(accessToken)

        then:
        results != null
        StepVerifier.create(results)
                .assertNext(validJwt -> {
                    validJwt != null
                    validJwt.isPresent()
                })
                .verifyComplete()
    }

    def test_validLoginJwt_with_context() {
        given:
        //setUpUsers()

        def credMap = keyCloakAuthenticationManager.passwordGrantLoginMap(BaseKeyCloakInfraStructure.adminCC, "admin", OFFICES).toFuture().join()
        String accessToken = credMap.get("access_token");
        JwtDecoder jwtDecoder = KeyCloakUtils.createJwtDecoderFromContextId(keyCloakJwtDecoderFactory, OFFICES, keyCloakIdpProperties.baseUrl())

        when:
        def results = keyCloakAuthenticationManager.validLoginJwt(jwtDecoder, accessToken)

        then:
        results != null
        StepVerifier.create(results)
                .assertNext(validJwt -> {
                    validJwt != null
                    validJwt.isPresent()
                })
                .verifyComplete()
    }

    def test_security_credentials_provider() {
        given:

        ClientSecretKeyCloakSecurityCredentialsProvider credentialsProvider = ClientSecretKeyCloakSecurityCredentialsProvider.builder()
                .keyCloakIdpProperties(keyCloakIdpProperties)
                .build()
        credentialsProvider.init()
        when:
        def results = credentialsProvider.retrieveAccessCredentials()

        then:
        results != null
        StepVerifier.create(results)
                .assertNext(auth -> {
                    auth != null
                    auth instanceof Map
                    logger.info("Auth: {}", auth)
                    auth.get("access_token") != null
                })
                .verifyComplete()
    }

    // test for KeyCloakService.KCRealmRepresentation.KCRealmRepresentationBuilder
    def test_KeyCloakService_KCRealmRepresentation_KCRealmRepresentationBuilder(){
        /*

         */
        def kcRealmRepresentation = keyCloakService.defaultRealmRepresentation("offices")
        def kcRealmRepresentationBuilder = new KeyCloakService.KCRealmRepresentation.KCRealmRepresentationBuilder()

        String str = kcRealmRepresentationBuilder.toString()

        expect:
        kcRealmRepresentation != null
    }

    def test_KeyCloakService_ProtocolMapperRepresentation_ProtocolMapperRepresentationBuilder(){
        given:
        /*
        String id, String name, String protocol, String protocolMapper,Boolean consentRequired,
                                               String consentText, Map<String,String> config
         */
        def builder = new KeyCloakService.ProtocolMapperRepresentation.ProtocolMapperRepresentationBuilder()
        builder.id("id")
        builder.name("name")
        builder.consentRequired(true)
        builder.consentText("consentText")
        builder.config(null)
        builder.protocol("protocol")
        builder.protocolMapper("protocolMapper")
        String str = builder.toString()
        def protocolMapperRepresentation = builder.build()

        expect:
        builder != null
    }

    def test_

    static String basicAuthCredsFrom(String s1, String s2) {
        return "Basic " + toBasicAuthCreds(s1, s2);
    }

    static toBasicAuthCreds(String s1, String s2) {
        return Base64.getEncoder().encodeToString((s1 + ":" + s2).getBytes());
    }


    @Configuration
    @EnableCommonConfig
    @EnableKeyCloak
    public static class TestConfig {

        @Bean
        ObjectMapper objectMapper() {
            return new ObjectMapper();
        }

        DetachedMockFactory mockFactory = new DetachedMockFactory()

    }


}
