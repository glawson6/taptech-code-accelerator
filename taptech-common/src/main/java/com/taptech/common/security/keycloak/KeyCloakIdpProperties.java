package com.taptech.common.security.keycloak;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import lombok.*;
import org.springframework.boot.context.properties.ConfigurationProperties;


@ConfigurationProperties(prefix = "idp.provider.keycloak")
public record KeyCloakIdpProperties(String clientId, String clientSecret, String baseUrl, String tokenUri,
                                    String userUri, String realm, String adminTokenUri, String adminUsername,
                                    String adminPassword, String adminClientId, String adminClientSecret,
                                    String jwksetUri, String issuerUrl, String adminRealmUri,
                                    Integer accessCodeLifespan, String defaultContextId, Boolean useStrictJwtValidators,
                                    Boolean initializeOnStartup, Boolean initializeUsersOnStartup,
                                    Boolean initializeRealmsOnStartup) {


}
