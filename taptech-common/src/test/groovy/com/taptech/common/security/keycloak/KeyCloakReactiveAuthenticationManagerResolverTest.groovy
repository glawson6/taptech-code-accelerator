package com.taptech.common.security.keycloak


import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.security.authentication.ReactiveAuthenticationManager
import org.springframework.web.server.ServerWebExchange
import spock.lang.Specification

class KeyCloakReactiveAuthenticationManagerResolverTest extends Specification {

    private static final Logger logger = LoggerFactory.getLogger(KeyCloakReactiveAuthenticationManagerResolverTest.class);

    public static final String OFFICES = "offices";
    /*
    ./mvnw clean test -Dtest=KeyCloakReactiveAuthenticationManagerResolverTest

     */

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    def test_resolve() {
        given:
        ReactiveAuthenticationManager keyCloakAuthenticationManager  = Mock(ReactiveAuthenticationManager)
        def keyCloakReactiveAuthenticationManagerResolver = new KeyCloakReactiveAuthenticationManagerResolver(keyCloakAuthenticationManager)
        ServerWebExchange serverWebExchange = Mock(ServerWebExchange)

        when:
        def reactiveAuthenticationManager = keyCloakReactiveAuthenticationManagerResolver.resolve(serverWebExchange)

        then:
        reactiveAuthenticationManager != null
    }

}
