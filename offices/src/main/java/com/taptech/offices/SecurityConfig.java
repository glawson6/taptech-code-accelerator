package com.taptech.offices;

import com.taptech.common.security.authentication.AuthenticationServiceAuthenticationManager;
import com.taptech.common.security.jwt.SecurityReactiveJwtDecoder;
import com.taptech.common.security.keycloak.EnableKeyCloak;
import com.taptech.common.security.keycloak.KeyCloakAuthenticationManager;
import com.taptech.common.security.keycloak.KeyCloakReactiveAuthenticationManagerResolver;
import com.taptech.common.security.keycloak.KeyCloakService;
import com.taptech.common.security.token.EnableTokenApi;
import com.taptech.common.security.user.InMemoryUserContextPermissionsService;
import com.taptech.common.security.user.UserContextPermissionsConfig;
import com.taptech.common.security.user.UserContextPermissionsService;
import com.taptech.common.security.utils.SecurityUtils;
import com.taptech.common.swagger.EnableWebFluxSwagger;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.*;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.method.configuration.EnableReactiveMethodSecurity;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.core.userdetails.*;
import org.springframework.security.oauth2.jwt.JwtValidators;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.oauth2.jwt.ReactiveJwtDecoder;
import org.springframework.security.web.server.SecurityWebFilterChain;
import org.springframework.security.web.server.util.matcher.NegatedServerWebExchangeMatcher;
import org.springframework.security.web.server.util.matcher.ServerWebExchangeMatcher;
import org.springframework.security.web.server.util.matcher.ServerWebExchangeMatchers;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.reactive.CorsWebFilter;
import org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.Arrays;

import static com.taptech.common.security.utils.SecurityUtils.PUBLIC_ENDPOINTS;
import static org.springframework.security.config.Customizer.withDefaults;

@EnableWebFluxSwagger
@EnableReactiveMethodSecurity
@EnableWebFluxSecurity
@Configuration
@SecurityScheme(type = SecuritySchemeType.HTTP, name = "BasicAuth", scheme = "basic", description = "authentication using basic authentication")
public class SecurityConfig {
    private static final Logger logger = LoggerFactory.getLogger(SecurityConfig.class);
    public static final String OFFICES = "offices";

    @Configuration
    @Profile(value = {"default"})
    public static class NonSecure {


        public NonSecure() {
            logger.info("Loading SecurityConfig.NonSecure...... ");
        }

        @Order(-2147483648)
        @Bean
        public SecurityWebFilterChain springSecurityWebFilterChain(ServerHttpSecurity http) {
            http.authorizeExchange((authorize) -> authorize.pathMatchers("/**").permitAll());
            http.csrf(csrfSpec -> csrfSpec.disable());
            http.cors(corsSpec -> corsSpec.disable());
            return http.build();
        }
    }

    @Configuration
    @EnableKeyCloak
    @EnableTokenApi
    @Profile(value = {"secure"})
    public static class Secure {

        public Secure() {

            logger.info("Loading SecurityConfig.Secure...... ");
        }

        @Autowired
        KeyCloakAuthenticationManager keyCloakAuthenticationManager;

        @Autowired
        InMemoryUserContextPermissionsService userContextPermissionsService;

        @Autowired
        KeyCloakService keyCloakService;

        @Order(Ordered.HIGHEST_PRECEDENCE)
        @Bean
        SecurityWebFilterChain webHttpSecurity(ServerHttpSecurity http) {


            ServerWebExchangeMatcher publicMatchers = ServerWebExchangeMatchers.pathMatchers(PUBLIC_ENDPOINTS);
            ServerWebExchangeMatcher optionsMatchers = ServerWebExchangeMatchers.pathMatchers(HttpMethod.OPTIONS, "/**");

            http.securityMatcher(new NegatedServerWebExchangeMatcher(ServerWebExchangeMatchers.matchers(publicMatchers, optionsMatchers)));

            http.oauth2ResourceServer(oAuth2ResourceServerSpec ->
                    oAuth2ResourceServerSpec.authenticationManagerResolver(new KeyCloakReactiveAuthenticationManagerResolver(keyCloakAuthenticationManager))
            );

            http.authorizeExchange((authorize) -> authorize.pathMatchers("api/v1/offices/**").authenticated());

            http.csrf(csrfSpec -> csrfSpec.disable());
            //http.cors(corsSpec -> corsSpec.configurationSource(corsConfigurationSource()));
            return http.build();
        }

        //@PostConstruct
        public void afterInit() {
            /*
            logger.info("Loading users into keycloak......");

            // write a method to load users from a json file


            userContextPermissionsService.addPermissions("admin", OFFICES, Set.of("ADMIN"));
            userContextPermissionsService.addPermissions("admin@cc.com", OFFICES, Set.of("ADMIN"));
            userContextPermissionsService.addPermissions("user@cc.com", OFFICES, Set.of("USER"));
            userContextPermissionsService.addPermissions("user", OFFICES, Set.of("USER"));

            ContextEntity context = ContextEntity.builder()
                    .contextId(OFFICES)
                    .contextName(OFFICES)
                    .name(OFFICES)
                    .build();

            keyCloakService.createRealmFromContextEntity(context);
            UserEntity userEntity1 = UserEntity.builder()
                    .contextId(OFFICES)
                    .email("admin@cc.com")
                    .password("admin")
                    .build();
            UserEntity userEntity2 = UserEntity.builder()
                    .contextId(OFFICES)
                    .email("user@cc.com")
                    .password("user")
                    .build();

            keyCloakService.postUserToKeyCloak(userEntity1).subscribe();
            keyCloakService.postUserToKeyCloak(userEntity2).subscribe();




             */
        }



    }


