package com.taptech.offices


import com.taptech.common.security.keycloak.KeyCloakIdpProperties
import com.taptech.common.security.user.UserContextPermissionsService
import com.taptech.common.security.keycloak.KeyCloakAuthenticationManager
import com.taptech.common.security.keycloak.KeyCloakConstants
import com.taptech.common.security.keycloak.KeyCloakJwtDecoderFactory
import com.taptech.common.security.keycloak.KeyCloakManagementService
import dasniko.testcontainers.keycloak.KeycloakContainer
import org.keycloak.admin.client.Keycloak
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.testcontainers.containers.Network
import org.testcontainers.containers.PostgreSQLContainer
import org.testcontainers.containers.output.Slf4jLogConsumer
import org.testcontainers.containers.wait.strategy.ShellStrategy
import org.testcontainers.utility.MountableFile
import spock.lang.Shared
import spock.lang.Specification

import java.time.Duration
import java.time.temporal.ChronoUnit

class BaseKeyCloakInfraStructure extends Specification{

    private static final Logger logger = LoggerFactory.getLogger(BaseKeyCloakInfraStructure.class);

    static String jdbcUrlFormat = "jdbc:postgresql://%s:%s/%s"
    static String keycloakBaseUrlFormat = "http://%s:%s"
    public static final String OFFICES = "offices";
    public static final String POSTGRES_NETWORK_ALIAS = "postgres";

    @Shared
    static Network network = Network.newNetwork();
    @Shared
    static PostgreSQLContainer<?> postgres = createPostgresqlContainer()
    public static final String KEYCLOAK = "keycloak"

    static PostgreSQLContainer createPostgresqlContainer() {
        PostgreSQLContainer container = new PostgreSQLContainer<>("postgres")
                .withNetwork(network)
                .withNetworkAliases(POSTGRES_NETWORK_ALIAS)
                .withCopyFileToContainer(MountableFile.forClasspathResource("postgres/keycloak-dump.sql"), "/docker-entrypoint-initdb.d/keycloak-dump.sql")
                .withUsername(KEYCLOAK)
                .withPassword(KEYCLOAK)
                .withDatabaseName(KEYCLOAK)
                .withLogConsumer(new Slf4jLogConsumer(logger))
                .waitingFor(new ShellStrategy()
                        .withCommand(
                                "psql -q -o /dev/null -c \"SELECT 1\" -d keycloak -U keycloak")
                        .withStartupTimeout(Duration.of(60, ChronoUnit.SECONDS)))
        return container

    }

    @Shared
    public static KeycloakContainer keycloakContainer;

    @Shared
    static String adminCC = "admin@cc.com"

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {
        postgres.start()
        String jdbcUrl = String.format(jdbcUrlFormat, POSTGRES_NETWORK_ALIAS, 5432, postgres.getDatabaseName());


        keycloakContainer = new KeycloakContainer("quay.io/keycloak/keycloak:23.0.6")
                .withNetwork(network)
                .withExposedPorts(8080)
                .withEnv("KC_HOSTNAME", "localhost")
                .withEnv("KC_HOSTNAME_PORT", "8080")
                .withEnv("KC_HOSTNAME_STRICT_BACKCHANNEL", "false")
                .withEnv("KC_HTTP_ENABLED", "true")
                .withEnv("KC_HOSTNAME_STRICT_HTTPS", "false")
                .withEnv("KC_HEALTH_ENABLED", "true")
                .withEnv("KEYCLOAK_ADMIN", "admin")
                .withEnv("KEYCLOAK_ADMIN_PASSWORD", "admin")
                .withEnv("KC_DB", "postgres")
                .withEnv("KC_DB_URL", jdbcUrl)
                .withEnv("KC_DB_USERNAME", KEYCLOAK)
                .withEnv("KC_DB_PASSWORD", KEYCLOAK)

        keycloakContainer.start()

        String authServerUrl = keycloakContainer.getAuthServerUrl();
        String adminUsername = keycloakContainer.getAdminUsername();
        String adminPassword = keycloakContainer.getAdminPassword();


        logger.info("Keycloak getExposedPorts: {}", keycloakContainer.getExposedPorts())
        String keycloakBaseUrl = String.format(keycloakBaseUrlFormat, keycloakContainer.getHost(), keycloakContainer.getMappedPort(8080));
        //String keycloakBaseUrl = "http://localhost:8080"
        logger.info("Keycloak authServerUrl: {}", authServerUrl)
        logger.info("Keycloak URL: {}", keycloakBaseUrl)
        logger.info("Keycloak adminUsername: {}", adminUsername)
        logger.info("Keycloak adminPassword: {}", adminPassword)
        logger.info("JDBC URL: {}", jdbcUrl)
        System.setProperty("spring.datasource.url", jdbcUrl)
        System.setProperty("spring.datasource.username", postgres.getUsername())
        System.setProperty("spring.datasource.password", postgres.getPassword())
        System.setProperty("spring.datasource.driverClassName", "org.postgresql.Driver");
        System.setProperty("POSTGRES_URL", jdbcUrl)
        System.setProperty("POSRGRES_USER", postgres.getUsername())
        System.setProperty("POSRGRES_PASSWORD", postgres.getPassword());
        System.setProperty("idp.provider.keycloak.base-url", authServerUrl)
        System.setProperty("idp.provider.keycloak.admin-client-secret", "DCRkkqpUv3XlQnosjtf8jHleP7tuduTa")
        System.setProperty("idp.provider.keycloak.admin-client-id", KeyCloakConstants.ADMIN_CLI)
        System.setProperty("idp.provider.keycloak.admin-username", adminUsername)
        System.setProperty("idp.provider.keycloak.admin-password", adminPassword)
        System.setProperty("idp.provider.keycloak.default-context-id", OFFICES)
        System.setProperty("idp.provider.keycloak.client-secret", "x9RIGyc7rh8A4w4sMl8U5rF3HuNm2wOC3WOD")
        System.setProperty("idp.provider.keycloak.client-id", OFFICES)
        System.setProperty("idp.provider.keycloak.token-uri", "/realms/offices/protocol/openid-connect/token")
        System.setProperty("idp.provider.keycloak.jwkset-uri", authServerUrl + "/realms/offices/protocol/openid-connect/certs")
        System.setProperty("idp.provider.keycloak.issuer-url", authServerUrl + "/realms/offices")

        System.setProperty("idp.provider.keycloak.admin-token-uri", "/realms/master/protocol/openid-connect/token")

        System.setProperty("idp.provider.keycloak.user-uri", "/admin/realms/{realm}/users")
        System.setProperty("idp.provider.keycloak.use-strict-jwt-validators", "false")


    }     // run before the first feature method
    def cleanupSpec() {
        keycloakContainer.stop()
        postgres.stop()
    }   // run after

