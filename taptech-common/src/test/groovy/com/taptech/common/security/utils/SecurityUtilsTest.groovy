package com.taptech.common.security.utils


import com.taptech.common.security.user.UserContextPermissions
import com.fasterxml.jackson.databind.JsonNode
import com.fasterxml.jackson.databind.ObjectMapper
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.security.core.Authentication
import org.springframework.security.core.userdetails.UserDetails
import reactor.util.function.Tuple2;
import reactor.util.function.Tuples;
import spock.lang.Specification

import java.nio.charset.Charset

class SecurityUtilsTest extends Specification {
    private static final Logger logger = LoggerFactory.getLogger(SecurityUtilsTest.class);

    /*
    ./mvnw clean test -Dtest=SecurityUtilsTest

     */

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    def "should return correct basic auth when username and password provided"() {
        given:
        String username = "test_user"
        String password = "test_password"
        String expectedBasicAuth = Base64.getEncoder().encodeToString(("test_user" + ":" + "test_password").getBytes(Charset.defaultCharset()))

        when:
        String actualBasicAuth = SecurityUtils.basicAuthCredsFrom(username, password)

        then:
        actualBasicAuth == expectedBasicAuth
    }
    def "should return correct tuple when basic auth provided3"() {
        given:
        String username = "test_user"
        String password = "test_password"
        String basicAuth = SecurityUtils.basicAuthCredsFrom(username, password)
        Tuple2<String, String> expectedTuple = Tuples.of(username, password)

        when:
        Tuple2<String, String> actualTuple = SecurityUtils.fromBasicAuthToTuple(basicAuth)

        then:
        actualTuple == expectedTuple
    }
    def "should return correct token when bearer header provided"() {
        given:
        String bearerHeader = SecurityUtils.BEARER_PREFIX + "test_token"
        String expectedToken = "test_token"

        when:
        String actualToken = SecurityUtils.fromBearerHeaderToToken(bearerHeader)

        then:
        actualToken == expectedToken
    }
    def "should return correct bearer header when token provided"() {
        given:
        String token = "test_token"
        String expectedBearerHeader = SecurityUtils.BEARER_PREFIX + "test_token"

        when:
        String actualBearerHeader = SecurityUtils.toBearerHeaderFromToken(token)

        then:
        actualBearerHeader == expectedBearerHeader
    }
    def "should return correct bearer header when token provided2"() {
        given:
        String token = "test_token"
        String expectedBearerHeader = SecurityUtils.BEARER_PREFIX + "test_token"

        when:
        String actualBearerHeader = SecurityUtils.toBearerHeaderFromToken(token)

        then:
        actualBearerHeader == expectedBearerHeader
    }

    def "should return correct UserDetails when UserContextPermissions provided"() {
        given: 'UserContextPermissions instance is initialized with test values'
        def userContextPermissions = new UserContextPermissions()
        userContextPermissions.setPermissions(new HashSet<>(Arrays.asList("PERMISSION_1", "PERMISSION_2")))

        when: 'convertUserContextPermissionsToUserDetails function from SecurityUtils is applied'
        UserDetails actualUserDetails = SecurityUtils.convertUserContextPermissionsToUserDetails()
                .apply(userContextPermissions)

        then: 'The actualUserDetails object should match the expected values'
        actualUserDetails.getUsername().equals(userContextPermissions.getUserId())

        /*
        assert actualUserDetails.getAuthorities().stream().map(GrantedAuthority::getAuthority)
                .collect(Collectors.toList()).equals(new ArrayList<>(userContextPermissions.getPermissions()))

         */
    }

    def "should return UserDetails with noOpUserDetails method when username provided"() {
        given: 'A username is provided'
        String username = "test_user"

        when: 'noOpUserDetails method from SecurityUtils is applied'
        UserDetails actualUserDetails = SecurityUtils.noOpUserDetails(username)

        then: 'The actualUserDetails object should match the expected values'
        actualUserDetails.getUsername().equals(username)
    }

    /*
    def "should return correct UserDetails when UserContextPermissions and optional Jwt value provided"() {
        given: 'UserContextPermissions and optional Jwt value are initialized with test values'
        def userContextPermissions = new UserContextPermissions()
        userContextPermissions.setUserId("test_user")
        userContextPermissions.setPermissions(new HashSet<>(Arrays.asList("PERMISSION_1", "PERMISSION_2")))
        Optional<Jwt> jwtOptional = Optional.of(Mock(Jwt.class))

        when: 'convertUserContextPermissionsToUserDetails function from SecurityUtils is applied'
        UserDetails actualUserDetails = SecurityUtils.convertUserContextPermissionsToUserDetails(jwtOptional)
                .apply(userContextPermissions)

        then: 'The actualUserDetails object should match the expected values'
        actualUserDetails.getUsername().equals(userContextPermissions.getUserId())

        def userContextPermissions2 = new UserContextPermissions()
        userContextPermissions.setPermissions(new HashSet<>(Arrays.asList("PERMISSION_1", "PERMISSION_2")))
                .collect(Collectors.toList()).equals(new ArrayList<>(userContextPermissions.getPermissions()))


    }

     */

    def "should return AnonymousAuthenticationToken when username is given"() {
        given: 'A username is provided'
        String username = "test_user"

        when: 'noOpAuthentication method from SecurityUtils is applied'
        Authentication actualAuthentication = SecurityUtils.noOpAuthentication(username)

        then: 'The actualUserDetails object should match the expected values'
        actualAuthentication.getName().equals(username)
    }
    def "should return correct JsonNode when map and ObjectMapper provided"() {
        given: 'A map and ObjectMapper is provided'
        Map<String, Object> map = new HashMap<>()
        ObjectMapper objectMapper = new ObjectMapper()
        map.put("test_key", "test_value")
        JsonNode expectedJsonNode = objectMapper.convertValue(map, JsonNode.class)

        when: 'convertToStringThenJsonNode method from SecurityUtils is applied'
        JsonNode actualJsonNode = SecurityUtils.convertToStringThenJsonNode().apply(map, objectMapper)

        then: 'The actualJsonNode should match the expected values'
        actualJsonNode.equals(expectedJsonNode)
    }
    def "should return InputStream when resourcePath is given"() {
        given: 'A resourcePath is provided'
        String resourcePath = "test-resource.txt"
        InputStream expectedInputStream = this.getClass().getClassLoader().getResourceAsStream(resourcePath)

        when: 'getInputStreamFromResource method from SecurityUtils is called'
        InputStream actualInputStream = SecurityUtils.getInputStreamFromResource(resourcePath)

        then: 'actualInputStream should not be null'
        actualInputStream != null
    }
}
