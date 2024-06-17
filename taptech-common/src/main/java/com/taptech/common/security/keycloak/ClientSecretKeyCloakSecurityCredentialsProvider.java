package com.taptech.common.security.keycloak;

import com.taptech.common.security.SecurityCredentialsProvider;
import jakarta.annotation.PostConstruct;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.util.Map;

import static com.taptech.common.security.keycloak.KeyCloakUtils.MAP_OBJECT;
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ClientSecretKeyCloakSecurityCredentialsProvider implements SecurityCredentialsProvider {

    static final Logger logger = LoggerFactory.getLogger(ClientSecretKeyCloakSecurityCredentialsProvider.class);

    KeyCloakIdpProperties keyCloakIdpProperties;
    WebClient webClient;

    @PostConstruct
    public void init() {
        webClient = WebClient.builder()
                .baseUrl(keyCloakIdpProperties.baseUrl())
                .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_FORM_URLENCODED_VALUE)
                .build();
        logger.info("KeyCloakSecurityCredentialsProvider initialized");
    }

    @Override
    public Mono<Map<String, Object>> retrieveAccessCredentials() {
        logger.info("adminCliAccessCreds.keyCloakIdpProperties.baseUrl() + keyCloakIdpProperties.adminTokenUri() => {}",keyCloakIdpProperties.baseUrl() + keyCloakIdpProperties.adminTokenUri());
        logger.info("adminCliAccessCreds.keyCloakIdpProperties.adminClientId() => {}",keyCloakIdpProperties.adminClientId());
        logger.info("adminCliAccessCreds.keyCloakIdpProperties.adminClientSecret() => {}",keyCloakIdpProperties.adminClientSecret());

        return webClient.post()

                .uri(keyCloakIdpProperties.adminTokenUri())
                .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_FORM_URLENCODED_VALUE)
                .body(BodyInserters.fromFormData("grant_type", "client_credentials")
                        .with("client_id", keyCloakIdpProperties.adminClientId())
                        .with("client_secret", keyCloakIdpProperties.adminClientSecret()))

                .exchangeToMono(response -> {
                    if (response.statusCode().is2xxSuccessful()) {
                        return response.bodyToMono(MAP_OBJECT);
                    } else {
                        logger.error("Error in adminCliAccessCreds => {} {}",response.statusCode());
                        return response.createException().flatMap(Mono::error);
                    }
                });
    }
}
