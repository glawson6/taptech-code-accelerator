package com.taptech.common.security


import spock.lang.Specification

class RoleEntityTest extends Specification {
    /*
 ./mvnw clean test -Dtest=RoleEntityTest

  */

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    def test_pojo_builder() {
        def roleEntityBuilder = RoleEntity.builder()
                .id("id")
                .permissions()
                .roleId("roleId")
                .roleName("roleName")
                .permissions(null)

        String str = roleEntityBuilder.toString()
        int hash = roleEntityBuilder.hashCode()
        def roleEntity = roleEntityBuilder.build()

        expect:
        roleEntityBuilder != null
        roleEntityBuilder.toString() != null

    }

    def test_pojo() {
        def roleEntity = RoleEntity.builder()
                .id("id")
                .permissions()
                .roleId("roleId")
                .roleName("roleName")
                .permissions(null)
                .build()

        roleEntity.hashCode()
        def req = new RoleEntity()
        boolean q1 = roleEntity.equals(roleEntity)
        boolean q2 = roleEntity.equals(req)
        boolean q3 = roleEntity.equals(null)

        roleEntity.setId("id")
        roleEntity.setRoleId("roleId")
        roleEntity.setRoleName("roleName")
        roleEntity.setPermissions(null)

        String str = roleEntity.toString()
        int hash = roleEntity.hashCode()

        expect:
        roleEntity != null
    }
}
