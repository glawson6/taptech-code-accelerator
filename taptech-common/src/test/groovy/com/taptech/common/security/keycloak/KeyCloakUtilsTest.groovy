package com.taptech.common.security.keycloak


import com.fasterxml.jackson.databind.ObjectMapper
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.core.io.ClassPathResource
import org.springframework.core.io.Resource
import spock.lang.Specification

class KeyCloakUtilsTest extends Specification {
    private static final Logger logger = LoggerFactory.getLogger(KeyCloakUtilsTest.class);

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
    }   // run af

    def test_convertSecretKeyToString(){
        given:
        def secretKey = KeyCloakUtils.getKeyFromPassword("pass","salt")
        def secretKey2 = KeyCloakUtils.createAKey()
        def secretKey3 = KeyCloakUtils.generateKey(256)

        when:
        def secretKeyString = KeyCloakUtils.convertSecretKeyToString(secretKey)

        then:
        secretKeyString != null
        secretKeyString instanceof String
    }

    def test_convertResultMapToJwt(){

        /*
        public record KeyCloakIdpProperties(String clientId, String clientSecret, String baseUrl, String tokenUri,
                                    String userUri, String realm, String adminTokenUri, String adminUsername,
                                    String adminPassword, String adminClientId, String adminClientSecret,
                                    String jwksetUri, String issuerUrl, String adminRealmUri,
                                    Integer accessCodeLifespan, String defaultContextId, Boolean useStrictJwtValidators,
                                    Boolean initializeOnStartup, Boolean initializeUsersOnStartup,
                                    Boolean initializeRealmsOnStartup)
         */

        given:
        KeyCloakIdpProperties keyCloakIdpProperties = new KeyCloakIdpProperties("clientId","clientSecret", "baseUrl", "tokenUri",
                                    "userUri", "realm", "adminTokenUri", "adminUsername",
                                    "adminPassword", "adminClientId", "adminClientSecret",
                                    "jwksetUri", "issuerUrl", "adminRealmUri",
                                    1, "defaultContextId", true,
                                    true, true, true)

        KeyCloakJwtDecoderFactory keyCloakJwtDecoderFactory = KeyCloakJwtDecoderFactory.builder()
                .keyCloakIdpProperties(keyCloakIdpProperties)
                .build()

        def resultMap = loadMapFromPath("token/expired-token-response.json")
        def jwtDecoder = KeyCloakUtils.createJwtDecoderFromContextId(keyCloakJwtDecoderFactory, "contextId", "http://localhost:8080")

        when:
        def result = KeyCloakUtils.convertResultMapToJwt(jwtDecoder).apply(resultMap)

        then:
        result != null

    }

    Map<String, Object> loadMapFromPath(String path) throws IOException {
        ObjectMapper objectMapper = new ObjectMapper();
        Resource resource = new ClassPathResource(path);
        Map<String, Object> aMap= objectMapper.readValue(resource.getInputStream(), objectMapper.getTypeFactory().constructMapType(HashMap.class, String.class, Object.class));
        return aMap;
    }
}
