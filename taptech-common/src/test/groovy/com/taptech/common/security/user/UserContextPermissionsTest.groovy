package com.taptech.common.security.user


import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spock.lang.Specification

class UserContextPermissionsTest extends Specification {
    private static final Logger logger = LoggerFactory.getLogger(UserContextPermissionsTest.class);

    /*
    ./mvnw clean test -Dtest=UserContextPermissionsTest

     */

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    def test_pojo_builder() {
        def userContextPermissionBuilder = UserContextPermissions.builder()
                .contextId("contextId")
                .permissions(Collections.singleton("permissions"))
                .enabled(true)
        .userId("userId")
        .username("username")
        .roleId("roleId")

        String str = userContextPermissionBuilder.toString()
        int hash = userContextPermissionBuilder.hashCode()
        def userContextPermissions = userContextPermissionBuilder.build()

        expect:
        userContextPermissionBuilder != null
        userContextPermissionBuilder.toString() != null

    }

    def test_pojo(){
        def userContextPermissions = UserContextPermissions.builder()
                .contextId("contextId")
                .permissions(Collections.singleton("permissions"))
                .build()
        def req = new UserContextPermissions()
        def req2 = new UserContextPermissions("username", "userId", "contextId", "roleId", true, new HashSet<String>())

        boolean q1 = userContextPermissions.equals(userContextPermissions)
        boolean q2 =userContextPermissions.equals(req)
        boolean q3 =userContextPermissions.equals(null)
        String str = userContextPermissions.toString()
        userContextPermissions.equals(req2)
        userContextPermissions.hashCode()
        userContextPermissions.setContextId("contextId")
        userContextPermissions.setPermissions(Collections.singleton("permissions"))
        userContextPermissions.setEnabled(true)
        userContextPermissions.setRoleId("roleId")
        userContextPermissions.setUserId("userId")
        userContextPermissions.setUsername("username")
        userContextPermissions.getUsername()
        userContextPermissions.getUserId()
        userContextPermissions.getRoleId()
        userContextPermissions.getPermissions()
        userContextPermissions.getContextId()
        userContextPermissions.getEnabled()

        expect:
        userContextPermissions != null
    }
}
