package com.taptech.common.security.token


import spock.lang.Specification

class KeyCloakTokenApiDelegateTest extends Specification {
    /*
 ./mvnw clean test -Dtest=DefaultTokenApiDelegateTest

  */

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    def test_pojo_builder() {
        def defaultTokenApiDelegateBuilder = KeyCloakTokenApiDelegate.builder()
        .objectMapper()
        .objectMapperAll()

        String str = defaultTokenApiDelegateBuilder.toString()
        int hash = defaultTokenApiDelegateBuilder.hashCode()
        def defaultTokenApiDelegate = defaultTokenApiDelegateBuilder.build()
        expect:
        defaultTokenApiDelegateBuilder != null
    }
}
