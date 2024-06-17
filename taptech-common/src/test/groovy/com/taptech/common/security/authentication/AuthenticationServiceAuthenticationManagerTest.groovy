package com.taptech.common.security.authentication


import com.taptech.common.EnableCommonConfig
import com.taptech.common.security.keycloak.BaseKeyCloakInfraStructure
import com.taptech.common.security.keycloak.EnableKeyCloak
import com.taptech.common.security.keycloak.KeyCloakAuthenticationManager
import com.taptech.common.security.keycloak.KeyCloakIdpProperties
import com.taptech.common.security.keycloak.KeyCloakJwtDecoderFactory
import com.taptech.common.security.keycloak.KeyCloakService
import com.taptech.common.security.user.HttpReadingUserContextPermissionsService
import com.taptech.common.security.user.InMemoryUserContextPermissionsService
import com.taptech.common.security.user.SecurityUser
import com.taptech.common.security.user.UserContextPermissions
import com.taptech.common.security.utils.SecurityUtils
import com.fasterxml.jackson.databind.ObjectMapper
import org.keycloak.admin.client.Keycloak
import org.mockserver.client.MockServerClient
import org.mockserver.model.HttpRequest
import org.mockserver.model.HttpResponse
import org.mockserver.model.MediaType
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.oauth2.server.resource.authentication.BearerTokenAuthenticationToken
import org.springframework.web.util.UriComponentsBuilder
import org.testcontainers.containers.MockServerContainer
import org.testcontainers.utility.DockerImageName
import reactor.core.publisher.Mono
import reactor.test.StepVerifier
import spock.mock.DetachedMockFactory


@SpringBootTest(classes = [AuthManagerConfig.class],
        properties = [
                "spring.main.allow-bean-definition-overriding=true",
                "idp.provider.keycloak.initialize-on-startup=true",
                "idp.provider.keycloak.initialize-realms-on-startup=true",
                "idp.provider.keycloak.initialize-users-on-startup=true"
        ])
class AuthenticationServiceAuthenticationManagerTest extends BaseKeyCloakInfraStructure {
    private static final Logger logger = LoggerFactory.getLogger(AuthenticationServiceAuthenticationManagerTest.class);

    public static final DockerImageName MOCKSERVER_IMAGE = DockerImageName
            .parse("mockserver/mockserver")


    static final Set<String> ADMIN = Set.of("read", "delete", "update", "create");
    static final Set<String> USER = Set.of("read");
    static final String VALID_TOKEN_STRING = "valid-token"
    static final String INVALID_TOKEN_STRING = "invalid-token"
    static final String VALID_TOKEN = SecurityUtils.toBearerHeaderFromToken(VALID_TOKEN_STRING)
    static final String INVALID_TOKEN = SecurityUtils.toBearerHeaderFromToken(INVALID_TOKEN_STRING)

    /*
    ./mvnw clean test -Dtest=AuthenticationServiceAuthenticationManagerTest
    ./mvnw clean test -Dtest=AuthenticationServiceAuthenticationManagerTest

     */

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {
    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    @Autowired
    MockServerClient mockServerClient

    @Autowired
    MockServerContainer mockServer

    @Autowired
    UserContextPermissions userContextPermissions

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
    AuthenticationServiceAuthenticationManager authenticationServiceAuthenticationManager

    def test_config() {
        expect:
        mockServerClient != null
        mockServer != null
        userContextPermissions != null
        keycloak != null
        keyCloakAuthenticationManager != null
        keyCloakService != null
        authenticationServiceAuthenticationManager != null
    }

    def test_authentication(){
        given:

        def credMap = keyCloakAuthenticationManager.passwordGrantLoginMap(BaseKeyCloakInfraStructure.adminCC, "admin", OFFICES).toFuture().join()
        String accessToken = credMap.get("access_token");

        when:
        def results = authenticationServiceAuthenticationManager.authenticate(new BearerTokenAuthenticationToken(accessToken))

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

    @Configuration
    @EnableCommonConfig
    @EnableKeyCloak
    public static class AuthManagerConfig {

        DetachedMockFactory mockFactory = new DetachedMockFactory()

        @Bean
        UserContextPermissions userContextPermissions() {
            return UserContextPermissions.builder()
                    .roleId("admin")
                    .username("admin@cc.com")
                    .contextId("offices")
                    .permissions(ADMIN)
                    .build();
        }

        @Bean
        MockServerContainer mockServer() {
            MockServerContainer mockServer = new MockServerContainer(MOCKSERVER_IMAGE);
            mockServer.start();
            return mockServer
        }

        @Bean
        Mono<Map<String,Object>> publicKeyMap(KeyCloakAuthenticationManager keyCloakAuthenticationManager) {
            return keyCloakAuthenticationManager.getPublicKeyFromContextId(keyCloakAuthenticationManager.getDefaultContext());
        }

        @Bean
        MockServerClient mockServerClient(MockServerContainer mockServer,
                                          UserContextPermissions userContextPermissions,
                                          Mono<Map<String,Object>> publicKeyMapMono) {
            MockServerClient mockServerClient = new MockServerClient(mockServer.getHost(), mockServer.getServerPort())
            ObjectMapper objectMapper = new ObjectMapper();
            String body = objectMapper.writeValueAsString(userContextPermissions);

            Map<String, Object> publicKeyMap = publicKeyMapMono.toFuture().join()

            String publicKeyMapBody = objectMapper.writeValueAsString(publicKeyMap);
            mockServerClient.when(HttpRequest.request().withPath("/public/validate")
                    /*.withHeader(Constants.AUTHORIZATION, VALID_TOKEN_STRING)*/)
                    .respond(HttpResponse.response()
                            .withContentType(MediaType.APPLICATION_JSON)
                            .withBody(body));
            mockServerClient.when(HttpRequest.request().withPath("/public/jwkKeys")
                    /*.withHeader(Constants.AUTHORIZATION, VALID_TOKEN_STRING)*/)
                    .respond(HttpResponse.response()
                            .withContentType(MediaType.APPLICATION_JSON)
                            .withBody(publicKeyMapBody));
            return mockServerClient;
        }

        @Bean
        HttpReadingUserContextPermissionsService userContextPermissionsService(MockServerContainer mockServer) {
            return HttpReadingUserContextPermissionsService.builder()
                    .baseUrl(mockServer.getEndpoint())
                    .build()
        }

        @Bean
        AuthenticationServiceAuthenticationManager authenticationServiceAuthenticationManager(MockServerContainer mockServer,
        HttpReadingUserContextPermissionsService userContextPermissionsService  ) {
            String jwkSetPath = UriComponentsBuilder.fromHttpUrl(mockServer.getEndpoint())
                    .path(SecurityUtils.AUTH_CERT_CLIENT_URI)
                    .build()
                    .toString();

            return AuthenticationServiceAuthenticationManager.builder()
                    .userContextPermissionsService(userContextPermissionsService)
                    .jwkSetUri(jwkSetPath)
                    .defaultContext("offices")
                    .build()
        }


    }
}
