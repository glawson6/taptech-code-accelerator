package com.taptech.common.security.keycloak;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.keycloak.representations.idm.ClientRepresentation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.core.AuthorizationGrantType;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtDecoderFactory;
import org.springframework.web.util.UriComponentsBuilder;
import reactor.core.publisher.Mono;

import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.KeySpec;
import java.util.Base64;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;


public class KeyCloakUtils {

    static final Logger logger = LoggerFactory.getLogger(KeyCloakUtils.class);

    public static final String KEY_CLOAK_DEFAULT_CONTEXT = "user-context-service";
    final static Mono<Map<String, Object>> EMPTY_ACCESS_CREDS = Mono.empty();
    final static ParameterizedTypeReference<Map<String, Object>> MAP_OBJECT = new ParameterizedTypeReference<Map<String, Object>>() {
    };
    final static ObjectMapper OBJECT_MAPPER = new ObjectMapper();
    final static ResourceLoader resourceLoader = new DefaultResourceLoader();
    public static final String DEFAULT_CLIENT_TEMPLATE = "classpath:client/keycloak-client-template2.json";


    public static final String TOKEN_CLIENT_URI = "/realms/{realm}/protocol/openid-connect/token";
    public static final String CERT_CLIENT_URI = "/realms/{realm}/protocol/openid-connect/certs";
    public static final String ISSUER_CLIENT_URI = "/realms/{realm}";



    public static Optional<ClientRepresentation> loadClientRepresentationTemplate(String defaultClientPath) {
        Optional<ClientRepresentation> clientRepresentation = Optional.empty();
        try{
            Resource resource = resourceLoader.getResource(DEFAULT_CLIENT_TEMPLATE);
            clientRepresentation = Optional.ofNullable(OBJECT_MAPPER.readValue(resource.getInputStream(), ClientRepresentation.class));
        } catch(Exception e ){
            logger.error("Could not load {} for client template",defaultClientPath,e);
        }
        return clientRepresentation;
    }

    public static final Integer DEFAULT_KEY_SIZE = 256;
    public static String createAKey(){
        String key = null;
        try{
            SecretKey secretKey = generateKey(DEFAULT_KEY_SIZE);
            key = convertSecretKeyToString(secretKey);
        } catch (Exception e){
            logger.error("Could not create key ",e);
        }
         return key;
    }

    /* Generating Secret key */

    // Generating Secret Key using KeyGenerator class with 256
    public static SecretKey generateKey(int n) throws NoSuchAlgorithmException {
        KeyGenerator keyGenerator = KeyGenerator.getInstance("AES");
        keyGenerator.init(n);
        SecretKey originalKey = keyGenerator.generateKey();
        return originalKey;
    }

    /*
    // Generating Secret Key using password and salt
    public static SecretKey getKeyFromPassword(String password, String salt)
            throws NoSuchAlgorithmException, InvalidKeySpecException {
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        KeySpec spec = new PBEKeySpec(password.toCharArray(), salt.getBytes(), 65536, 256);
        SecretKey originalKey = new SecretKeySpec(factory.generateSecret(spec).getEncoded(), "AES");
        return originalKey;
    }





    public static SecretKey convertStringToSecretKeyto(String encodedKey) {
        // Decoding the Base64 encoded string into byte array
        byte[] decodedKey = Base64.getDecoder().decode(encodedKey);
        // Rebuilding the Secret Key using SecretKeySpec Class
        SecretKey originalKey = new SecretKeySpec(decodedKey, 0, decodedKey.length, "AES");
        return originalKey;
    }

    public static String extractClientSecret(Keycloak keycloak, String contextId){
        ClientRepresentation clientRepresentation = keycloak.realm(contextId).clients().findAll().stream()
                .peek(cr -> logger.info("clientRepresentation => {}", cr.getClientId()))
                .filter(cr -> cr.getClientId().equals(contextId))
                .findAny().orElseThrow(() -> new KeyCloakClientNotFoundException(new StringBuilder(contextId).append(" not found").toString()));
        String clientSecret = keycloak.realm(contextId).clients().get(clientRepresentation.getId()).getSecret().getValue();
        return clientSecret;
    }


    */

    public static SecretKey getKeyFromPassword(String password, String salt)
            throws NoSuchAlgorithmException, InvalidKeySpecException {
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        KeySpec spec = new PBEKeySpec(password.toCharArray(), salt.getBytes(), 65536, 256);
        SecretKey originalKey = new SecretKeySpec(factory.generateSecret(spec).getEncoded(), "AES");
        return originalKey;
    }

    public static String convertSecretKeyToString(SecretKey secretKey) throws NoSuchAlgorithmException {
        // Converting the Secret Key into byte array
        byte[] rawData = secretKey.getEncoded();
        // Getting String - Base64 encoded version of the Secret Key
        String encodedKey = Base64.getEncoder().encodeToString(rawData);
        return encodedKey;
    }

    public final static Function<Map<String, Object>, Optional<Jwt>> convertResultMapToJwt(JwtDecoder jwtDecoder) {
        return map -> {
            String accessToken = (String)map.get("access_token");
            Jwt jwt = null;
            try{

                //logger.trace("KeyCloakUtils.convertResultMapToJwt token => {}",accessToken);
                jwt = jwtDecoder.decode(accessToken);
            } catch (Exception e){
                logger.warn("Could not decode jwt!",e);
            }
            return Optional.ofNullable(jwt);
        };
    }

    public static JwtDecoder createJwtDecoderFromContextId(JwtDecoderFactory jwtDecoderFactory, String contextId, String realmBaseUrl){
        String jwkSetPath = UriComponentsBuilder.fromHttpUrl(realmBaseUrl).path(CERT_CLIENT_URI).build(Map.of("realm", contextId)).toString();
        String tokenPath = UriComponentsBuilder.fromHttpUrl(realmBaseUrl).path(TOKEN_CLIENT_URI).build(Map.of("realm", contextId)).toString();
        String issuerPath = UriComponentsBuilder.fromHttpUrl(realmBaseUrl).path(ISSUER_CLIENT_URI).build(Map.of("realm", contextId)).toString();
        logger.info("createJwtDecoderFromContextId Calculated jwkSetPath =>  {} tokenPath => {} issuerUrl => {} for JwtDecoder ",
                new Object[]{jwkSetPath, tokenPath, issuerPath});
        ClientRegistration.Builder builder = ClientRegistration.withRegistrationId(contextId);
        ClientRegistration clientRegistration = builder.clientId(contextId)
                .jwkSetUri(jwkSetPath)
                .tokenUri(tokenPath)
                .issuerUri(issuerPath)
                .authorizationGrantType(AuthorizationGrantType.CLIENT_CREDENTIALS)
                .build();

        JwtDecoder decoder = jwtDecoderFactory.createDecoder(clientRegistration);
        return decoder;
    }


}
