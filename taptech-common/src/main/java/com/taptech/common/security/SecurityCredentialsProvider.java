package com.taptech.common.security;

import reactor.core.publisher.Mono;

import java.util.Map;

public interface SecurityCredentialsProvider {
    public Mono<Map<String, Object>> retrieveAccessCredentials();
}
