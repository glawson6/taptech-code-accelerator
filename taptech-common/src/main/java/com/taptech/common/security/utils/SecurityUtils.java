package com.taptech.common.security.utils;

import com.taptech.common.security.keycloak.KeyCloakServiceException;
import com.taptech.common.security.token.JwtViewer;
import com.taptech.common.security.user.SecurityUser;
import com.taptech.common.security.user.UserContextPermissions;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.core.AuthorizationGrantType;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtDecoderFactory;
import org.springframework.web.reactive.function.client.ClientResponse;
import org.springframework.web.util.UriComponentsBuilder;
import reactor.core.publisher.Mono;
import reactor.util.function.Tuple2;
import reactor.util.function.Tuples;

import java.io.InputStream;
import java.nio.charset.Charset;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.function.BiFunction;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.taptech.common.Constants.COLON;


public abstract class SecurityUtils {
    static final Logger logger = LoggerFactory.getLogger(SecurityUtils.class);

    private SecurityUtils() {
    }

    public final static String BASIC_PREFIX = "Basic ";
    public final static String BEARER_PREFIX = "Bearer ";
    public final static String EMPTY_STRING = "";

    public static final String[] PUBLIC_ENDPOINTS = new String[] {"/actuator/**",
            "/swagger-ui/**", "/v3/**", "/swagger-ui.html**", "/webjars/**", "/public/**", "/favicon.ico**"};


    public static String basicAuthCredsFrom(String username, String password){
        return Base64.getEncoder().encodeToString(new StringBuilder(username)
                .append(COLON)
                .append(password)
                .toString().getBytes(Charset.defaultCharset()));
    }

    public static Tuple2<String,String> fromBasicAuthToTuple(String basicAuth){
        String token = basicAuth.replace(BASIC_PREFIX,EMPTY_STRING);
        String decoded = new String(Base64.getDecoder().decode(token.getBytes(Charset.defaultCharset())));
        String[] array = decoded.split(COLON);
        return Tuples.of(array[0],array[1]);
    }

    public static String fromBearerHeaderToToken(String authorization) {
        String token = authorization.replace(BEARER_PREFIX, EMPTY_STRING);
        return token;
    }

    public static String toBearerHeaderFromToken(String token) {
        return new StringBuilder(BEARER_PREFIX)
                .append(token).toString();
    }

    public static Function<UserContextPermissions, UserDetails> convertUserContextPermissionsToUserDetails() {
        return userContextPermissions -> {
            List<GrantedAuthority> grantedAuthorities = userContextPermissions.getPermissions()
                    .stream()
                    .map(SimpleGrantedAuthority::new)
                    .collect(Collectors.toList());

            UserDetails user = SecurityUser.builder()
                    .authorities(grantedAuthorities)
                    .username(userContextPermissions.getUserId())
                    .build();
            return user;
        };
    }


    public static Function<UserContextPermissions, UserDetails> convertUserContextPermissionsToUserDetails(Optional<Jwt> jwt) {
        return userContextPermissions -> {
            List<GrantedAuthority> grantedAuthorities = userContextPermissions.getPermissions()
                    .stream()
                    .map(SimpleGrantedAuthority::new)
                    .collect(Collectors.toList());

            UserDetails user = SecurityUser.builder()
                    .authorities(grantedAuthorities)
                    .jwt(jwt)
                    .username(userContextPermissions.getUserId())
                    .build();
            return user;
        };
    }

    public static final UserDetails noOpUserDetails(String username){
        return SecurityUser.builder()
                .authorities(Collections.singletonList(new SimpleGrantedAuthority(username.toLowerCase())))
                .username(username)
                .build();
    }

    public static Authentication noOpAuthentication(String username){
        return new AnonymousAuthenticationToken(username, username, Collections.singletonList(new SimpleGrantedAuthority(username.toLowerCase())));
    }

    public static BiFunction<Map<String,Object>, ObjectMapper, JsonNode> convertToJsonNode(){
        return (map,objectMapper) -> {
            Map<String, Object> newMap = new HashMap<>();
            return objectMapper.convertValue(map, JsonNode.class);
        };
    }


    public static BiFunction<Map<String,Object>, ObjectMapper, JsonNode> convertToStringThenJsonNode(){
        return (map,objectMapper) -> {
            JsonNode jsonNode = null;
            try {
                String json = objectMapper.writeValueAsString(map);
                logger.info("Got json => {}",json);
                jsonNode = objectMapper.readTree(json);

            } catch (JsonProcessingException e) {
                throw new KeyCloakServiceException(e.getMessage());
            }
            return jsonNode;
        };
    }

