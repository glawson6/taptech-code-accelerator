package com.taptech.common.security.keycloak;

import com.taptech.common.security.client.ClientIdProviders;
import com.taptech.common.security.token.TokenContextService;
import com.taptech.common.security.user.UserContextPermissions;
import com.taptech.common.security.user.UserContextPermissionsService;
import com.taptech.common.security.user.UserContextRequest;
import com.taptech.common.security.utils.SecurityUtils;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.netty.channel.ChannelOption;
import io.netty.handler.timeout.ReadTimeoutHandler;
import io.netty.handler.timeout.WriteTimeoutHandler;
import lombok.*;
import org.apache.commons.lang3.StringUtils;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.resource.ClientResource;
import org.keycloak.admin.client.resource.RealmResource;
import org.keycloak.representations.idm.ClientRepresentation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.client.reactive.ClientHttpConnector;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.security.authentication.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.SpringSecurityMessageSource;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.core.AuthorizationGrantType;
import org.springframework.security.oauth2.jwt.*;
import org.springframework.security.oauth2.server.resource.authentication.BearerTokenAuthenticationToken;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.util.Assert;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.util.UriComponentsBuilder;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Scheduler;
import reactor.core.scheduler.Schedulers;
import reactor.netty.http.client.HttpClient;
import reactor.util.function.Tuple2;
import reactor.util.function.Tuple3;
import reactor.util.function.Tuples;

import javax.annotation.PostConstruct;
import java.time.Duration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.TimeUnit;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.taptech.common.Constants.CONTEXT_ID;
import static com.taptech.common.security.keycloak.KeyCloakUtils.*;
import static com.taptech.common.security.utils.SecurityUtils.fromBearerHeaderToToken;


