package com.taptech.common.security.keycloak;

import com.taptech.common.security.token.TokenContextService;
import com.taptech.common.security.user.UserContextPermissions;
import com.taptech.common.security.user.UserContextPermissionsService;
import com.taptech.common.security.user.UserContextRequest;
import lombok.*;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.resource.ClientResource;
import org.keycloak.representations.idm.ClientRepresentation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtDecoderFactory;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.util.Map;
import java.util.Optional;

import static com.taptech.common.Constants.CONTEXT_ID;
import static com.taptech.common.security.keycloak.KeyCloakUtils.*;
import static com.taptech.common.security.utils.SecurityUtils.fromBearerHeaderToToken;

@Builder
@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class KeyCloakTokenContextService implements TokenContextService {

    private static final Logger logger = LoggerFactory.getLogger(KeyCloakTokenContextService.class);

    Keycloak keycloak;
    WebClient webClient;
    String realmClientId;
    String realmClientSecret;
    String realmBaseUrl;
    String defaultContext;
    UserContextPermissionsService userContextPermissionsService;
    JwtDecoderFactory<ClientRegistration> jwtDecoderFactory;

    @Override

    public Mono<Map<String, Object>> passwordGrantLoginMap(String username, String password, String contextId) {

        logger.info("passwordGrantLoginMap(String username=[{}], String password, String contextId=[{}]) ", username,contextId);
        logger.info("using realmClientId => {}", realmClientId);
        logger.info("using realmClientSecret => {}, password => {}", realmClientSecret, password);

        String clientId = contextId;

        ClientRepresentation clientRepresentation = keycloak.realm(contextId).clients().findAll().stream()
                .peek(cr -> logger.info("clientRepresentation => {}", cr.getClientId()))
                .filter(cr -> cr.getClientId().equals(contextId))
                .findAny().orElseThrow(() -> new KeyCloakClientNotFoundException(new StringBuilder(contextId).append(" not found").toString()));

        String clientSecret = determineClientSecret(contextId, clientRepresentation);
        logger.info("clientRepresentation.getClientId() => {}, clientSecret => {}", clientId, clientSecret);
        return webClient.post()
                //.uri(realmTokenUri)
                .uri(uriBuilder -> uriBuilder.path(TOKEN_CLIENT_URI)
                        .build(Map.of("realm", contextId)))
                .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_FORM_URLENCODED_VALUE)
                .header(HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE)
                .body(BodyInserters.fromFormData("grant_type", "password")
                        .with("username", username)
                        .with("password", password)
                        .with("client_id", clientId)
                        .with("client_secret", clientSecret)
                        .with("scope", "openid"))
                .httpRequest(request -> logger.info("passwordGrantLoginMap.request.getURI().toString() => {}", request.getURI().toString()))
                .exchangeToMono(response -> {
                    logger.info("passwordGrantLoginMap.response.statusCode() => {}", response.statusCode());
                    if (response.statusCode().is2xxSuccessful()) {
                        return response.bodyToMono(MAP_OBJECT);
                    } else {
                        logger.error("Error in adminCliAccessCreds => {} {}",response.statusCode());
                        return response.createException().flatMap(Mono::error);
                    }
                });
    }

    @Override
    public Mono<Map<String, Object>> refreshTokenGrantLoginMap(String authorizationHeader, String contextId) {

        String refreshToken = fromBearerHeaderToToken(authorizationHeader);
        logger.info("refreshTokenGrantLoginMap(String token=[{}], String contextId=[{}]) ", refreshToken,contextId);
        logger.info("refreshTokenGrantLoginMap using realmClientId => {}", realmClientId);
        ClientRepresentation clientRepresentation = keycloak.realm(contextId).clients().findAll().stream()
                .peek(cr -> logger.info("clientRepresentation => {}", cr.getClientId()))
                .filter(cr -> cr.getClientId().equals(contextId))
                .findAny().orElseThrow(() -> new KeyCloakClientNotFoundException(new StringBuilder(contextId).append(" not found").toString()));
        String clientSecret = keycloak.realm(contextId).clients().get(clientRepresentation.getId()).getSecret().getValue();

        logger.info("clientRepresentation.getClientId() => {}, clientSecret => {}", clientRepresentation.getClientId(), clientSecret);
        return webClient.post()
                .uri(uriBuilder -> uriBuilder.path(TOKEN_CLIENT_URI)
                        .build(Map.of("realm", contextId)))
                .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_FORM_URLENCODED_VALUE)
                .header(HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE)
                .body(BodyInserters.fromFormData("grant_type", "refresh_token")
                        .with("refresh_token", refreshToken)
                        .with("client_id", clientRepresentation.getClientId())
                        .with("client_secret", clientSecret))
                //.with("scope", "openid"))
                .httpRequest(request -> logger.info("refreshTokenGrantLoginMap.request.getURI().toString() => {}", request.getURI().toString()))

                .exchangeToMono(response -> {
                    logger.info("refreshTokenGrantLoginMap.response.statusCode() => {}", response.statusCode());
                    if (response.statusCode().is2xxSuccessful()) {
                        return response.bodyToMono(MAP_OBJECT);
                    } else {
                        logger.error("Error in refreshTokenGrantLoginMap => {} {}",response.statusCode());
                        return response.createException().flatMap(Mono::error);
                    }
                });
    }

    @Override
    public Mono<UserContextPermissions> getUserContextPermissionsFromJwt(Jwt jwt) {
        String contextId = determineContext(jwt);
        String userid = jwt.getClaim("email");
        final UserContextRequest userContextRequest = UserContextRequest.builder()
                .contextId(contextId)
                .userId(userid)
                .token(jwt.getTokenValue())
                .build();
        return userContextPermissionsService.getUserContextByUserIdAndContextId(userContextRequest);
    }

    @Override
    public Mono<Optional<Jwt>> validLoginJwt(String token) {

        JwtDecoder jwtDecoder = createJwtDecoderFromContextId(jwtDecoderFactory,defaultContext, realmBaseUrl);
        return validLoginJwt(jwtDecoder, token);

    }

    @Override
    public Mono<Map<String, Object>> getPublicKeyFromContextId(String contextId) {

        return webClient.get()
                .uri(uriBuilder -> uriBuilder.path(CERT_CLIENT_URI).build(Map.of("realm", contextId)))
                .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
                .header(HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE)

                .httpRequest(request -> logger.info("getPublicKeyFromContextId.request.getURI().toString() => {}", request.getURI().toString()))
                .exchangeToMono(response -> {
                    logger.debug("response.statusCode() => {}", response.statusCode());
                    if (response.statusCode().equals(HttpStatus.OK)) {
                        return response.bodyToMono(MAP_OBJECT);
                    } else {
                        // Turn to error
                        return response.createError();
                    }
                });
    }


    public Mono<Optional<Jwt>> validLoginJwt(final JwtDecoder jwtDecoder,String token) {

        return Mono.just(token)
                .map(tk -> jwtDecoder.decode(tk))
                .map(jwt -> Optional.of(jwt));

    }

    private String determineClientSecret(String contextId, ClientRepresentation clientRepresentation) {
        ClientResource clientResource = keycloak.realm(contextId).clients().get(clientRepresentation.getId());
        String clientSecret = clientResource.getSecret().getValue();
        return clientSecret != null ? clientSecret : realmClientSecret;
    }

    String determineContext(Jwt jwt) {
        return jwt.getClaimAsString(CONTEXT_ID) != null ? jwt.getClaimAsString(CONTEXT_ID) : defaultContext;
    }
}
