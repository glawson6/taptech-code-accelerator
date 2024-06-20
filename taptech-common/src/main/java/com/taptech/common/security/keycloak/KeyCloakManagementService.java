package com.taptech.common.security.keycloak;

import com.taptech.common.security.ContextEntity;
import com.taptech.common.security.SecurityCredentialsProvider;
import com.taptech.common.security.UserEntity;
import com.taptech.common.utils.RandomPasswordGenerator;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.ws.rs.NotFoundException;
import jakarta.ws.rs.core.Response;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.resource.RealmResource;
import org.keycloak.representations.idm.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.util.Assert;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Scheduler;
import reactor.core.scheduler.Schedulers;
import reactor.util.function.Tuple2;
import reactor.util.function.Tuples;

import javax.annotation.PostConstruct;
import java.util.*;
import java.util.function.Function;

import static com.taptech.common.security.keycloak.KeyCloakUtils.MAP_OBJECT;
import static com.taptech.common.utils.RandomPasswordGenerator.generateRandomSpecialCharacters;

@Builder
@NoArgsConstructor
@AllArgsConstructor
public class KeyCloakManagementService {
    static final Logger logger = LoggerFactory.getLogger(KeyCloakManagementService.class);
    public static final String MASTER = "master";
    public static final String ADMIN_CLI = "admin-cli";
    /*
     PUT /admin/realms/testing/clients/4b2451a1-c8d0-4966-8707-a33389ce5cb7
      /admin/realms/user-ContextEntity-service/clients/b2571876-44bc-4881-934a-5cb70f3a95de/client-secret
     */
    public static final String PUT_CLIENT_URI = "/admin/realms/{realm}/clients/{id}";
    public static final String GET_CLIENT_SECRET_URI = "/admin/realms/{realm}/clients/{id}/client-secret";

    WebClient webClient;
    ObjectMapper objectMapper;
    KeyCloakIdpProperties keyCloakIdpProperties;
    JwtDecoder jwtDecoder;
    @Builder.Default
    Scheduler scheduler = Schedulers.boundedElastic();
    Keycloak keycloak;
    ClientRepresentation template;
    SecurityCredentialsProvider securityCredentialsProvider;