@Builder
@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class KeyCloakAuthenticationManager extends AbstractUserDetailsReactiveAuthenticationManager implements ClientIdProviders,
        TokenContextService {

    /*
    AbstractUserDetailsReactiveAuthenticationManager
     */
    private static final Logger logger = LoggerFactory.getLogger(KeyCloakAuthenticationManager.class);


    private String defaultContext;
    private UserContextPermissionsService userContextPermissionsService;
    @Builder.Default
    private Scheduler scheduler = Schedulers.boundedElastic();
    String realmBaseUrl;
    String realmTokenUri;
    String realmJwkSetUri;
    String issuerURL;
    String realmClientId;
    String realmClientSecret;
    Keycloak keycloak;

    WebClient webClient;
    @Builder.Default
    ObjectMapper objectMapper = new ObjectMapper();
    JwtDecoder jwtDecoder;
    JwtDecoderFactory<ClientRegistration> jwtDecoderFactory;

    @PostConstruct
    public void init() {

        /**
         * https://auth0.com/docs/get-started/authentication-and-authorization-flow/authenticate-with-private-key-jwt
         */

        Assert.notNull(realmBaseUrl, "realmBaseUrl must not be null");
        Assert.notNull(realmTokenUri, "realmTokenUri must not be null");
        Assert.notNull(realmJwkSetUri, "realmJwkSetUri must not be null");
        Assert.notNull(issuerURL, "issuerURL must not be null");
        Assert.notNull(realmClientId, "realmClientId must not be null");
        Assert.notNull(realmClientSecret, "realmClientSecret must not be null");
        Assert.notNull(userContextPermissionsService, "userContextPermissionsService must not be null");
        Assert.notNull(defaultContext, "defaultContext must not be null");
        Assert.notNull(keycloak, "keycloak must not be null");

        logger.info("##################### KeyCloakAuthenticationManager init with realmBaseUrl {} ###################",realmBaseUrl);

        ClientHttpConnector clientHttpConnector =getConnector(Duration.ofSeconds(10));
        if (webClient == null) {
            webClient = WebClient.builder().baseUrl(realmBaseUrl).defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_FORM_URLENCODED_VALUE)
                    .clientConnector(clientHttpConnector)
                    .build();
        }

        if (jwtDecoder == null){
            NimbusJwtDecoder nimbusJwtDecoder = NimbusJwtDecoder.withJwkSetUri(realmJwkSetUri).build();
            nimbusJwtDecoder.setJwtValidator(JwtValidators.createDefaultWithIssuer(issuerURL));
            jwtDecoder = nimbusJwtDecoder;
        }

    }

    private static ClientHttpConnector getConnector(Duration timeout) {
        final var httpClient = HttpClient.create()
                .option(ChannelOption.CONNECT_TIMEOUT_MILLIS, (int) timeout.toMillis())
                .responseTimeout(timeout)
                .doOnConnected(conn ->
                        conn.addHandlerLast(new ReadTimeoutHandler(timeout.toMillis(), TimeUnit.MILLISECONDS))
                                .addHandlerLast(new WriteTimeoutHandler(timeout.toMillis(), TimeUnit.MILLISECONDS)));
        return new ReactorClientHttpConnector(httpClient);
    }


    @Override
    public Mono<UserDetails> retrieveUser(String username) {
       return retrieveUser(username, defaultContext);
    }

    public Mono<UserDetails> retrieveUser(String username, String contextId) {
        final UserContextRequest userContextRequest = UserContextRequest.builder().contextId(contextId).userId(username).build();

        return Mono.just(userContextRequest)
                .publishOn(this.scheduler)
                .flatMap(request -> userContextPermissionsService.getUserContextByUserIdAndContextId(request))
                .map(SecurityUtils.convertUserContextPermissionsToUserDetails());
    }

    public Mono<Tuple2<UserDetails, Optional<Jwt>>> retrieveUser(Authentication authentication) {
        String context = determineContext(authentication);
        logger.info("retrieveUser(Authentication authentication) authentication name => {} authentication.getName() => {}, context => {}",authentication.getClass().getName(),
                authentication.getName() ,context);
        if (authentication instanceof BearerTokenAuthenticationToken) {
            BearerTokenAuthenticationToken bearerToken = (BearerTokenAuthenticationToken) authentication;

            JwtDecoder decoder = createJwtDecoderFromContextId(jwtDecoderFactory,context, realmBaseUrl);
            Optional<Jwt> jwt = Optional.of(decoder.decode(bearerToken.getToken()));
            String username = jwt.get().getClaimAsString("email") != null ? jwt.get().getClaimAsString("email") : jwt.get().getClaimAsString("name");
            UserContextRequest userContextRequest = UserContextRequest.builder()
                    .contextId(context)
                    .userId(username)
                    .token(bearerToken.getToken())
                    .build();
            return Mono.just(userContextRequest)
                    .publishOn(this.scheduler)
                    .flatMap(request -> userContextPermissionsService.getUserContextByUserIdAndContextId(request))
                    .map( SecurityUtils.convertUserContextPermissionsToUserDetails(jwt))
                    .map(user -> Tuples.of(user, jwt));

        } else {
            return this.retrieveUser(authentication.getName(), context)
                    .map(user -> Tuples.of(user, Optional.empty()));
        }

    }

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

    String determineContext(Jwt jwt) {
        return jwt.getClaimAsString(CONTEXT_ID) != null ? jwt.getClaimAsString(CONTEXT_ID) : defaultContext;
    }

    String determineContext(Authentication authentication) {

        return authentication.getDetails() != null ? ((Map<String, String>) authentication.getDetails()).getOrDefault(CONTEXT_ID, defaultContext)
                : defaultContext;
    }

    public Mono<Optional<Jwt>> passwordGrantLoginJwt(String username, String password) {

        return passwordGrantLoginMap(username, password).map(convertResultMapToJwt(jwtDecoder));
    }


    public Mono<Optional<Jwt>> passwordGrantLoginJwt(String username, String password, String contextId) {


        JwtDecoder decoder = createJwtDecoderFromContextId(jwtDecoderFactory,contextId, realmBaseUrl);
        return passwordGrantLoginMap(username, password, contextId).map(convertResultMapToJwt(decoder));
    }


    public Mono<Map<String, Object>> passwordGrantLoginMap(String username, String password) {

        return this.passwordGrantLoginMap(username, password, defaultContext);

    }

    public Mono<Map<String, Object>> passwordGrantLoginMap(String username, String password, String contextId) {

        logger.info("passwordGrantLoginMap(String username=[{}], String password, String contextId=[{}]) ", username,contextId);
        logger.info("using realmTokenUri => {}, realmClientId => {}", realmTokenUri, realmClientId);
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

    private String determineClientSecret(String contextId, ClientRepresentation clientRepresentation) {
        ClientResource clientResource = keycloak.realm(contextId).clients().get(clientRepresentation.getId());
        String clientSecret = clientResource.getSecret().getValue();
    return clientSecret != null ? clientSecret : realmClientSecret;
    }

    public Mono<Map<String, Object>> refreshTokenGrantLoginMap(String authorizationHeader, String contextId) {

        String refreshToken = fromBearerHeaderToToken(authorizationHeader);
        logger.info("refreshTokenGrantLoginMap(String token=[{}], String contextId=[{}]) ", refreshToken,contextId);
        logger.info("refreshTokenGrantLoginMap using realmTokenUri => {}, realmClientId => {}", realmTokenUri, realmClientId);
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

    public Mono<Optional<Jwt>> validLoginJwt(String token) {


        JwtDecoder jwtDecoder = createJwtDecoderFromContextId(jwtDecoderFactory,defaultContext, realmBaseUrl);
       return validLoginJwt(jwtDecoder, token);

    }

    public Mono<Optional<Jwt>> validLoginJwt(final JwtDecoder jwtDecoder,String token) {

        return Mono.just(token)
                .map(tk -> jwtDecoder.decode(tk))
                .map(jwt -> Optional.of(jwt));

    }

    Function<Tuple3<Authentication, UserDetails,  Optional<Jwt>>, Mono<Tuple2<UserDetails, Optional<Jwt>>>> basicAuthOrJwtAccess() {
        return tuple -> {
            Authentication authentication = tuple.getT1();
            String context = determineContext(authentication);
            UserDetails userDetails = tuple.getT2();
            final String username = authentication.getName();
            logger.info("basicAuthOrJwtAccess Got username => {}", username);
            if (authentication instanceof BearerTokenAuthenticationToken) {
                JwtDecoder jwtDecoder = createJwtDecoderFromContextId(jwtDecoderFactory,context, realmBaseUrl);
                // We may have already extracted the jwt object from the token
                return tuple.getT3().isPresent() ? Mono.just( Tuples.of(tuple.getT2(), tuple.getT3()))
                : validLoginJwt(jwtDecoder, username).map(jwt -> Tuples.of(tuple.getT2(), jwt));
            } else {
                final String presentedPassword = (String) authentication.getCredentials();
                return passwordGrantLoginJwt(username, presentedPassword, context).map(jwt -> Tuples.of(tuple.getT2(), jwt));
            }
        };
    }

    // TODO refactor this method 06-12-2024

    @Override
    public Mono<Authentication> authenticate(final Authentication authentication) {

        return Mono.just(authentication)
                .doOnNext(authen -> logger.info("authenticate(Authentication authentication) authentication.getName() => {}", authen.getName()))
                // We may have already extracted the jwt object from the token returning it as a tuple of UserDetails and Optional<Jwt>
                .flatMap(authen -> retrieveUser(authen))
                .publishOn(this.scheduler)
                .doOnNext(userDetails -> defaultPreAuthenticationChecks(userDetails.getT1()))
                // mapping to a tuple of UserDetails and Optional<Jwt> to be used in the next step
                .map(userDetails -> Tuples.of(authentication, userDetails.getT1(), userDetails.getT2()))
                .doOnNext(tuple -> logger.trace("authenticate(Authentication authentication) authentication => [{}] ", tuple.getT1()))
                .flatMap(basicAuthOrJwtAccess())
                .filter((tuple) -> tuple.getT2().isPresent())
                .switchIfEmpty(Mono.defer(() -> Mono.error(new BadCredentialsException("Invalid Credentials"))))
                .doOnNext(tuple -> defaultPostAuthenticationChecks(tuple.getT1()))
                .map(tuple -> this.createJwtAuthenticationToken(tuple));
    }

    private JwtAuthenticationToken createJwtAuthenticationToken(Tuple2<UserDetails, Optional<Jwt>> tuple) {
         /*
            public User(String username, String password, boolean enabled, boolean accountNonExpired,
			boolean credentialsNonExpired, boolean accountNonLocked,
			Collection<? extends GrantedAuthority> authorities)
			User newUser = new User(user.getUsername(), jwt.getTokenValue(), user.isEnabled(), user.isAccountNonExpired(),
                jwt.getExpiresAt().isBefore(Instant.now()),user.isAccountNonLocked(), user.getAuthorities());
             */
        UserDetails user = tuple.getT1();
        Jwt jwt = tuple.getT2().get();
        logger.info("################################################# user.getAuthorities() => {}", user.getAuthorities());
        JwtAuthenticationToken token = new JwtAuthenticationToken(jwt, user.getAuthorities());
        return token;
    }

    private void defaultPreAuthenticationChecks(UserDetails user) {
        if (!user.isAccountNonLocked()) {
            this.logger.debug("User account is locked");
            throw new LockedException(this.messages.getMessage("AbstractUserDetailsAuthenticationProvider.locked",
                    "User account is locked"));
        }
        if (!user.isEnabled()) {
            this.logger.debug("User account is disabled");
            throw new DisabledException(
                    this.messages.getMessage("AbstractUserDetailsAuthenticationProvider.disabled", "User is disabled"));
        }
        if (!user.isAccountNonExpired()) {
            this.logger.debug("User account is expired");
            throw new AccountExpiredException(this.messages
                    .getMessage("AbstractUserDetailsAuthenticationProvider.expired", "User account has expired"));
        }
    }

    private void defaultPostAuthenticationChecks(UserDetails user) {
        if (!user.isCredentialsNonExpired()) {
            this.logger.debug("User account credentials have expired");
            throw new CredentialsExpiredException(this.messages.getMessage(
                    "AbstractUserDetailsAuthenticationProvider.credentialsExpired", "User credentials have expired"));
        }
    }

    @Override
    public Mono<Map<String, Object>> getClientIdProviders(String contextId) {
        RealmResource realm = keycloak.realm(contextId);
        Map<String, Object> aMap = realm.clients().findAll().stream()
                .collect(Collectors.toMap(cr -> cr.getClientId(), cr -> generateMapFromClient(cr)));
        return Mono.just(aMap);
    }

    private Map<String, Object> generateMapFromClient(ClientRepresentation cr) {
        Map<String, Object> aMap = new HashMap<>();
        Map converted = objectMapper.convertValue(cr, Map.class);
        aMap.putAll(converted);
        return aMap;
    }

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


    public Mono<Map<String, Object>> getPublicKeysFromContextIds(Flux<String> contextIds) {

        return Flux.from(contextIds)
                .flatMap(contextId -> getPublicKeyFromContextId(contextId))
                .collectList()
                .map(listMaps -> {
                    Map<String, Object> keyMap = new HashMap<>();
                    keyMap.put("keys",listMaps);
                    return keyMap;
                });

    }

    public Mono<Map<String, Object>> getPublicKeysFromContextIds(List<String> contextIds) {
        return getPublicKeysFromContextIds(Flux.fromIterable(contextIds));
    }



}
