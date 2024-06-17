package com.taptech.common.security.keycloak

import com.fasterxml.jackson.databind.ObjectMapper
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.oauth2.client.registration.ClientRegistration
import org.springframework.security.oauth2.core.AuthorizationGrantType
import org.springframework.security.oauth2.core.OAuth2TokenValidator
import org.springframework.security.oauth2.jwt.JwtDecoder
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder
import org.springframework.web.util.UriComponentsBuilder
import spock.lang.Specification
import spock.mock.DetachedMockFactory

@SpringBootTest(classes = [TestConfig.class],
        properties = [
                "spring.main.allow-bean-definition-overriding=true",
                "idp.provider.keycloak.client-secret=admin",
                "idp.provider.keycloak.realm=offices",
                "idp.provider.keycloak.client-id=offices",
                "idp.provider.keycloak.base-url=http://localhost:8080",
                "idp.provider.keycloak.token-uri=/realms/offices/protocol/openid-connect/token",
                "idp.provider.keycloak.jwkset-uri=http://localhost:8080/realms/offices/protocol/openid-connect/certs",
                "idp.provider.keycloak.issuer-url=http://localhost:8080/realms/offices",
                "idp.provider.keycloak.user-uri=/admin/realms/{realm}/users",
                "idp.provider.keycloak.admin-token-uri=/realms/master/protocol/openid-connect/token",
                "idp.provider.keycloak.admin-username=admin",
                "idp.provider.keycloak.admin-password=admin",
                "idp.provider.keycloak.admin-client-secret=setme",
                "idp.provider.keycloak.admin-client-id=admin-cli",
                "idp.provider.keycloak.default-context-id=offices",
                "idp.provider.keycloak.use-strict-jwt-validators=false"
        ])
class KeyCloakJwtDecoderFactoryTest extends Specification {
    private static final Logger logger = LoggerFactory.getLogger(KeyCloakJwtDecoderFactoryTest.class);

    public static final String OFFICES = "offices";
    /*
    ./mvnw clean test -Dtest=KeyCloakJwtDecoderFactoryTest

     */

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    @Autowired
    KeyCloakIdpProperties keyCloakIdpProperties;

    def test_sanity() {
        expect:
        keyCloakIdpProperties
    }

    def test_createDecoder() {

        given:
        String contextId = OFFICES;
        String realmBaseUrl = "http://localhost:8080/auth/realms/";
        KeyCloakJwtDecoderFactory keyCloakJwtDecoderFactory = KeyCloakJwtDecoderFactory.builder()
                .keyCloakIdpProperties(keyCloakIdpProperties)
                .build();
        String jwkSetPath = UriComponentsBuilder.fromHttpUrl(realmBaseUrl).path(KeyCloakUtils.CERT_CLIENT_URI).build(Map.of("realm", contextId)).toString();
        String tokenPath = UriComponentsBuilder.fromHttpUrl(realmBaseUrl).path(KeyCloakUtils.TOKEN_CLIENT_URI).build(Map.of("realm", contextId)).toString();
        String issuerPath = UriComponentsBuilder.fromHttpUrl(realmBaseUrl).path(KeyCloakUtils.ISSUER_CLIENT_URI).build(Map.of("realm", contextId)).toString();
        logger.info("createJwtDecoderFromContextId Calculated jwkSetPath =>  {} tokenPath => {} issuerUrl => {} for JwtDecoder ",
                new Object[]{jwkSetPath, tokenPath, issuerPath});
        ClientRegistration.Builder builder = ClientRegistration.withRegistrationId(contextId);
        ClientRegistration clientRegistration = builder.clientId(contextId)
                .jwkSetUri(jwkSetPath)
                .tokenUri(tokenPath)
                .issuerUri(issuerPath)
                .authorizationGrantType(AuthorizationGrantType.CLIENT_CREDENTIALS)
                .build();

        when:
        JwtDecoder jwtDecoder = keyCloakJwtDecoderFactory.createDecoder(clientRegistration);

        then:
        jwtDecoder != null
        jwtDecoder instanceof NimbusJwtDecoder
        NimbusJwtDecoder nimbusJwtDecoder = (NimbusJwtDecoder) jwtDecoder;
        nimbusJwtDecoder.jwtValidator != null
        nimbusJwtDecoder.jwtValidator instanceof OAuth2TokenValidator
        //OAuth2TokenValidator tokenValidator = (OAuth2TokenValidator)nimbusJwtDecoder.jwtValidator;
    }

    @Configuration
    @EnableConfigurationProperties(KeyCloakIdpProperties.class)
    public static class TestConfig {

        @Bean
        ObjectMapper objectMapper() {
            return new ObjectMapper();
        }

        DetachedMockFactory mockFactory = new DetachedMockFactory()

    }
}
