package com.taptech.common.security.token

import com.taptech.common.EnableCommonConfig
import com.taptech.common.security.keycloak.BaseKeyCloakInfraStructure
import com.taptech.common.security.keycloak.EnableKeyCloak
import com.taptech.common.security.keycloak.KeyCloakAuthenticationManager
import com.taptech.common.security.user.UserContextPermissions
import com.taptech.common.security.utils.SecurityUtils
import com.fasterxml.jackson.databind.ObjectMapper
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.reactive.WebFluxTest
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.oauth2.client.registration.InMemoryReactiveClientRegistrationRepository
import org.springframework.test.context.ContextConfiguration
import org.springframework.test.web.reactive.server.EntityExchangeResult
import org.springframework.test.web.reactive.server.WebTestClient
import spock.mock.DetachedMockFactory

import org.springframework.boot.autoconfigure.security.reactive.ReactiveSecurityAutoConfiguration

@ContextConfiguration(classes = [TestApiControllerConfig.class, BaseKeyCloakInfraStructure.UserLoadConfig.class])
@WebFluxTest(/*controllers = [TokenApiController.class],*/
        properties = [
                "spring.main.allow-bean-definition-overriding=true",
                "openapi.token.base-path=/",
                "idp.provider.keycloak.initialize-on-startup=true",
                "idp.provider.keycloak.initialize-realms-on-startup=false",
                "idp.provider.keycloak.initialize-users-on-startup=true",
        "spring.test.webtestclient.base-url=http://localhost:8888"
        ], excludeAutoConfiguration = ReactiveSecurityAutoConfiguration.class)
class TokenApiControllerTest extends BaseKeyCloakInfraStructure {

    private static final Logger logger = LoggerFactory.getLogger(TokenApiControllerTest.class);

    /*
    ./mvnw clean test -Dtest=TokenApiControllerTest
    ./mvnw clean test -Dtest=TokenApiControllerTest#test_public_validate

     */

    @Autowired
    TokenApiApiDelegate tokenApiDelegate

    @Autowired
    KeyCloakAuthenticationManager keyCloakAuthenticationManager


    @Autowired
    private WebTestClient webTestClient


    @Autowired
    TokenApiController tokenApiController
    InMemoryReactiveClientRegistrationRepository clientRegistrationRepository

    def test_configureToken() {
        expect:
        tokenApiDelegate

    }

    def test_public_jwkkeys() {

        expect:
        webTestClient.get().uri("/public/jwkKeys")
                .exchange()
                .expectStatus().isOk()
                .expectBody()
    }


    def test_public_login() {

        expect:
        webTestClient.get().uri("/public/login")
                .headers(headers -> {
                    headers.setBasicAuth(BaseKeyCloakInfraStructure.adminCC, "admin")
                })
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath(".access_token").isNotEmpty()
                .jsonPath(".refresh_token").isNotEmpty()
    }

    def test_public_login_401() {

        expect:
        webTestClient.get().uri("/public/login")
                .headers(headers -> {
                    headers.setBasicAuth(BaseKeyCloakInfraStructure.adminCC, "bad")
                })
                .exchange()
                .expectStatus().isUnauthorized()
    }

    /*
    def test_public_login_401_no_auth() {

        expect:
        webTestClient.get().uri("/public/login")
                .exchange()
                .expectStatus().isUnauthorized()
    }

     */


    def test_public_refresh_token() {

        given:
        def results = keyCloakAuthenticationManager.passwordGrantLoginMap(BaseKeyCloakInfraStructure.adminCC, "admin", OFFICES).toFuture().join()
        def refreshToken = results.get("refresh_token")

        expect:
        webTestClient.get().uri("/public/refresh")
                .headers(headers -> {
                    headers.set("Authorization", SecurityUtils.toBearerHeaderFromToken(refreshToken))
                    headers.set("contextId", OFFICES)
                })
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath(".access_token").isNotEmpty()
                .jsonPath(".refresh_token").isNotEmpty()
    }


    def test_public_validate() {

        given:
        def results = keyCloakAuthenticationManager.passwordGrantLoginMap(BaseKeyCloakInfraStructure.adminCC, "admin", OFFICES).toFuture().join()
        def accessToken = results.get("access_token")

        expect:
        EntityExchangeResult<UserContextPermissions> entityExchangeResult = webTestClient.get().uri("/public/validate")
                .headers(headers -> {
                    headers.set("Authorization", SecurityUtils.toBearerHeaderFromToken(accessToken))
                })
                .exchange()
                .expectStatus().isOk()
                .expectBody(UserContextPermissions.class)
                .returnResult()

        logger.info("entityExchangeResult: {}", entityExchangeResult.getResponseBody())


    }

    @Configuration
    @EnableCommonConfig
    @EnableKeyCloak
    @EnableTokenApi
    public static class TestApiControllerConfig {

        @Bean
        ObjectMapper objectMapper() {
            return new ObjectMapper();
        }

        DetachedMockFactory mockFactory = new DetachedMockFactory()

    }
}
