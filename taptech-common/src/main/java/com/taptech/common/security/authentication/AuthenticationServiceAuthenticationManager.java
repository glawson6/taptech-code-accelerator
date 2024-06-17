package com.taptech.common.security.authentication;

import com.taptech.common.security.user.UserContextPermissions;
import com.taptech.common.security.user.UserContextPermissionsService;
import com.taptech.common.security.user.UserContextRequest;
import com.taptech.common.security.utils.SecurityUtils;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.security.authentication.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.SpringSecurityMessageSource;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtDecoderFactory;
import org.springframework.security.oauth2.server.resource.authentication.BearerTokenAuthenticationToken;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.util.Assert;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;
import reactor.util.function.Tuple2;
import reactor.util.function.Tuples;

import java.util.Map;
import java.util.Optional;
import java.util.function.Function;

import static com.taptech.common.Constants.CONTEXT_ID;
import static com.taptech.common.security.utils.SecurityUtils.createTokenApiJwtDecoderFromContextId;

@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AuthenticationServiceAuthenticationManager implements ReactiveAuthenticationManager {

    private static final Logger logger = LoggerFactory.getLogger(AuthenticationServiceAuthenticationManager.class);

    String defaultContext;
    UserContextPermissionsService userContextPermissionsService;
    String jwkSetUri;
    @Builder.Default
    JwtDecoderFactory<ClientRegistration> jwtDecoderFactory = new AuthenticationJwtDecoderFactory();
    @Builder.Default
    ObjectMapper objectMapper = new ObjectMapper();
    @Builder.Default
    protected MessageSourceAccessor messages = SpringSecurityMessageSource.getAccessor();

    @PostConstruct
    public void init(){
        Assert.notNull(userContextPermissionsService, "userContextPermissionsService must not be null");
        Assert.notNull(jwkSetUri, "jwkSetUri must not be null");
        Assert.notNull(jwtDecoderFactory, "jwtDecoderFactory must not be null");
        Assert.notNull(objectMapper, "objectMapper must not be null");
        Assert.notNull(messages, "messages must not be null");
        Assert.notNull(defaultContext, "defaultContext must not be null");
    }

    public Mono<Tuple2<UserDetails, Optional<Jwt>>> retrieveUser(Authentication authentication) {
        String contextId = determineContext(authentication);
        logger.info("retrieveUser(Authentication authentication) authentication name => {} authentication.getName() => {}, context => {}",authentication.getClass().getName(),
                authentication.getName() ,contextId);
        if (authentication instanceof BearerTokenAuthenticationToken) {
            BearerTokenAuthenticationToken bearerToken = (BearerTokenAuthenticationToken) authentication;

            return Mono.just(bearerToken)
                    .publishOn(Schedulers.boundedElastic())
                    .flatMap(token -> getUserFromAutheticationService(token, contextId))
                    .map(userCtx -> extractJwtFromToken(jwtDecoderFactory, jwkSetUri).apply(userCtx));

        } else {
            return Mono.error(new BadCredentialsException("Invalid Credentials"));
        }

    }

    Function<Tuple2<BearerTokenAuthenticationToken,UserContextPermissions>, Tuple2<UserDetails, Optional<Jwt>>> extractJwtFromToken(JwtDecoderFactory jwtDecoderFactory, String jwkSetUri) {
       return tuple -> {
           JwtDecoder jwtDecoder = createTokenApiJwtDecoderFromContextId(jwtDecoderFactory, tuple.getT2().getContextId(), jwkSetUri);
           Optional<Jwt> jwt = Optional.empty();
           try{

               logger.info("################################################# tuple.getT1().getToken() => {}", tuple.getT1().getToken());
               jwt = Optional.of(jwtDecoder.decode(tuple.getT1().getToken()));
               logger.info("################################################# jwt => {}", jwt);
           } catch (Exception e) {
               logger.error("Error extracting jwt from token", e);
           }
           UserDetails userDetails = SecurityUtils.convertUserContextPermissionsToUserDetails(jwt).apply(tuple.getT2());
              return Tuples.of(userDetails, jwt);
       };
    }

    private Mono<Tuple2<BearerTokenAuthenticationToken,UserContextPermissions>> getUserFromAutheticationService(BearerTokenAuthenticationToken token, String contextId) {
        return Mono.just(token)
                .publishOn(Schedulers.boundedElastic())
                .flatMap(bearerToken -> {
                    return userContextPermissionsService.getUserContextByUserIdAndContextId(UserContextRequest.builder()
                            .contextId(contextId)
                            .token(bearerToken.getToken())
                            .build());
                })
                .map(userCtx -> Tuples.of(token, userCtx));
    }

    @Override
    public Mono<Authentication> authenticate(Authentication authentication) {

        return retrieveUser(authentication)
                .doOnNext(tuple -> defaultPreAuthenticationChecks(tuple.getT1()))
                .publishOn(Schedulers.boundedElastic())
                .filter((tuple) -> tuple.getT2().isPresent())
                .switchIfEmpty(Mono.defer(() -> Mono.error(new BadCredentialsException("Invalid Credentials"))))
                .doOnNext(tuple -> defaultPostAuthenticationChecks(tuple.getT1()))
                .map(this::createJwtAuthenticationToken);

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


    String determineContext(Authentication authentication) {

        return authentication.getDetails() != null ? ((Map<String, String>) authentication.getDetails()).getOrDefault(CONTEXT_ID, defaultContext)
                : defaultContext;
    }
}
