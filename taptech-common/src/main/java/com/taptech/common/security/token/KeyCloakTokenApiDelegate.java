package com.taptech.common.security.token;

import com.taptech.common.security.keycloak.KeyCloakAuthenticationManager;
import com.taptech.common.security.user.UserContextPermissions;
import com.taptech.common.security.utils.SecurityUtils;
import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationCredentialsNotFoundException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;
import reactor.util.function.Tuple2;

import java.util.Optional;

@Builder
@NoArgsConstructor
@AllArgsConstructor
public class KeyCloakTokenApiDelegate implements TokenApiApiDelegate {
    private static final Logger logger = LoggerFactory.getLogger(KeyCloakTokenApiDelegate.class);

    KeyCloakAuthenticationManager keyCloakAuthenticationManager;
    @Builder.Default
    ObjectMapper objectMapperAll = new ObjectMapper();
    @Builder.Default
    ObjectMapper objectMapper = createDelegateObjectMapper();

    private static ObjectMapper createDelegateObjectMapper() {
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        objectMapper.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        objectMapper.enableDefaultTyping(ObjectMapper.DefaultTyping.NON_FINAL);
        return objectMapper;
    }

    @Override
    public Mono<ResponseEntity<ObjectNode>> getPublicLogin(String authorization, String contextId, ServerWebExchange exchange) {

        Tuple2<String,String> userPass = SecurityUtils.fromBasicAuthToTuple(authorization);
//        return keyCloakAuthenticationManager.passwordGrantLoginMap(userPass.getT1(), userPass.getT2())
//                .map(map -> ServiceUtils.convertToJsonNode().apply(map, objectMapper))
//                .cast(ObjectNode.class)
//                .map(objectNode -> ResponseEntity.ok(objectNode));

        String ctxId = StringUtils.isBlank(contextId) ? keyCloakAuthenticationManager.getDefaultContext() : contextId;
        logger.info("Context id {}",ctxId);
        return keyCloakAuthenticationManager.passwordGrantLoginMap(userPass.getT1(), userPass.getT2(), ctxId)
                .map(map -> SecurityUtils.convertToJsonNode().apply(map, objectMapperAll))
                .cast(ObjectNode.class)
                .map(objectNode -> ResponseEntity.ok(objectNode));

    }

    @Override
    public Mono<ResponseEntity<ObjectNode>> getPublicRefresh(String authorization, String contextId, ServerWebExchange exchange) {

        String ctxId = StringUtils.isBlank(contextId) ? keyCloakAuthenticationManager.getDefaultContext() : contextId;
        logger.info("Context id {}",ctxId);
        return keyCloakAuthenticationManager.refreshTokenGrantLoginMap(authorization, ctxId)
                .map(map -> SecurityUtils.convertToJsonNode().apply(map, objectMapperAll))
                .cast(ObjectNode.class)
                .map(objectNode -> ResponseEntity.ok(objectNode));
    }

    @Override
    public Mono<ResponseEntity<UserContextPermissions>> validateToken(String authorization, ServerWebExchange exchange) {
        String extractedToken = SecurityUtils.fromBearerHeaderToToken(authorization);
        return keyCloakAuthenticationManager.validLoginJwt(extractedToken)
                .filter(Optional::isPresent)
                .switchIfEmpty(Mono.defer(() -> Mono.error(new AuthenticationCredentialsNotFoundException("Invalid Credentials"))))
                .flatMap(jwt -> keyCloakAuthenticationManager.getUserContextPermissionsFromJwt(jwt.get()))
                .doOnNext(userContextPermissions -> logger.info("userContextPermissions {}",userContextPermissions))
                .map(objectNode -> ResponseEntity.ok(objectNode));
    }


    @Override
    public Mono<ResponseEntity<ObjectNode>> getJwkKeys(ServerWebExchange exchange) {
        return keyCloakAuthenticationManager.getPublicKeyFromContextId(keyCloakAuthenticationManager.getDefaultContext())
                .map(map -> SecurityUtils.convertToJsonNode().apply(map, objectMapperAll))
                .cast(ObjectNode.class)
                .map(objectNode -> ResponseEntity.ok(objectNode));
    }
}
