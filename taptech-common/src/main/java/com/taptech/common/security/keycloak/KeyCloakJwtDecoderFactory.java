package com.taptech.common.security.keycloak;

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

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;

@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class KeyCloakJwtDecoderFactory implements JwtDecoderFactory<ClientRegistration> {

    private static final Logger logger = LoggerFactory.getLogger(KeyCloakJwtDecoderFactory.class);

    private static final Map<JwsAlgorithm, String> JCA_ALGORITHM_MAPPINGS;
    static {
        Map<JwsAlgorithm, String> mappings = new HashMap<>();
        mappings.put(MacAlgorithm.HS256, "HmacSHA256");
        mappings.put(MacAlgorithm.HS384, "HmacSHA384");
        mappings.put(MacAlgorithm.HS512, "HmacSHA512");
        JCA_ALGORITHM_MAPPINGS = Collections.unmodifiableMap(mappings);
    };

    private Function<ClientRegistration, JwsAlgorithm> jwsAlgorithmResolver = (
            clientRegistration) -> SignatureAlgorithm.RS256;
    private final Map<String, JwtDecoder> jwtDecoders = new ConcurrentHashMap<>();

    private KeyCloakIdpProperties keyCloakIdpProperties;

    @Override
    public JwtDecoder createDecoder(ClientRegistration clientRegistration) {
        return this.jwtDecoders.computeIfAbsent(clientRegistration.getRegistrationId(), (key) -> {
            String jwkSetUri = clientRegistration.getProviderDetails().getJwkSetUri();
            String issuerUri = clientRegistration.getProviderDetails().getIssuerUri();
            NimbusJwtDecoder nimbusJwtDecoder = NimbusJwtDecoder.withJwkSetUri(jwkSetUri).build();
            nimbusJwtDecoder.setJwtValidator(determineJwtValidators(keyCloakIdpProperties.useStrictJwtValidators(), issuerUri));
            //nimbusJwtDecoder.setJwtValidator(JwtValidators.createDefaultWithIssuer(issuerUri));
            return nimbusJwtDecoder;
        });
    }

    public OAuth2TokenValidator<Jwt> determineJwtValidators(Boolean strictJwtValidation, String issuerUri) {

        logger.info("KeyCloakJwtDecoderFactory.determineJwtValidators strictJwtValidation => {}",strictJwtValidation);
        return Optional.ofNullable(strictJwtValidation)
                .map(strict -> strict ? strictValidators(issuerUri) : permissiveValidators())
                .orElse(JwtValidators.createDefaultWithIssuer(issuerUri));
    }

    OAuth2TokenValidator<Jwt> permissiveValidators() {
        logger.info("KeyCloakJwtDecoderFactory.permissiveValidators");
        return JwtValidators.createDefault();
    }


    OAuth2TokenValidator<Jwt> strictValidators(String issuerUri) {
        return JwtValidators.createDefaultWithIssuer(issuerUri);
    }
}