    public static Function<ArrayNode, Map<String,Object>> convertArrayNodeToMap(){
        return jsonNode -> {
            Map<String, Object> map = new HashMap<>();
            jsonNode.fields().forEachRemaining(entry -> {
                map.put(entry.getKey(),entry.getValue());
            });
            return map;
        };
    }

    public static BiFunction<Map<String, Object>, ObjectMapper, ObjectNode> convertMapToObjectNode(){
        return (map,objectMapper) -> {
            ObjectNode objectNode = objectMapper.createObjectNode();
            map.forEach(objectNode::putPOJO);
            return objectNode;
        };
    }


    public static BiFunction<ArrayNode, ObjectMapper, ObjectNode> convertArrayNodeToObjectNode(){
        return (arrayNode,objectMapper) -> {
            ObjectNode objectNode = objectMapper.createObjectNode();
            arrayNode.fields().forEachRemaining(entry -> {
                objectNode.putPOJO(entry.getKey(),entry.getValue());
            });
            return objectNode;
        };
    }


    public static BiFunction<JsonNode, ObjectMapper, ObjectNode> convertJsonNodeToObjectNode(){
        return (arrayNode,objectMapper) -> {
            ObjectNode objectNode = objectMapper.createObjectNode();
            arrayNode.fields().forEachRemaining(entry -> {
                objectNode.putPOJO(entry.getKey(),entry.getValue());
            });
            return objectNode;
        };
    }

    public static Function<Jwt, JwtViewer> convertJwtToJwtViewer(){
        return jwt -> {
            JwtViewer jwtViewer = new JwtViewer(jwt.getTokenValue(), jwt.getIssuedAt(), jwt.getExpiresAt(), jwt.getHeaders(), jwt.getClaims());
            return jwtViewer;
        };
    }

    public static InputStream getInputStreamFromResource(String resourcePath) {
        return SecurityUtils.class.getClassLoader().getResourceAsStream(resourcePath);
    }

    public static final String DATETIME_FORMAT = "dd-MM-yyyy HH:mm";
    public static final LocalDateTime FIXED_DATE = LocalDateTime.now();
    public static LocalDateTimeSerializer LOCAL_DATETIME_SERIALIZER = new LocalDateTimeSerializer(DateTimeFormatter.ofPattern(DATETIME_FORMAT));


    public static final String AUTH_CERT_CLIENT_URI = "/public/jwkKeys";

    public static JwtDecoder createTokenApiJwtDecoderFromContextId(JwtDecoderFactory jwtDecoderFactory, String contextId, String baseUrl){
        //String jwkSetPath = UriComponentsBuilder.fromHttpUrl(baseUrl).path(AUTH_CERT_CLIENT_URI).build().toString();
        logger.info("createTokenApiJwtDecoderFromContextId Calculated jwkSetPath =>  {}  for JwtDecoder ", new Object[]{baseUrl});
        ClientRegistration.Builder builder = ClientRegistration.withRegistrationId(contextId);
        ClientRegistration clientRegistration = builder.clientId(contextId)
                .jwkSetUri(baseUrl)
                .tokenUri(baseUrl)
                .issuerUri(baseUrl)
                .authorizationGrantType(AuthorizationGrantType.CLIENT_CREDENTIALS)
                .build();

        JwtDecoder decoder = jwtDecoderFactory.createDecoder(clientRegistration);
        return decoder;
    }

    /*
    public static <V> Function<ClientResponse, ? extends Mono<V>> authTokenValidationResponse(ObjectMapper objectMapper) {
        return response -> {
            return response.bodyToMono(String.class)
                    .flatMap(errorBody -> {
                        logger.error("Error in getUserContextByUserIdAndContextId => {}",errorBody);
                        String errorMessage = errorBody;
                        ErrorResponse errorResponse = null;
                        try {
                            errorResponse = objectMapper.readValue(errorBody, ErrorResponse.class);
                        } catch (JsonProcessingException e) {
                            logger.warn("Error parsing error response", e);
                        }
                        final String finalErrorMessage = errorResponse != null ? errorResponse.getMessage() : errorMessage;
                        return Mono.defer(() -> Mono.error(new CannotValidateTokenException(finalErrorMessage)));
                    });
        };
    }

     */




}
