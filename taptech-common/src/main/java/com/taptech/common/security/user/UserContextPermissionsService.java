package com.taptech.common.security.user;

import reactor.core.publisher.Mono;

import java.util.Set;

public interface UserContextPermissionsService {
    Mono<UserContextPermissions> getUserContextByUserIdAndContextId(UserContextRequest userContextRequest);

    default UserContextPermissions addPermissions(String userId, String contextId, Set<String> permissions) {
        return addPermissions(userId, contextId, null, permissions);
    }


    default UserContextPermissions addPermissions(String userId, String contextId, String roleId, Set<String> permissions) {
        return UserContextPermissions.builder()
                .userId(userId)
                .contextId(contextId)
                .permissions(permissions)
                .build();
    }

}
