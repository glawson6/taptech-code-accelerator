package com.taptech.common.security.authentication;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.core.OAuth2TokenValidator;
import org.springframework.security.oauth2.jose.jws.JwsAlgorithm;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jose.jws.SignatureAlgorithm;
import org.springframework.security.oauth2.jwt.*;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Builder
@Getter
@NoArgsConstructor
public class AuthenticationJwtDecoderFactory implements JwtDecoderFactory<ClientRegistration> {

    private static final Logger logger = LoggerFactory.getLogger(AuthenticationJwtDecoderFactory.class);

    private final Map<String, JwtDecoder> jwtDecoders = new ConcurrentHashMap<>();

    @Override
    public JwtDecoder createDecoder(ClientRegistration clientRegistration) {
        return this.jwtDecoders.computeIfAbsent(clientRegistration.getRegistrationId(), (key) -> {
            String jwkSetUri = clientRegistration.getProviderDetails().getJwkSetUri();
            NimbusJwtDecoder nimbusJwtDecoder = NimbusJwtDecoder.withJwkSetUri(jwkSetUri).build();
            nimbusJwtDecoder.setJwtValidator(JwtValidators.createDefault());
            return nimbusJwtDecoder;
        });
    }

}
