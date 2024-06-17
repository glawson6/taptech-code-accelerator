package com.taptech.common.exception


import spock.lang.Specification

class ErrorResponseTest extends Specification {
    /*
  ./mvnw clean test -Dtest=SecurityUserTest

   */

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    def test_pojo_builder() {
        def errorResponseBuilder = ErrorResponse.builder()
                .message("message")
                .code(200)

        String str = errorResponseBuilder.toString()
        int hash = errorResponseBuilder.hashCode()
        def errorResponse = errorResponseBuilder.build()

        expect:
        errorResponseBuilder != null
        errorResponseBuilder.toString() != null

    }

    def test_pojo() {
        def errorResponse = ErrorResponse.builder()
                .message("message")
                .code(200)
                .build()

        errorResponse.hashCode()
        def req = new ErrorResponse()
        boolean q1 = errorResponse.equals(errorResponse)
        boolean q2 = errorResponse.equals(req)
        boolean q3 = errorResponse.equals(null)

        errorResponse.setMessage("message")
        errorResponse.setCode(200)

        String str = errorResponse.toString()
        int hash = errorResponse.hashCode()

        expect:
        errorResponse != null
    }
}
