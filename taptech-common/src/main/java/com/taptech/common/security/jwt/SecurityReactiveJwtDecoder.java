package com.taptech.common.security.jwt;

import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtException;
import org.springframework.security.oauth2.jwt.ReactiveJwtDecoder;
import reactor.core.publisher.Mono;

public class SecurityReactiveJwtDecoder implements ReactiveJwtDecoder{

    JwtDecoder jwtDecoder;

    public SecurityReactiveJwtDecoder(JwtDecoder jwtDecoder) {
        this.jwtDecoder = jwtDecoder;
    }

    @Override
    public Mono<Jwt> decode(String token) throws JwtException {
        return Mono.just(jwtDecoder.decode(token));
    }
}
