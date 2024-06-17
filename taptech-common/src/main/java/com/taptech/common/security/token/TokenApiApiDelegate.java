package com.taptech.common.security.token;

import com.taptech.common.security.user.UserContextPermissions;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import javax.annotation.Generated;
import java.util.Optional;

/**
 * A delegate to be called by the {@link TokenApiController}}.
 * Implement this interface with a {@link org.springframework.stereotype.Service} annotated class.
 */
@Generated(value = "org.openapitools.codegen.languages.SpringCodegen", date = "2024-05-01T23:04:01.687503-04:00[America/New_York]")
public interface TokenApiApiDelegate {

    default Optional<NativeWebRequest> getRequest() {
        return Optional.empty();
    }

    /**
     * GET /public/jwkKeys : public keys endpoint
     * get public keyset
     *
     * @return OK (status code 200)
     *         or Not Found (status code 404)
     * @see TokenApi#getJwkKeys
     */
    default Mono<ResponseEntity<ObjectNode>> getJwkKeys(ServerWebExchange exchange) {
        Mono<Void> result = Mono.empty();
        exchange.getResponse().setStatusCode(HttpStatus.NOT_IMPLEMENTED);
        return result.then(Mono.empty());

    }

    /**
     * GET /public/login : get token with username/password
     * Open endpoint
     *
     * @param authorization authorization (required)
     * @param contextId contextId (optional)
     * @return OK (status code 200)
     *         or Bad Request (status code 400)
     *         or Unauthorized (status code 401)
     *         or Forbidden (status code 403)
     *         or Not Found (status code 404)
     * @see TokenApi#getPublicLogin
     */
    default Mono<ResponseEntity<ObjectNode>> getPublicLogin(String authorization,
        String contextId,
        ServerWebExchange exchange) {
        Mono<Void> result = Mono.empty();
        exchange.getResponse().setStatusCode(HttpStatus.NOT_IMPLEMENTED);
        return result.then(Mono.empty());

    }


    /**
     * GET /public/logout : logout
     *
     * @param authorization authorization (required)
     * @param contextId contextId (optional)
     * @return OK (status code 200)
     *         or Bad Request (status code 400)
     *         or Unauthorized (status code 401)
     *         or Forbidden (status code 403)
     *         or Not Found (status code 404)
     * @see TokenApi#publicLogout
     */
    default Mono<ResponseEntity<ObjectNode>> publicLogout(String authorization,
                                                            ServerWebExchange exchange) {
        Mono<Void> result = Mono.empty();
        exchange.getResponse().setStatusCode(HttpStatus.NOT_IMPLEMENTED);
        return result.then(Mono.empty());

    }

    /**
     * GET /public/refresh : get token with username/password
     * Open endpoint
     *
     * @param authorization authorization (required)
     * @param contextId contextId (optional)
     * @return OK (status code 200)
     *         or Bad Request (status code 400)
     *         or Unauthorized (status code 401)
     *         or Forbidden (status code 403)
     *         or Not Found (status code 404)
     * @see PublicApi#getPublicRefresh
     */
    default Mono<ResponseEntity<ObjectNode>> getPublicRefresh(String authorization,
                                                              String contextId,
                                                              ServerWebExchange exchange) {
        Mono<Void> result = Mono.empty();
        exchange.getResponse().setStatusCode(HttpStatus.NOT_IMPLEMENTED);
        return result.then(Mono.empty());

    }

    /**
     * GET /public/validate : validate a token and send back its claims
     * validate a token
     *
     * @param authorization authorization (required)
     * @return OK (status code 200)
     *         or Bad Request (status code 400)
     *         or Unauthorized (status code 401)
     *         or Forbidden (status code 403)
     *         or Not Found (status code 404)
     * @see TokenApi#validateToken
     *
     */
    default Mono<ResponseEntity<UserContextPermissions>> validateToken(String authorization,
                                                                       ServerWebExchange exchange) {
        Mono<Void> result = Mono.empty();
        exchange.getResponse().setStatusCode(HttpStatus.NOT_IMPLEMENTED);
        return result.then(Mono.empty());

    }

}
