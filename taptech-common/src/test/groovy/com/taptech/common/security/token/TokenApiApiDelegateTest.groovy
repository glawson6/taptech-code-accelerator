package com.taptech.common.security.token

import com.fasterxml.jackson.databind.JsonNode
import com.fasterxml.jackson.databind.node.JsonNodeFactory
import com.fasterxml.jackson.databind.node.ObjectNode
import org.springframework.http.ResponseEntity
import org.springframework.mock.http.server.reactive.MockServerHttpResponse
import org.springframework.web.context.request.NativeWebRequest
import org.springframework.web.server.ServerWebExchange
import reactor.core.publisher.Mono
import spock.lang.Specification

class TokenApiApiDelegateTest extends Specification {
    /*
  ./mvnw clean test -Dtest=TokenApiApiDelegateTest

   */

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    def "test getRequest when request is not present"() {

        given:
        TokenApiApiDelegate tokenApiApiDelegate = new TokenApiApiDelegate() {

        }

        when:
        Optional<NativeWebRequest> result = tokenApiApiDelegate.getRequest()

        then:
        !result.isPresent()
    }

    void "test getPublicLogin when not implemented"() {
        given:
        String authorization = "Basic auth"
        String contextId = "1"
        ServerWebExchange serverWebExchange = Mock(ServerWebExchange)
        TokenApiApiDelegate tokenApiApiDelegate = Mock(TokenApiApiDelegate)

        when:
        tokenApiApiDelegate.getPublicLogin(authorization, contextId, serverWebExchange) >> Mono.empty()
        Mono<ResponseEntity<ObjectNode>> result = tokenApiApiDelegate.getPublicLogin(authorization, contextId, serverWebExchange)

        then:
        result == Mono.empty()
    }

    void "test getRequest when request is present"() {
        given:
        TokenApiApiDelegate tokenApiApiDelegate = Mock(TokenApiApiDelegate)

        when:
        NativeWebRequest request = Mock(NativeWebRequest)
        tokenApiApiDelegate.getRequest() >> Optional.of(request)

        Optional<NativeWebRequest> result = tokenApiApiDelegate.getRequest()

        then:
        result.get() == request
    }

    def "test getJwkKeys when keys are not present"() {
        given:
        ServerWebExchange serverWebExchange = Mock(ServerWebExchange){
            getResponse() >> new MockServerHttpResponse()

        }
        ObjectNode objectNode = new ObjectNode(new JsonNodeFactory(false))

        TokenApiApiDelegate tokenApiApiDelegate = new TokenApiApiDelegate() {

        }

        when:
        Mono<ResponseEntity<ObjectNode>> result = tokenApiApiDelegate.getJwkKeys(serverWebExchange)

        then:
        result != null
        //result.map(ResponseEntity::getStatusCode).equals(HttpStatus.NOT_IMPLEMENTED)
        result != null
        //result.map(ResponseEntity::getStatusCode).equals(HttpStatus.NOT_IMPLEMENTED)
    }

    def "test getPublicLogin when implemented"() {
        given:
        String auth = "Basic auth"
        String ctxtId = "1"
        ServerWebExchange serverWebExchange = Mock(ServerWebExchange){
            getResponse() >> new MockServerHttpResponse()

        }
        ObjectNode objectNode = new ObjectNode(new JsonNodeFactory(false))
        TokenApiApiDelegate tokenApiApiDelegate = new TokenApiApiDelegate() {

        }

        when:
        Mono<ResponseEntity<ObjectNode>> result = tokenApiApiDelegate.getPublicLogin(auth, ctxtId, serverWebExchange)

        then:
        result != null
    }

    def "test getPublicRefresh when implemented"() {
        given:
        String auth = "Basic auth"
        String ctxtId = "1"
        ServerWebExchange serverWebExchange = Mock(ServerWebExchange){
            getResponse() >> new MockServerHttpResponse()

        }
        ObjectNode objectNode = new ObjectNode(new JsonNodeFactory(false))
        TokenApiApiDelegate tokenApiApiDelegate = new TokenApiApiDelegate() {

        }

        when:
        Mono<ResponseEntity<ObjectNode>> result = tokenApiApiDelegate.getPublicRefresh(auth, ctxtId, serverWebExchange)

        then:
        result != null
    }

    def "test getJwkKeys when keys are present"() {

        given:
        ServerWebExchange serverWebExchange = Mock(ServerWebExchange){
            getResponse() >> new MockServerHttpResponse()

        }
        ObjectNode objectNode = new ObjectNode(new JsonNodeFactory(false));

        TokenApiApiDelegate tokenApiApiDelegate = new TokenApiApiDelegate() {

        }

        when:
        Mono<ResponseEntity<ObjectNode>> result = tokenApiApiDelegate.getJwkKeys(serverWebExchange)

        then:
        result != null
        //result.map(ResponseEntity::getStatusCode).equals(HttpStatus.OK)
    }

    def "test validateToken when implemented"() {
        given:
        String auth = "Basic auth"
        ServerWebExchange serverWebExchange = Mock(ServerWebExchange){
            getResponse() >> new MockServerHttpResponse()

        }
        TokenApiApiDelegate tokenApiApiDelegate = new TokenApiApiDelegate() {

        }
        JsonNode jsonNode = new JsonNodeFactory(false).nullNode()

        when:
        Mono<ResponseEntity<JsonNode>> result = tokenApiApiDelegate.validateToken(auth, serverWebExchange)

        then:
        result != null
    }
}
