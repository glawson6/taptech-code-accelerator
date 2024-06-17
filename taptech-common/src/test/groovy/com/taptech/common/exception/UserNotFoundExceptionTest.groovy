package com.taptech.common.exception

import com.taptech.common.security.user.UserContextRequest
import spock.lang.Specification

class UserNotFoundExceptionTest extends Specification {

    /*
 ./mvnw clean test -Dtest=UserNotFoundExceptionTest

  */


    def "should return correct message when user not found"() {
        given:
        String username = "test_user"
        String expectedMessage = "User not found with username: test_user"

        when:
        UserNotFoundException exception = new UserNotFoundException(expectedMessage)

        then:
        exception.message == expectedMessage
    }
    // tests for other constructors
    def "should return correct message and userContextRequest when constructor with message and userContextRequest are used"() {
        given:
        String username = "test_user"
        String expectedMessage = "User not found with username: " + username
        UserContextRequest userContextRequest = new UserContextRequest(username, "contextId", true, "roles", "cacheControl", "token")

        when:
        UserNotFoundException exception = new UserNotFoundException(expectedMessage, userContextRequest)

        then:
        exception.message == expectedMessage
        exception.userContextRequest == userContextRequest

    }

    def "should return correct message and cause when constructor with message and cause are used"() {
        given:
        String username = "test_user"
        String expectedMessage = "User not found with username: " + username
        Exception cause = new Exception("cause")

        when:
        UserNotFoundException exception = new UserNotFoundException(expectedMessage, cause, null)

        then:
        exception.message == expectedMessage
        exception.cause == cause
    }
    // New test methods
    def "should return correct UserContextRequest when parameter only contains UserContextRequest"() {
        given:
        UserContextRequest userContextRequest = new UserContextRequest("userId", "contextId", true, "roles", "cacheControl","token")

        when:
        UserNotFoundException exception = new UserNotFoundException(userContextRequest)

        then:
        exception.userContextRequest == userContextRequest
    }

    def "should return correct UserContextRequest when constructor with message, cause, and UserContextRequest are used"() {
        given:
        String expectedMessage = "User not found"
        UserContextRequest userContextRequest = new UserContextRequest("userId", "contextId", true, "roles", "cacheControl","token")
        Exception cause = new Exception("Cause")

        when:
        UserNotFoundException exception = new UserNotFoundException(expectedMessage, cause, userContextRequest)

        then:
        exception.message == expectedMessage
        exception.cause == cause
        exception.userContextRequest == userContextRequest
    }

    def "should return correct UserContextRequest when constructor with cause and UserContextRequest are used"() {
        given:
        UserContextRequest userContextRequest = new UserContextRequest("userId", "contextId", true, "roles", "cacheControl","token")
        Exception cause = new Exception("Cause")

        when:
        UserNotFoundException exception = new UserNotFoundException(cause, userContextRequest)

        then:
        exception.cause == cause
        exception.userContextRequest == userContextRequest
    }

    def "should return correct UserContextRequest when constructor with message, cause, enableSuppression, writableStackTrace, and UserContextRequest are used"() {
        given:
        String expectedMessage = "User not found"
        UserContextRequest userContextRequest = new UserContextRequest("userId", "contextId", true, "roles", "cacheControl","token")
        Exception cause = new Exception("Cause")

        when:
        UserNotFoundException exception = new UserNotFoundException(expectedMessage, cause, true, true, userContextRequest)

        then:
        exception.message == expectedMessage
        exception.cause == cause
        exception.userContextRequest == userContextRequest
    }
}
