package com.taptech.common.security.client;

import reactor.core.publisher.Mono;

import java.util.Map;

public interface ClientIdProviders {
    Mono<Map<String, Object>> getClientIdProviders(String contextId);
}