    @Autowired
    Keycloak keycloak

    @Autowired
    KeyCloakAuthenticationManager keyCloakAuthenticationManager

    @Autowired
    UserContextPermissionsService userContextPermissionsService

    @Autowired
    KeyCloakManagementService keyCloakService

    @Autowired
    KeyCloakIdpProperties keyCloakIdpProperties

    @Autowired
    KeyCloakJwtDecoderFactory keyCloakJwtDecoderFactory

    def test_config() {
        expect:
        keycloak != null
        keyCloakAuthenticationManager != null
        keyCloakService != null
    }

    /*
    def setUpUsers() {
        String username = "admin"
        String realm = "master" // KeyCloakConstants.MASTER
        userContextPermissionsService.addPermissions("admin", OFFICES, Set.of("ADMIN"));
        userContextPermissionsService.addPermissions("admin@cc.com", OFFICES, Set.of("ADMIN"));
        userContextPermissionsService.addPermissions("user@cc.com", OFFICES, Set.of("USER"));
        userContextPermissionsService.addPermissions("user", OFFICES, Set.of("USER"));

        //logSomeStuff(OFFICES)

        ContextEntity context = ContextEntity.builder()
                .contextId(OFFICES)
                .contextName(OFFICES)
                .name(OFFICES)
                .build();

        keyCloakManagementService.createRealmFromContextEntity(context);
        UserEntity userEntity1 = UserEntity.builder()
                .contextId(OFFICES)
                .email(adminCC)
                .password("admin")
                .build();
        UserEntity userEntity2 = UserEntity.builder()
                .contextId(OFFICES)
                .email("user@cc.com")
                .password("user")
                .build();

        keyCloakManagementService.postUserToKeyCloak(userEntity1).subscribe(
                responseEntity -> {
                    logger.info("UserEntity1: {}", responseEntity.getBody());
                }
        );
        keyCloakManagementService.postUserToKeyCloak(userEntity2).subscribe(
                responseEntity -> {
                    logger.info("UserEntity2: {}", responseEntity.getBody());
                }
        );


        keyCloakManagementService.findUsersFromRealm(OFFICES)
                .subscribe(users -> logger.info(OFFICES + " Users: {}", users.getUsername()))
        keyCloakManagementService.findUsersFromRealm(KeyCloakConstants.MASTER)
                .subscribe(users -> logger.info(KeyCloakConstants.MASTER + " Users: {}", users.getUsername()))


    }

     */

    static String basicAuthCredsFrom(String s1, String s2) {
        return "Basic " + toBasicAuthCreds(s1, s2);
    }

    static toBasicAuthCreds(String s1, String s2) {
        return Base64.getEncoder().encodeToString((s1 + ":" + s2).getBytes());
    }


}
