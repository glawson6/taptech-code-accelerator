package com.taptech.common.security.token


import spock.lang.Specification

class TokenApiTest extends Specification {
    /*
 ./mvnw clean test -Dtest=TokenApiTest

  */

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
        // Nothing to clean up for now
    }   // run aft


    def "test getDelegate returns TokenApiApiDelegate instance"() {
        given:
        TokenApi tokenApi = new TokenApi(){

        }

        expect:
        tokenApi.getDelegate() instanceof TokenApiApiDelegate
    }
}
