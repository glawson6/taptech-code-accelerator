package com.taptech.common.security.keycloak;

import com.taptech.common.security.ContextEntity;
import com.taptech.common.security.RoleEntity;
import com.taptech.common.security.UserEntity;
import com.taptech.common.security.user.UserContextPermissionsService;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.representations.idm.RealmRepresentation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;

import javax.annotation.PostConstruct;
import java.io.IOException;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Builder
@NoArgsConstructor
@AllArgsConstructor
public class KeyCloakInitializer {

    private static final Logger logger = LoggerFactory.getLogger(KeyCloakInitializer.class);
    private static final String INIT_KEYCLOAK_USERS_PATH = "users/init-keycloak-users.json";
    private static final String INIT_KEYCLOAK_ROLES_PATH = "users/init-keycloak-roles.json";

    Keycloak keycloak;
    KeyCloakIdpProperties keyCloakIdpProperties;
    @Builder.Default
    ObjectMapper objectMapper = new ObjectMapper();
    KeyCloakManagementService keyCloakManagementService;
    @Builder.Default
    String initKeycloakUsersPath = INIT_KEYCLOAK_USERS_PATH;
    @Builder.Default
    String initKeycloakRolesPath = INIT_KEYCLOAK_ROLES_PATH;
    @Builder.Default
    Boolean initializeOnStartup = Boolean.FALSE;
    @Builder.Default
    Boolean initializeUsersOnStartup = Boolean.FALSE;
    @Builder.Default
    Boolean initializeRealmsOnStartup = Boolean.FALSE;
    UserContextPermissionsService userContextPermissionsService;
    private static String REALM_ID;
    static final Set<String> ADMIN = Set.of("read", "delete", "update", "create");
    static final Set<String> USER = Set.of("read");

    @PostConstruct
    public void afterPropertiesSet() throws Exception {

        REALM_ID = keyCloakIdpProperties.realm();

        if (initializeOnStartup) {
            init(false);
        }

        logger.info("Got keycloak properties: {}", keyCloakIdpProperties);
    }

    public void init(boolean overwrite) {

        logger.info("Initializer start");

        List<RealmRepresentation> realms = keycloak.realms().findAll();
        boolean isAlreadyInitialized = realms.stream().anyMatch(realm -> realm.getId().equals(REALM_ID));

        logger.info("isAlreadyInitialized => {}, overwrite => {}, (isAlreadyInitialized && overwrite) => {}", isAlreadyInitialized, overwrite, (isAlreadyInitialized && overwrite));
        if (isAlreadyInitialized && overwrite) {
            reset();
        }

        initKeycloak();

    }

    private void initKeycloak() {
        if (initializeRealmsOnStartup) {
            initKeycloakRealm();
        }

        if (initializeUsersOnStartup) {
            initKeycloakUsers();
        }
    }

    private void initKeycloakRealm() {

        try {
            ContextEntity context = ContextEntity.builder()
                    .contextId(REALM_ID)
                    .contextName(REALM_ID)
                    .name(REALM_ID)
                    .build();
            keyCloakManagementService.createRealmFromContextEntity(context);
        } catch (Exception e) {
            logger.warn("initKeycloakRealm Error creating realm", e);
        }

    }

    private void initKeycloakUsers() {

        try {
            List<UserEntity> users = loadUserEntitiesFromClassPath(objectMapper).apply(initKeycloakUsersPath);
            Map<String, RoleEntity> roleEntityMap = loadRoleEntitiesFromClassPath(objectMapper).apply(initKeycloakRolesPath);
            logger.debug("initKeycloakUsers. Read {} users and {} roles", users.size(), roleEntityMap.size());
            users.stream().forEach(userEntity -> {
                keyCloakManagementService.postUserToKeyCloakSync(userEntity);
                Set<String> permissions = roleEntityMap.entrySet().stream()
                        .filter(entry -> userEntity.getRoleId().equals(entry.getKey()))
                        .map(Map.Entry::getValue)
                        .flatMap(roleEntity -> roleEntity.getPermissions().stream())
                        .collect(Collectors.toSet());
                permissions.add(userEntity.getRoleId());
                logger.debug("------------------Adding.permissions {} to user {}", permissions, userEntity.getEmail());
                userContextPermissionsService.addPermissions(userEntity.getEmail(), userEntity.getContextId(), userEntity.getRoleId(),permissions);
            });
        } catch (Exception e) {
            String errorMessage = String.format("Failed to read keycloak users : %s", e.getMessage());
            logger.error(errorMessage);
            throw new KeyCloakServiceException(errorMessage, e);
        }

    }

    Function<String, List<UserEntity>> loadUserEntitiesFromClassPath(ObjectMapper objectMapper) {
        return (path) -> {
            List<UserEntity> users;
            logger.debug("loadUserEntitiesFromClassPath. Reading keycloak users from {}", path);
            Resource resource = new ClassPathResource(path);
            try {
                users = objectMapper.readValue(resource.getInputStream(), objectMapper.getTypeFactory().constructCollectionType(ArrayList.class, UserEntity.class));
                logger.debug("loadUserEntitiesFromClassPath. Read {} users", users.size());
            } catch (IOException e) {
                logger.error("Failed to read keycloak users : {}", e.getMessage());
                throw new KeyCloakServiceException("Failed to read keycloak users", e);
            }
            return users;
        };
    }

    Function<String, Map<String, RoleEntity>> loadRoleEntitiesFromClassPath(ObjectMapper objectMapper) {
        return (path) -> {
            Map<String, RoleEntity> roleMap = Collections.emptyMap();

            try {
                logger.debug("loadRoleEntitiesFromClassPath. Reading keycloak roles from {}", path);
                Resource resource = new ClassPathResource(path);
                List<RoleEntity> roles = objectMapper.readValue(resource.getInputStream(), objectMapper.getTypeFactory().constructCollectionType(ArrayList.class, RoleEntity.class));
                logger.debug("loadRoleEntitiesFromClassPath. Read {} roles", roles.size());

                roleMap = roles.stream().collect(Collectors.toMap(RoleEntity::getRoleId, Function.identity()));
            } catch (IOException e) {
                logger.error("Failed to read keycloak roles : {}", e.getMessage());
                throw new KeyCloakServiceException("Failed to read keycloak roles", e);
            }
            return roleMap;
        };
    }

    public void reset() {
        try {
            keycloak.realm(REALM_ID).remove();
        } catch (Exception e) {
            logger.error("Failed to reset Keycloak", e);
        }
    }


}