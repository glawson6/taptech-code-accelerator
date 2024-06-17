package com.taptech.common.security.user


import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spock.lang.Specification

class UserContextRequestTest extends Specification {
    private static final Logger logger = LoggerFactory.getLogger(UserContextRequestTest.class);

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

    def test_pojo_builder() {
        def userContextRequestBuilder = UserContextRequest.builder()
                .contextId("contextId")
                .allRoles(true)
                .cacheControl("cacheControl")
                .roles("roles")
                .userId("userId")

        String str = userContextRequestBuilder.toString()
        int hash = userContextRequestBuilder.hashCode()

        expect:
        userContextRequestBuilder != null
        userContextRequestBuilder.toString() != null

    }

    def test_pojo(){
        def userContextRequest = UserContextRequest.builder()
                .contextId("contextId")
                .allRoles(true)
                .cacheControl("cacheControl")
                .roles("roles")
                .userId("userId")
                .build()
        def req = new UserContextRequest()

        userContextRequest.hashCode()
        boolean q1 = userContextRequest.equals(userContextRequest)
        boolean q2 =userContextRequest.equals(req)
        boolean q3 =userContextRequest.equals(null)
        userContextRequest.setAllRoles(true)
        userContextRequest.setCacheControl("cacheControl")
        userContextRequest.setContextId("contextId")
        userContextRequest.setRoles("roles")
        userContextRequest.setUserId("userId")
        userContextRequest.getAllRoles()
        userContextRequest.getCacheControl()
        userContextRequest.getContextId()
        userContextRequest.getRoles()
        userContextRequest.getUserId()
        userContextRequest.toString()
        expect:
        userContextRequest != null
        userContextRequest.toString() != null

    }
}
