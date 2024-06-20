package com.taptech.common.security.token;

import com.taptech.common.security.user.UserContextPermissions;
import org.springframework.security.oauth2.jwt.Jwt;
import reactor.core.publisher.Mono;

import java.util.Map;
import java.util.Optional;

public interface TokenContextService {
    Mono<Map<String, Object>>  passwordGrantLoginMap(String username, String password, String contextId);
    Mono<Map<String, Object>> refreshTokenGrantLoginMap(String authorizationHeader, String contextId);
    Mono<UserContextPermissions> getUserContextPermissionsFromJwt(Jwt jwt);
    Mono<Optional<Jwt>> validLoginJwt(String token);
    String getDefaultContext();
    void setDefaultContext(String context);
    Mono<Map<String, Object>> getPublicKeyFromContextId(String contextId);

}