    @PostConstruct
    public void init(){

        Assert.notNull(keyCloakIdpProperties.baseUrl(), "Keycloak idp.provider.keycloak.base-url cannot be null");
        Assert.notNull(keyCloakIdpProperties.adminTokenUri(), "Keycloak idp.provider.keycloak.admin-token-uri cannot be null");
        Assert.notNull(keyCloakIdpProperties.adminClientId(), "Keycloak idp.provider.keycloak.admin-client-id cannot be null");
        Assert.notNull(keyCloakIdpProperties.adminClientSecret(), "Keycloak idp.provider.keycloak.admin-client-secret cannot be null");
        Assert.notNull(keyCloakIdpProperties.adminUsername(), "Keycloak idp.provider.keycloak.admin-username cannot be null");
        //Assert.notNull(keyCloakIdpProperties.adminRealmUri(), "Keycloak idp.provider.keycloak.admin-realm-uri cannot be null");

        webClient = WebClient.builder()
                .baseUrl(keyCloakIdpProperties.baseUrl())
                .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_FORM_URLENCODED_VALUE)
                .build();
        KeyCloakUtils.loadClientRepresentationTemplate(KeyCloakUtils.DEFAULT_CLIENT_TEMPLATE).ifPresent(cr -> template = cr);

    }

    /*
    The adminCliAccessCreds() method for KeyCloak uses the admin-cli client_id and client_secret to obtain an access token
    against the master realm tokenuri or /realms/master/protocol/openid-connect/token. The admin-cli client has to be
    modified. This url walks through the changes needed for admin-cli.
    https://www.mastertheboss.com/keycloak/how-to-use-keycloak-admin-rest-api/
     */
    public Mono<Map<String, Object>> adminCliAccessCreds() {

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

    public Mono<Optional<ClientRepresentation>> getClientFromContextEntityId(String ContextEntityId){

       return  Mono.just(keycloak.realm(ContextEntityId).clients().findAll().stream()
                .filter(cr -> cr.getClientId().equals(ContextEntityId))
                .findFirst())
               .publishOn(scheduler);
    }

    public Mono<String> getClientSecret(String ContextEntityId){
         /*
                {
    "type": "secret",
    "value": "0h7LHPeTnDruV2RYVgh9cj8T1n1JHElLk369"
}
                 */
        Optional<ClientRepresentation> clientOptional = keycloak.realm(ContextEntityId).clients().findAll().stream()
                .filter(cr -> cr.getClientId().equals(ContextEntityId))
                .findFirst();

        return Mono.from(adminCliAccessCreds())
                .publishOn(scheduler)
                .flatMap(creds -> webClient.get()
                        .uri(uriBuilder -> uriBuilder.path(GET_CLIENT_SECRET_URI)
                                .build(Map.of("realm",ContextEntityId,"id",clientOptional.orElseThrow(() -> new NotFoundException("Client "+ContextEntityId))
                                        .getId())))
                        .headers(h -> h.setContentType(MediaType.APPLICATION_JSON))
                        .headers(h -> h.setBearerAuth((String) creds.get("access_token")))
                        .retrieve()
                        .toEntity(MAP_OBJECT))
                .map(mapResponseEntity -> mapResponseEntity.getBody())
                .map(map -> (String)map.get("value"));
    }

    public Mono<ResponseEntity<Map<String, Object>>> createRealm(String realmName){

        //keycloak.realms().create(realmRepresentation(realmName));

        return Mono.from(adminCliAccessCreds())
                .publishOn(scheduler)
                .flatMap(creds -> webClient.post()
                        .uri(uriBuilder -> uriBuilder.path(keyCloakIdpProperties.adminRealmUri()).build())
                        .headers(h -> h.setContentType(MediaType.APPLICATION_JSON))
                        .headers(h -> h.setBearerAuth((String) creds.get("access_token")))
                        .bodyValue(realmRepresentation(realmName))
                        .retrieve()
                        .toEntity(MAP_OBJECT));
    }

    static Function<? super Throwable, ? extends Throwable> handleWebClientResponseException(){
        return thrown -> {
            WebClientResponseException webEx = (WebClientResponseException)thrown;
            logger.info("error status => {} error message => {}",webEx.getStatusText(),webEx.getMessage());
            String stackTrace = ExceptionUtils.getStackTrace(webEx);
            logger.error("error stack trace => {}",stackTrace);
            KeyCloakServiceException ex = new KeyCloakServiceException(webEx.getMessage(),webEx);
            return ex;
        } ;
    }

    public Mono<ResponseEntity<Map<String, Object>>> updateClient(String realmName, ClientRepresentation client){

        RealmResource realm = keycloak.realms().realm(realmName);
        return Mono.from(adminCliAccessCreds())
                .publishOn(scheduler)
                .flatMap(creds -> webClient.put()
                        .uri(uriBuilder -> uriBuilder.path(PUT_CLIENT_URI)
                                .build(Map.of("realm",realmName,"id",client.getId())))
                        .headers(h -> h.setContentType(MediaType.APPLICATION_JSON))
                        .headers(h -> h.setBearerAuth((String) creds.get("access_token")))
                        .bodyValue(client)
                        .retrieve()
                        .toEntity(MAP_OBJECT))
                .onErrorStop();
                //.onErrorMap(ex -> ex instanceof WebClientResponseException,handleWebClientResponseException());
    }
    @Builder
    public record CredentialRepresentationKC(String id, String type, String value) {
    }
    /*
   https://www.keycloak.org/docs-api/22.0.1/rest-api/index.html#UserRepresentation
    */
    @Builder
    public record UserRepresentationKC(String id, String email, String firstName, String lastName, Long createdTimestamp,
                                     String username, Boolean enabled, Boolean emailVerified,
                                     List<CredentialRepresentationKC> credentials) {
    }

    Function<String, List<CredentialRepresentationKC>> listCredentialRepresentationFrom(){
        return creds -> {
            return StringUtils.isNotBlank(creds) ? Collections.singletonList(CredentialRepresentationKC.builder()
                    .value(creds)
                    .build())
                    : Collections.emptyList();
        };
    }

    Function<UserEntity, UserRepresentationKC> convertToUserRepresentation() {
        final Long createdTime = System.currentTimeMillis();
        return userEntity -> {
            return UserRepresentationKC.builder()
                    .email(userEntity.getEmail())
                    .username(userEntity.getEmail())
                    .enabled(Boolean.TRUE)
                    .emailVerified(Boolean.TRUE)
                    .lastName(userEntity.getLastName())
                    .firstName(userEntity.getFirstName())
                    .createdTimestamp(createdTime)
                    .credentials(listCredentialRepresentationFrom().apply(userEntity.getPassword()))
                    .build();
        };
    }

    public Mono<ResponseEntity<Map<String, Object>>> postUserToKeyCloak(UserEntity userEntity){
        return Mono.just(userEntity)
                .publishOn(Schedulers.boundedElastic())
                .flatMap(ue -> adminCliAccessCreds())
                .doOnNext(creds -> logger.info("postUserToKeyCloak. Got creds => [{}]",creds))
                .flatMap(creds -> postUserRepresentation().apply(Tuples.of(userEntity, creds)));

    }


    public ResponseEntity<Map<String, Object>> postUserToKeyCloakSync(UserEntity userEntity){

        UserRepresentation userRepresentation = new UserRepresentation();
        UserRepresentationKC userRepresentationKC = convertToUserRepresentation().apply(userEntity);
        BeanUtils.copyProperties(userRepresentationKC, userRepresentation);
        Response response = keycloak.realm(userEntity.getContextId())
                .users()
                .create(userRepresentation);

        logger.info("Got response status => {}",response.getStatus());

        return ResponseEntity.ok(objectMapper.convertValue(userEntity,Map.class));

    }


    /*
    private void initKeycloakUser(UserEntity user) {

        UserRepresentation userRepresentation = new UserRepresentation();
        userRepresentation.setEmail(user.getEmail());
        userRepresentation.setUsername(user.getEmail());
        userRepresentation.setEnabled(true);
        userRepresentation.setEmailVerified(true);
        CredentialRepresentation userCredentialRepresentation = new CredentialRepresentation();
        userCredentialRepresentation.setType(CredentialRepresentation.PASSWORD);
        userCredentialRepresentation.setTemporary(false);
        userCredentialRepresentation.setValue(user.getPassword());
        userRepresentation.setCredentials(Arrays.asList(userCredentialRepresentation));
        keycloak.realm(user.getContextId()).users().create(userRepresentation);

        if (user.isAdmin()) {
            userRepresentation = keycloak.realm(user.getContextId()).users().search(user.getEmail()).get(0);
            UserResource userResource = keycloak.realm(user.getContextId()).users().get(userRepresentation.getId());
            List<RoleRepresentation> rolesToAdd = Arrays.asList(keycloak.realm(user.getContextId()).roles().get("admin").toRepresentation());
            userResource.roles().realmLevel().add(rolesToAdd);
        }
    }

     */

    /*
    Once you have received an access_token from the admin-cli client via the adminCliAccessCreds() method,
    you can call into the specific keycloak realm to add users to that realm.
     */
    Function<Tuple2<? extends UserEntity, Map<String, Object>>, Mono<ResponseEntity<Map<String, Object>>>> postUserRepresentation() {
        return tuple -> {
            logger.info("Got contextId => {} for userUri => {}",tuple.getT1().getContextId(), keyCloakIdpProperties.userUri());
            final UserRepresentationKC userRepresentation = convertToUserRepresentation().apply(tuple.getT1());
            logger.info("Got userRepresentation => {} ",userRepresentation);
            return Mono.just(tuple.getT2())
                    .publishOn(Schedulers.boundedElastic())
                    .doOnNext(creds -> logger.info("Got creds => [{}]",creds))
                    .flatMap(creds -> webClient.post()
                            .uri(uriBuilder -> uriBuilder.path(keyCloakIdpProperties.userUri())
                                    .build(Map.of("realm", tuple.getT1().getContextId())))
                            .headers(h -> h.setContentType(MediaType.APPLICATION_JSON))
                            .headers(h -> h.setAccept(Collections.singletonList(MediaType.ALL)))
                            .headers(h -> h.setBearerAuth((String) creds.get("access_token")))
                            .bodyValue(userRepresentation)
                            .retrieve()
                            .toEntity(MAP_OBJECT)
                    )
                    .onErrorMap(ex -> ex instanceof WebClientResponseException,handleWebClientResponseException());

        };

    }

    // POST /admin/realms/{realm}/clients



    /*
    minimal from https://www.mastertheboss.com/keycloak/how-to-use-keycloak-admin-rest-api/
    {
    "id": "testrealm",
    "realm": "testrealm",
    "accessTokenLifespan": 600,
    "enabled": true,
    "sslRequired": "all",
    "bruteForceProtected": true,
    "loginTheme": "keycloak",
    "eventsEnabled": false,
    "adminEventsEnabled": false
}
     */

    KCRealmRepresentation defaultRealmRepresentation(String realName){
        return KCRealmRepresentation.builder()
                .id(realName)
                .realm(realName)
                .enabled(Boolean.TRUE)
                .duplicateEmailsAllowed(Boolean.FALSE)
                .accessTokenLifespan(600)
                .sslRequired("all")
                .bruteForceProtected(Boolean.TRUE)
                .loginTheme("keycloak")
                .eventsEnabled(Boolean.FALSE)
                .adminEventsEnabled(Boolean.FALSE)
                .build();
    }


    static Function<String, RealmRepresentation> realmRepresentationFunction(KeyCloakIdpProperties keyCloakIdpProperties){
        return realName ->{
            RealmRepresentation realmRepresentation = new RealmRepresentation();
            realmRepresentation.setRealm(realName);
            realmRepresentation.setId(realName);
            realmRepresentation.setEnabled(Boolean.TRUE);
            realmRepresentation.setDuplicateEmailsAllowed(Boolean.FALSE);
            realmRepresentation.setAccessCodeLifespan(keyCloakIdpProperties.accessCodeLifespan());
            realmRepresentation.setSslRequired("none");
            realmRepresentation.setBruteForceProtected(Boolean.TRUE);
            realmRepresentation.setLoginTheme("keycloak");
            realmRepresentation.setEventsEnabled(Boolean.FALSE);
            realmRepresentation.setAdminEventsEnabled(Boolean.FALSE);
            return realmRepresentation;
        };
    }


    RealmRepresentation realmRepresentation(String realName){
        return realmRepresentationFunction(keyCloakIdpProperties).apply(realName);
    }

    @Builder
    public record KCRealmRepresentation(String id, String realm, boolean enabled, boolean duplicateEmailsAllowed,
                                        int accessTokenLifespan, String sslRequired, boolean bruteForceProtected,
                                        String loginTheme, boolean eventsEnabled, boolean adminEventsEnabled) {
    }

    @Builder
    public record ProtocolMapperRepresentation(String id, String name, String protocol, String protocolMapper,Boolean consentRequired,
                                               String consentText, Map<String,String> config){}


    /*
    id, clientId, name, description, rootUrl, adminUrl, baseUrl, enabled, alwaysDisplayInConsole, surrogateAuthRequired,
    enabled, clientAuthenticatorType, secret, registrationAccessToken, defaultRoles, redirectUris, webOrigins, notBefore,
    bearerOnly, consentRequired, standardFlowEnabled, implicitFlowEnabled, directAccessGrantsEnabled, serviceAccountsEnabled,
    oauth2DeviceAuthorizationGrantEnabled, authorizationServicesEnabled, directGrantsOnly, publicClient, frontchannelLogout,
    protocol, attributes, authenticationFlowBindingOverrides, fullScopeAllowed, nodeReRegistrationTimeout, registeredNodes,
    protocolMappers, clientTemplate, useTemplateConfig, useTemplateScope, useTemplateMappers, defaultClientScopes,
    optionalClientScopes, authorizationSettings, access, origin
     */


    @Builder
    public record KCClientRepresentation(String id, String clientId, String name, String description, String rootUrl, String adminUrl, String baseUrl,
                                         Boolean surrogateAuthRequired, Boolean enabled, Boolean alwaysDisplayInConsole, String clientAuthenticatorType,
                                         String secret, String registrationAccessToken, List<String> defaultRoles, List<String> redirectUris,
                                         List<String> webOrigins, Integer notBefore, Boolean bearerOnly, Boolean consentRequired, Boolean standardFlowEnabled,
                                         Boolean implicitFlowEnabled, Boolean directAccessGrantsEnabled, Boolean serviceAccountsEnabled,
                                         Boolean oauth2DeviceAuthorizationGrantEnabled, Boolean authorizationServicesEnabled,
                                         Boolean directGrantsOnly, Boolean publicClient, Boolean frontchannelLogout, String protocol,
                                         Map<String, String> attributes, Map<String, String> authenticationFlowBindingOverrides,
                                         Boolean fullScopeAllowed, Integer nodeReRegistrationTimeout, Map<Integer, Integer> registeredNodes,
                                         List<ProtocolMapperRepresentation> protocolMappers, String clientTemplate, Boolean useTemplateConfig,
                                         Boolean useTemplateScope, Boolean useTemplateMappers, List<String> defaultClientScopes,
                                         List<String> optionalClientScopes,
                                         Boolean access, String origin){}

    static Function<String, ClientRepresentation> clientRepresentationFunction(ClientRepresentation template){
        return clientName -> {
            ClientRepresentation clientRepresentation = new ClientRepresentation();
            BeanUtils.copyProperties(template, clientRepresentation);
            clientRepresentation.setClientId(clientName);
            clientRepresentation.setName(clientName);
            clientRepresentation.setDescription("Client for "+clientName);
            clientRepresentation.setSecret(generateRandomSpecialCharacters(16));
            return clientRepresentation;
        };
    }

    public List<UserRepresentation> findUsersListFromRealm(String realmName){
        return keycloak.realm(realmName).users().list();
    }

    public Flux<UserRepresentation> findUsersFromRealm(String realmName){
        return Flux.fromIterable(findUsersListFromRealm(realmName)).publishOn(Schedulers.boundedElastic());
    }

    public void createRealmFromContextEntity(ContextEntity contextEntity) {

        logger.info("Got ContextEntity {} in createRealmFromContextEntity", contextEntity.getContextId());
        RealmRepresentation realmRepresentation = null;
        try{


            realmRepresentation = realmRepresentationFunction(keyCloakIdpProperties).apply(contextEntity.getContextId());
            keycloak.realms().create(realmRepresentation);

        } catch (Exception cex){
            logger.warn("Could not create realm {}", realmRepresentation.getRealm(),cex);
        }

        try{
            RealmResource realm =   keycloak.realm(contextEntity.getContextId());
            String realmName = realm.toRepresentation().getRealm();
            logger.info("Acquired realm {} for creating client {}",realmName, contextEntity.getContextId());
            Optional<ClientRepresentation> clientRepresentationOptional = realm.clients().findAll().stream()
                    .filter(cr -> cr.getClientId().equals(contextEntity.getContextId()))
                    .findAny();
            if (!clientRepresentationOptional.isPresent()){
                ClientRepresentation clientRepresentation = clientRepresentationFunction(template).apply(contextEntity.getContextId());
                    /*clientRepresentation.setServiceAccountsEnabled(Boolean.FALSE);
                    clientRepresentation.setAuthorizationServicesEnabled(Boolean.FALSE);
                    clientRepresentation.setImplicitFlowEnabled(Boolean.FALSE);
                    clientRepresentation.setDirectAccessGrantsEnabled(Boolean.FALSE);
                    clientRepresentation.setImplicitFlowEnabled(Boolean.FALSE);*/
                Response response = realm.clients().create(clientRepresentation);
                logger.info("From client {} Got client create response status {}",clientRepresentation.getClientId(),response.getStatus());
            } else {
                logger.info("{} client in realm {} exists not creating client", contextEntity.getContextId(),realmName );
            }

        } catch (Exception cex){
            logger.warn("Could not create client {}", contextEntity.getContextId(),cex);
        }

        //logger.info("################### From client {} ", ContextEntity.getContextId());
        try{
            RealmResource realm =   keycloak.realm(contextEntity.getContextId());
            logger.info("Acquired realm {} for updating client {}",realm.toRepresentation().getRealm(), contextEntity.getContextId());

            String serviceAccountName = calculateServiceAccountName().apply(contextEntity.getContextId());
            List<UserRepresentation> users = realm.users().search(serviceAccountName);


            if (users.isEmpty()){
                Response userCreateResponse =  realm.users().create(createServiceAccount(contextEntity));
                logger.info("################### From client {} Got user create response status {}", contextEntity.getContextId(),userCreateResponse.getStatus());
            } else {
                logger.info("user {} exists in client {} not creating user",serviceAccountName, contextEntity.getContextId());
            }

            Optional<ClientRepresentation> clientRepresentationOptional = realm.clients().findAll()
                    .stream()
                    .peek(cr -> logger.info("Found clients with id {}",cr.getClientId()))
                    .filter(cr -> cr.getClientId().equals(contextEntity.getContextId()))
                    .findAny();

            ClientRepresentation foundClientRepresentation = null;

            if (clientRepresentationOptional.isPresent()){
                foundClientRepresentation = clientRepresentationOptional.get();
                //ClientRepresentation clientRepresentation = clientResource.toRepresentation();
                //foundClientRepresentation.setAuthorizationServicesEnabled(Boolean.TRUE);
                foundClientRepresentation.setDirectAccessGrantsEnabled(Boolean.TRUE);
                foundClientRepresentation.setImplicitFlowEnabled(Boolean.TRUE);
                foundClientRepresentation.setServiceAccountsEnabled(Boolean.FALSE);
                foundClientRepresentation.setPublicClient(Boolean.FALSE);
                foundClientRepresentation.setSecret(RandomPasswordGenerator.generateCommonsLang3Password(36));

                ClientRepresentation cr = new ClientRepresentation();
                cr.setAuthorizationServicesEnabled(Boolean.TRUE);
                cr.setDirectAccessGrantsEnabled(Boolean.TRUE);
                cr.setImplicitFlowEnabled(Boolean.TRUE);
                cr.setServiceAccountsEnabled(Boolean.FALSE);
                cr.setPublicClient(Boolean.FALSE);
                cr.setId(foundClientRepresentation.getId());

                Optional<UserRepresentation>  foundUserOptional = realm.users().search(serviceAccountName).stream()
                        .filter(user -> user.getUsername().equals(serviceAccountName))
                        .findAny();

                updateClient(contextEntity.getContextId(), foundClientRepresentation).subscribe();

                /*
                try{
                    keycloak.realm(MASTER).users().get("admin-cli").roles().realmLevel().add(Collections.singletonList(keycloak.realm(MASTER).roles().get("admin").toRepresentation()));
                } catch (Exception cex){
                    logger.warn("Could not add admin role to admin-cli",cex);
                }

                 */

            }

        } catch (Exception cex){
            logger.warn("Could not update client {}", contextEntity.getContextId(),cex);
        }


    }

    static final Function<String, String> calculateServiceAccountName(){
        return ContextEntityId -> new StringBuilder("service-account-").append(ContextEntityId).toString();
    }

    static UserRepresentation createServiceAccount(ContextEntity ContextEntity){
        UserRepresentation userRepresentation = new UserRepresentation();
        userRepresentation.setEnabled(Boolean.TRUE);
        userRepresentation.setCreatedTimestamp(System.currentTimeMillis());
        //userRepresentation.setServiceAccountClientId(ContextEntity.getContextId());
        userRepresentation.setUsername(calculateServiceAccountName().apply(ContextEntity.getContextId()));
        //userRepresentation.setUsername(ContextEntity.getContextId() + "-user");
        userRepresentation.setId(UUID.randomUUID().toString());
        userRepresentation.setCredentials(generateUserCredentials(ContextEntity));
        return userRepresentation;
    }

    private static List<CredentialRepresentation> generateUserCredentials(ContextEntity ContextEntity) {
        CredentialRepresentation creds = new CredentialRepresentation();
        creds.setType(CredentialRepresentation.PASSWORD);
        creds.setValue("password");
        return Collections.singletonList(creds);
    }

    static  List<UserRepresentation> createServiceAccountList(ContextEntity ContextEntity) {
        return Collections.singletonList(createServiceAccount(ContextEntity));
    }

}
