package com.taptech.common.security.user;

import jakarta.annotation.PostConstruct;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

import static com.taptech.common.Constants.COLON;


/*
 * create a service that will return the permissions for a user in a given context
 * */
public class InMemoryUserContextPermissionsService implements UserContextPermissionsService {
    private static Logger logger = LogManager.getLogger(InMemoryUserContextPermissionsService.class);

    Map<String, UserContextPermissions> inMemoryUserContextPermissions = new HashMap<>();

    public UserContextPermissions addPermissions(String userId, String contextId, String roleId, Set<String> permissions) {

        String generateUserId = generateUserId(userId, contextId);

        return inMemoryUserContextPermissions.put(generateUserId, UserContextPermissions.builder()
                .contextId(contextId)
                .userId(userId)
                .roleId(roleId)
                .permissions(permissions)
                .enabled(Boolean.TRUE)
                .build());
    }

    @Override
    public Mono<UserContextPermissions> getUserContextByUserIdAndContextId(UserContextRequest userContextRequest) {
        return Mono.just(userContextRequest)
                .doOnNext(uc -> logger.info("getUserContextByUserIdAndContextId => {}", uc))
                .publishOn(Schedulers.boundedElastic())
                .map(this::generateUserId)
                .doOnNext(userId -> logger.info("Generated userId: {} ", userId))
                .map(userId -> Optional.of(inMemoryUserContextPermissions.get(userId)).orElseThrow(() -> new RuntimeException("User context not found")));
    }

    public String generateUserId(UserContextRequest userContextRequest) {
        return new StringBuilder(userContextRequest.getUserId())
                .append(COLON)
                .append(userContextRequest.getContextId()).toString();
    }


    public String generateUserId(String userId, String contextId) {
        return new StringBuilder(userId)
                .append(COLON)
                .append(contextId).toString();
    }

    @PostConstruct
    public void init(){
       logger.info("##################### InMemoryUserContextPermissionsService init ###################");
    }
}
