package com.taptech.common.security


import spock.lang.Specification

class ContextEntityTest extends Specification {
    /*
  ./mvnw clean test -Dtest=ContextEntityTest

   */

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    def test_pojo_builder() {
        def contextEntityBuilder = ContextEntity.builder()
                .id("id")
                .contextId("contextId")
                .enabled(true)
                .roles(null)
                .contextName("contextName")
                .createdBy("createdBy")
                .createdDate()
                .lastModifiedBy("lastModifiedBy")
                .lastModifiedByDate()
                .name("name")
                .description("description")
                .transactionId("transactionId")
                .permissions(null)


        String str = contextEntityBuilder.toString()
        int hash = contextEntityBuilder.hashCode()
        def contextEntity = contextEntityBuilder.build()

        expect:
        contextEntityBuilder != null
        contextEntityBuilder.toString() != null

    }

    def test_pojo() {
        def contextEntity = ContextEntity.builder()
                .id("id")
                .contextId("contextId")
                .enabled(true)
                .roles(null)
                .contextName("contextName")
                .createdBy("createdBy")
                .createdDate()
                .lastModifiedBy("lastModifiedBy")
                .lastModifiedByDate()
                .name("name")
                .description("description")
                .transactionId("transactionId")
                .permissions(null)
                .build()

        contextEntity.hashCode()
        def req = new ContextEntity()
        boolean q1 = contextEntity.equals(contextEntity)
        boolean q2 = contextEntity.equals(req)
        boolean q3 = contextEntity.equals(null)

        contextEntity.setId("id")
        contextEntity.setContextId("contextId")
        contextEntity.setEnabled(true)
        contextEntity.setRoles(null)
        contextEntity.setContextName("contextName")
        contextEntity.setCreatedBy("createdBy")
        contextEntity.setCreatedDate()
        contextEntity.setLastModifiedBy("lastModifiedBy")
        contextEntity.setLastModifiedByDate()
        contextEntity.setName("name")
        contextEntity.setDescription("description")
        contextEntity.setTransactionId("transactionId")
        contextEntity.setPermissions(null)

        contextEntity.getId()
        contextEntity.getContextId()
        contextEntity.isEnabled()
        contextEntity.getRoles()
        contextEntity.getContextName()
        contextEntity.getCreatedBy()
        contextEntity.getCreatedDate()
        contextEntity.getLastModifiedBy()
        contextEntity.getLastModifiedByDate()
        contextEntity.getName()
        contextEntity.getDescription()
        contextEntity.getTransactionId()
        contextEntity.getPermissions()


        String str = contextEntity.toString()
        int hash = contextEntity.hashCode()

        expect:
        contextEntity != null
    }
}
