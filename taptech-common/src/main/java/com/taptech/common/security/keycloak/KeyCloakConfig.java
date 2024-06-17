package com.taptech.common.security.keycloak;

import com.taptech.common.security.user.UserContextPermissionsService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.KeycloakBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.BeanCreationException;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import org.springframework.core.env.Environment;
import org.springframework.util.Assert;

import static com.taptech.common.security.keycloak.KeyCloakConstants.*;


@Configuration
@EnableConfigurationProperties(value = {KeyCloakIdpProperties.class})
public class KeyCloakConfig {

    private static final Logger logger = LoggerFactory.getLogger(KeyCloakConfig.class);

    @Bean
    KeyCloakJwtDecoderFactory keyCloakJwtDecoderFactory(KeyCloakIdpProperties keyCloakIdpProperties){
        return KeyCloakJwtDecoderFactory.builder()
                .keyCloakIdpProperties(keyCloakIdpProperties)
                .build();
    }

    @Bean("keyCloakObjectMapper")
    ObjectMapper keyCloakObjectMapper(){
        return new ObjectMapper();
    }


    @Bean
    Keycloak keycloak(KeyCloakIdpProperties keyCloakIdpProperties){


        Assert.notNull(keyCloakIdpProperties.baseUrl(), "Keycloak idp.provider.keycloak.base-url cannot be null");
        Assert.notNull(keyCloakIdpProperties.adminClientSecret(), "Keycloak idp.provider.keycloak.admin-client-secret cannot be null");
        Assert.notNull(keyCloakIdpProperties.adminUsername(), "Keycloak idp.provider.keycloak.admin-username cannot be null");
        Assert.notNull(keyCloakIdpProperties.adminPassword(), "Keycloak idp.provider.keycloak.admin-password cannot be null");

        logger.info("Keycloak base url: {} keyCloakIdpProperties.adminClientSecret() {}", keyCloakIdpProperties.baseUrl(),
                keyCloakIdpProperties.adminClientSecret());

        Keycloak keycloak = null;
        try{
            keycloak = KeycloakBuilder.builder()
                    .serverUrl(keyCloakIdpProperties.baseUrl())
                    .realm(MASTER)
                    .clientId(ADMIN_CLI)
                    .username(keyCloakIdpProperties.adminUsername())
                    .password(keyCloakIdpProperties.adminPassword())
                    .clientSecret(keyCloakIdpProperties.adminClientSecret())
                    .build();
        } catch (Exception e){
            String message = "Error creating keycloak client: {}. Make sure KEYCLOAK_ADMIN_CLIENT_ID=admin-cli and KEYCLOAK_ADMIN_CLIENT_SECRET are set properly";
            logger.error(message, e.getMessage());
            throw new BeanCreationException(message, e);
        }

        String clientSecret = keycloak.realm(MASTER).clients().findByClientId(ADMIN_CLI).get(0).getSecret();
        logger.trace("Keycloak client secret: {}", clientSecret);
        return keycloak;

    }

    @Bean
    KeyCloakService keyCloakService(KeyCloakIdpProperties keyCloakIdpProperties,
                                    @Qualifier("keyCloakObjectMapper") ObjectMapper objectMapper,
                                    Keycloak keycloak){
        return KeyCloakService.builder()
                .objectMapper(objectMapper)
                .keyCloakIdpProperties(keyCloakIdpProperties)
                .keycloak(keycloak)
                .build();
    }

    @Bean("idProviderAuthenticationManager")
    @ConditionalOnMissingBean
    KeyCloakAuthenticationManager keyCloakAuthenticationManager(UserContextPermissionsService userContextPermissionsService,
                                                                Keycloak keycloak,
                                                                KeyCloakJwtDecoderFactory keyCloakJwtDecoderFactory,
                                                                KeyCloakIdpProperties keyCloakIdpProperties){

        Assert.notNull(keyCloakIdpProperties.defaultContextId(), "Keycloak idp.provider.keycloak.default-context-id cannot be null");
        Assert.notNull(keyCloakIdpProperties.clientId(), "Keycloak idp.provider.keycloak.client-id cannot be null");
        Assert.notNull(keyCloakIdpProperties.clientSecret(), "Keycloak idp.provider.keycloak.client-secret cannot be null");
        Assert.notNull(keyCloakIdpProperties.tokenUri(), "Keycloak idp.provider.keycloak.token-uri cannot be null");
        Assert.notNull(keyCloakIdpProperties.baseUrl(), "Keycloak idp.provider.keycloak.base-url cannot be null");
        Assert.notNull(keyCloakIdpProperties.jwksetUri(), "Keycloak idp.provider.keycloak.jwkset-uri cannot be null");
        Assert.notNull(keyCloakIdpProperties.issuerUrl(), "Keycloak idp.provider.keycloak.issuer-url cannot be null");


        return KeyCloakAuthenticationManager.builder()
                .defaultContext(keyCloakIdpProperties.defaultContextId())
                .userContextPermissionsService(userContextPermissionsService)
                .realmClientId(keyCloakIdpProperties.clientId())
                .realmClientSecret(keyCloakIdpProperties.clientSecret())
                .realmTokenUri(keyCloakIdpProperties.tokenUri())
                .realmBaseUrl(keyCloakIdpProperties.baseUrl())
                .realmJwkSetUri(keyCloakIdpProperties.jwksetUri())
                .issuerURL(keyCloakIdpProperties.issuerUrl())
                .keycloak(keycloak)
                .jwtDecoderFactory(keyCloakJwtDecoderFactory)
                .build();
    }

    @Bean
    @ConditionalOnProperty(prefix = "idp.provider.keycloak", name = "initialize-on-startup", havingValue = "true", matchIfMissing = false)
    KeyCloakInitializer keyCloakInitializer(KeyCloakService keyCloakService, Keycloak keycloak,
                                            KeyCloakIdpProperties keyCloakIdpProperties,
                                            UserContextPermissionsService userContextPermissionsService,
                                           @Qualifier("keyCloakObjectMapper") ObjectMapper objectMapper){
        return KeyCloakInitializer.builder()
                .keycloak(keycloak)
                .keyCloakIdpProperties(keyCloakIdpProperties)
               // .objectMapper(objectMapper)
                .keyCloakService(keyCloakService)
                .initializeOnStartup(keyCloakIdpProperties.initializeOnStartup())
                .initializeRealmsOnStartup(keyCloakIdpProperties.initializeRealmsOnStartup())
                .initializeUsersOnStartup(keyCloakIdpProperties.initializeUsersOnStartup())
                .userContextPermissionsService(userContextPermissionsService)
                .build();
    }

}
