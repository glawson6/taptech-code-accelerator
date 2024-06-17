package com.taptech.common.security


import spock.lang.Specification

class UserEntityTest extends Specification {
    /*
 ./mvnw clean test -Dtest=UserEntityTest

  */

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    def test_pojo_builder() {
        def userEntityBuilder = UserEntity.builder()
                .id("id")
                .contextId("contextId")
                .companyName("companyName")
                .country("country")
                .created(0L)
                .externalId("externalId")
                .firstName("firstName")
                .lastName("lastName")
                .email("email")
                .password("password")
                .mailCode("mailCode")
        .roleId("roleId")


        String str = userEntityBuilder.toString()
        int hash = userEntityBuilder.hashCode()
        def userEntity = userEntityBuilder.build()

        expect:
        userEntityBuilder != null
        userEntityBuilder.toString() != null

    }

    def test_pojo(){
        def userEntity = UserEntity.builder()
                .id("id")
                .contextId("contextId")
                .companyName("companyName")
                .country("country")
                .created(0L)
                .externalId("externalId")
                .firstName("firstName")
                .lastName("lastName")
                .email("email")
                .password("password")
                .mailCode("mailCode")
                .build()

        userEntity.hashCode()
        def req = new UserEntity()
        boolean q1 = userEntity.equals(userEntity)
        boolean q2 = userEntity.equals(req)
        boolean q3 = userEntity.equals(null)

        userEntity.setId("id")
        userEntity.setContextId("contextId")
        userEntity.setCompanyName("companyName")
        userEntity.setCountry("country")
        userEntity.setCreated(0L)
        userEntity.setExternalId("externalId")
        userEntity.setFirstName("firstName")
        userEntity.setLastName("lastName")
        userEntity.setEmail("email")
        userEntity.setPassword("password")
        userEntity.setMailCode("mailCode")

        userEntity.getId()
        userEntity.getContextId()
        userEntity.getCompanyName()
        userEntity.getCountry()
        userEntity.getCreated()
        userEntity.getExternalId()
        userEntity.getFirstName()
        userEntity.getLastName()
        userEntity.getEmail()
        userEntity.getPassword()
        userEntity.getMailCode()


        String str = userEntity.toString()
        int hash = userEntity.hashCode()

        expect:
        userEntity != null
    }
}