    @Configuration
    @Import({UserContextPermissionsConfig.class})
    @Profile(value = {"secure-jwk"})
    public static class SecureJwk {

        public SecureJwk() {

            logger.info("Loading SecurityConfig.SecureJwk...... ");
        }

        @Autowired
        UserContextPermissionsService httpReadingUserContextPermissionsService;

        @Autowired
        Environment env;

        @Bean
        ReactiveJwtDecoder jwtDecoder(Environment env) {
            String jwkSetUri = env.getProperty("spring.security.oauth2.resourceserver.jwt.jwk-set-uri");
            //String issuerURI = env.getProperty("spring.security.oauth2.resourceserver.jwt.issuer-uri");
            NimbusJwtDecoder nimbusJwtDecoder = NimbusJwtDecoder.withJwkSetUri(jwkSetUri).build();
            nimbusJwtDecoder.setJwtValidator(JwtValidators.createDefault());
            return new SecurityReactiveJwtDecoder(nimbusJwtDecoder);
        }

        @Bean
        @Primary
        AuthenticationServiceAuthenticationManager authenticationServiceAuthenticationManager(UserContextPermissionsService userContextPermissionsService) {
            String baseUrl = env.getProperty("user.context.permissions.base-url");
            String jwkSetPath = UriComponentsBuilder.fromHttpUrl(baseUrl)
                    .path(SecurityUtils.AUTH_CERT_CLIENT_URI)
                    .build()
                    .toString();

            return AuthenticationServiceAuthenticationManager.builder()
                    .userContextPermissionsService(userContextPermissionsService)
                    .jwkSetUri(jwkSetPath)
                    .defaultContext(OFFICES)
                    .build();
        }


        @Order(Ordered.HIGHEST_PRECEDENCE)
        @Bean
        SecurityWebFilterChain webHttpSecurity(ServerHttpSecurity http, ReactiveJwtDecoder jwtDecoder,
                                               AuthenticationServiceAuthenticationManager authenticationServiceAuthenticationManager) {

            String[] publicEndpointsInsecure = new String[] {"/actuator/**",
                    "/swagger-ui/**", "/v3/**", "/swagger-ui.html**", "/webjars/**", "/favicon.ico**"};

            ServerWebExchangeMatcher publicMatchers = ServerWebExchangeMatchers.pathMatchers(publicEndpointsInsecure);
            ServerWebExchangeMatcher optionsMatchers = ServerWebExchangeMatchers.pathMatchers(HttpMethod.OPTIONS, "/**");

            http.securityMatcher(new NegatedServerWebExchangeMatcher(ServerWebExchangeMatchers.matchers(publicMatchers, optionsMatchers)));

            http.authorizeExchange((authorize) -> authorize.pathMatchers("api/v1/offices/**").authenticated());

            http.csrf(csrfSpec -> csrfSpec.disable());
            http.oauth2ResourceServer(withDefaults());
            http.oauth2ResourceServer(oAuth2ResourceServerSpec -> {
                oAuth2ResourceServerSpec.jwt(jwtSpec -> {
                    jwtSpec.jwtDecoder(jwtDecoder);
                    jwtSpec.authenticationManager(authenticationServiceAuthenticationManager);
                });
            } );

            return http.build();
        }

    }

    @Configuration
    @Profile(value = {"secure","secure-jwk"})
    public static class CommonSecurityConfig {

        public CommonSecurityConfig() {
            logger.info("Loading SecurityConfig.CommonSecurityConfig...... ");
        }

        @Bean
        CorsWebFilter corsWebFilter() {
            CorsConfiguration configuration = new CorsConfiguration();
            configuration.setAllowedOriginPatterns(Arrays.asList("*"));
            configuration.setAllowedMethods(Arrays.asList("*"));
            configuration.setAllowedHeaders(Arrays.asList("*"));
            configuration.setExposedHeaders(Arrays.asList("*"));


            UrlBasedCorsConfigurationSource source =
                    new UrlBasedCorsConfigurationSource();
            source.registerCorsConfiguration("/**", configuration);

            return new CorsWebFilter(source);
        }

        @Bean
        public MapReactiveUserDetailsService userDetailsService() {
            UserDetails user = User.builder()
                    .username("user@cc.com")
                    .password("user")
                    .roles("USER")
                    .build();
            UserDetails admin = User.builder()
                    .username("admin@cc.com")
                    .password("admin")
                    .roles("ADMIN")
                    .build();
            return new MapReactiveUserDetailsService(user, admin);
        }
    }

}
