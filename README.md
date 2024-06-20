

# Taptech-Code-Accelerator

This is the parent project for the taptech-code-accelerator modules. It's responsible for managing common dependencies and configurations for all the child modules.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- You have installed Java 21. If not, you can download it from [here](https://www.oracle.com/java/technologies/javase-jdk21-downloads.html).
- You have a basic understanding of Maven and Java.

## Building taptech-code-accelerator

To build the `taptech-code-accelerator` project, follow these steps:

1. Open a terminal.

2. Change the current directory to the root directory of the `taptech-code-accelerator` project:

```bash
cd path/to/taptech-code-accelerator
```

3. Run the following command to build the project:

```bash
./build.sh
```

This command cleans the project, compiles the source code, runs any tests, packages the compiled code into a JAR or WAR file, 
and installs the packaged code in your local Maven repository. It also builds the local docker image that will be used run later

Please ensure you have the necessary permissions to execute these commands.


## Introduction
In today's security landscape, OAuth2 has become a standard for securing APIs, providing a more robust and flexible approach 
compared to basic authentication. My journey into this domain began with a critical solution architecture decision: migrating 
from basic authentication to OAuth2 client credentials for obtaining access tokens. While Spring Security offers strong 
support for both authentication methods, I encountered a significant challenge. I was unable to find a declarative approach 
that seamlessly integrated basic authentication and JWT authentication within the same application.

This gap in functionality motivated me to explore and develop a solution that not only meets the authentication requirements 
but also supports comprehensive integration testing. This article shares my findings and provides a detailed guide on setting 
up Keycloak, integrating it with Spring Security and Spring Boot, and utilizing the Spock Framework for repeatable unit tests. 
By the end of this article, you will have a clear understanding of how to configure and test your authentication mechanisms 
effectively with Keycloak as an identity provider, ensuring a smooth transition to OAuth2 while maintaining the flexibility 
to support basic authentication where necessary.

### Keycloak Initial Setup

Setting up Keycloak for integration testing involves several steps. This guide will walk you through creating a local environment 
configuration, starting Keycloak with Docker, configuring realms and clients, verifying the setup, and preparing a 
PostgreSQL dump for your integration tests.

#### Step 1: Create a `local.env` File

First, create a `local.env` file to store environment variables needed for the Keycloak service. Here's an example of what the `local.env` file might look like:

```env
KEYCLOAK_USER=admin
KEYCLOAK_PASSWORD=admin
DB_VENDOR=POSTGRES
DB_ADDR=keycloak-db
DB_DATABASE=keycloak
DB_USER=keycloak
DB_PASSWORD=keycloak
```

#### Step 2: Start the Keycloak Service

Next, start the Keycloak service using the provided `docker-compose.yml` file and the `./start-services.sh` script. The `docker-compose.yml` file should define the Keycloak and PostgreSQL services.

```yaml
version: '3.7'

services:
   postgres:
      image: postgres:16.2
      volumes:
         - postgres_data:/var/lib/postgresql/data
      environment:
         POSTGRES_DB: ${POSTGRES_DB}
         POSTGRES_USER: ${POSTGRES_USER}
         POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      #    ports:
      #      - 5432:5432
      networks:
         - keycloak_network

   keycloak:
      image: quay.io/keycloak/keycloak:23.0.6
      command: start
      environment:
         KC_HOSTNAME: localhost
         KC_HOSTNAME_PORT: 8080
         KC_HOSTNAME_STRICT_BACKCHANNEL: false
         KC_HTTP_ENABLED: true
         KC_HOSTNAME_STRICT_HTTPS: false
         KC_HEALTH_ENABLED: true
         KEYCLOAK_ADMIN: ${KEYCLOAK_ADMIN}
         KEYCLOAK_ADMIN_PASSWORD: ${KEYCLOAK_ADMIN_PASSWORD}
         KC_DB: postgres
         KC_DB_URL: jdbc:postgresql://postgres/${POSTGRES_DB}
         KC_DB_USERNAME: ${POSTGRES_USER}
         KC_DB_PASSWORD: ${POSTGRES_PASSWORD}
      ports:
         - 8080:8080
      restart: always
      depends_on:
         - postgres
      networks:
         - keycloak_network

volumes:
   postgres_data:
      driver: local

networks:
   keycloak_network:
      driver: host


```

Then, use the `./start-services.sh` script to start the services:

```bash
#!/bin/bash
docker-compose up -d
```

#### Step 3: Access Keycloak Admin Console

Once Keycloak has started, log in to the admin console at [http://localhost:8080](http://localhost:8080) using the configured admin username and password (default is `admin`/`admin`).

#### Step 4: Create a Realm and Client

1. **Create a Realm**:
    - Log in to the Keycloak admin console.
    - In the left-hand menu, click on "Add Realm".
    - Enter the name of the realm (e.g., `myrealm`) and click "Create".

2. **Create a Client**:
    - Select your newly created realm from the left-hand menu.
    - Click on "Clients" in the left-hand menu.
    - Click on "Create" in the right-hand corner.
    - Enter the client ID (e.g., `myclient`), choose `openid-connect` as the client protocol, and click "Save".
    - Set the "Access Type" to `confidential`.
    - Set the "Valid Redirect URIs" and "Web Origins" as needed.
    - Click "Save".

#### Step 5: Verify the Setup with HTTP Requests

To verify the setup, you can use HTTP requests to obtain tokens.

1. **Get Access Token**:

   ```bash
   curl -X POST "http://localhost:8080/realms/myrealm/protocol/openid-connect/token" \
   -H "Content-Type: application/x-www-form-urlencoded" \
   -d "username=myuser" \
   -d "password=mypassword" \
   -d "grant_type=password" \
   -d "client_id=myclient" \
   -d "client_secret=your_client_secret"
   ```

2. **Verify the Token**:
    - Ensure you receive a JSON response with an `access_token`.

#### Step 6: Create a PostgreSQL Dump

After verifying the setup, create a PostgreSQL dump of the Keycloak database to use for seeding the database during integration tests.

1. **Create the Dump**:
```bash
docker exec -i docker-postgres-1 /bin/bash -c "PGPASSWORD=keycloak pg_dump --username keycloak keycloak" > dump/keycloak-dump.sql
   ```

2. **Save the File**:
    - Save the `keycloak-dump.sql` file locally. This file will be used to seed the database for integration tests.

By following these steps, you will have a Keycloak instance configured and ready for integration testing with Spring Security and the Spock Framework.

### Spring Security and Keycloak Integration Tests

In this section, we will set up integration tests for Spring Security and Keycloak using Spock and Testcontainers. This involves configuring dependencies, setting up Testcontainers for Keycloak and PostgreSQL, and creating a base class to hold the necessary configurations.

#### Step 1: Add Dependencies

First, add the necessary dependencies to your `pom.xml` file. Ensure that Spock, Testcontainers for Keycloak and PostgreSQL, and other required libraries are included.
[check here](https://github.com/glawson6/taptech-code-accelerator/blob/511986ba28aa3f653f9c79b4b5d50cbaf9b4f645/offices/pom.xml#L94-L201)


#### Step 2: Create the Base Test Class

Create a base class to hold the configuration for your integration tests.

```groovy
package com.taptech.common.security.keycloak


import com.taptech.common.security.user.InMemoryUserContextPermissionsService
import com.fasterxml.jackson.databind.ObjectMapper
import dasniko.testcontainers.keycloak.KeycloakContainer
import org.keycloak.admin.client.Keycloak
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.testcontainers.containers.Network
import org.testcontainers.containers.PostgreSQLContainer
import org.testcontainers.containers.output.Slf4jLogConsumer
import org.testcontainers.containers.wait.strategy.ShellStrategy
import org.testcontainers.utility.DockerImageName
import org.testcontainers.utility.MountableFile
import spock.lang.Shared
import spock.lang.Specification
import spock.mock.DetachedMockFactory

import java.time.Duration
import java.time.temporal.ChronoUnit


class BaseKeyCloakInfraStructure extends Specification {

   private static final Logger logger = LoggerFactory.getLogger(BaseKeyCloakInfraStructure.class);

   static String jdbcUrlFormat = "jdbc:postgresql://%s:%s/%s"
   static String keycloakBaseUrlFormat = "http://%s:%s"
   public static final String OFFICES = "offices";
   public static final String POSTGRES_NETWORK_ALIAS = "postgres";

   @Shared
   static Network network = Network.newNetwork();
   @Shared
   static PostgreSQLContainer<?> postgres = createPostgresqlContainer()

   protected static PostgreSQLContainer createPostgresqlContainer() {
      PostgreSQLContainer container = new PostgreSQLContainer<>("postgres")
              .withNetwork(network)
              .withNetworkAliases(POSTGRES_NETWORK_ALIAS)
              .withCopyFileToContainer(MountableFile.forClasspathResource("postgres/keycloak-dump.sql"), "/docker-entrypoint-initdb.d/keycloak-dump.sql")
              .withUsername("keycloak")
              .withPassword("keycloak")
              .withDatabaseName("keycloak")
              .withLogConsumer(new Slf4jLogConsumer(logger))
              .waitingFor(new ShellStrategy()
                      .withCommand(
                              "psql -q -o /dev/null -c \"SELECT 1\" -d keycloak -U keycloak")
                      .withStartupTimeout(Duration.of(60, ChronoUnit.SECONDS)))


      return container

   }

   public static final DockerImageName KEYCLOAK_IMAGE = DockerImageName.parse("bitnami/keycloak:23.0.5");

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
              .withEnv("KC_DB_USERNAME", "keycloak")
              .withEnv("KC_DB_PASSWORD", "keycloak")

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
   InMemoryUserContextPermissionsService userContextPermissionsService

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

   static String basicAuthCredsFrom(String s1, String s2) {
      return "Basic " + toBasicAuthCreds(s1, s2);
   }

   static toBasicAuthCreds(String s1, String s2) {
      return Base64.getEncoder().encodeToString((s1 + ":" + s2).getBytes());
   }


   @Configuration
   @EnableKeyCloak
   public static class TestConfig {

      @Bean
      ObjectMapper objectMapper() {
         return new ObjectMapper();
      }

      DetachedMockFactory mockFactory = new DetachedMockFactory()

   }

}

```
In the `BaseKeyCloakInfraStructure` class, a method named `createPostgresqlContainer()` is used to set up a PostgreSQL 
test container. This method configures the container with various settings, including network settings, username, password, 
and database name. This class setups the entire Postgresql and Keycloak env. One of the key steps in this method is the 
use of a PostgreSQL dump file to populate the database with initial data. This is done using the `withCopyFileToContainer()` 
method, which copies a file from the classpath to a specified location within the container.

If you hvae problems starting, you might need to restart the dokcer compose file and extract the client secret.
This is explained in [EXTRACTING-ADMIN-CLI-CLIENT-SECRET](EXTRACTING-ADMIN-CLI-CLIENT-SECRET.md)

```bash

The code snippet for this is:

```groovy
.withCopyFileToContainer(MountableFile.forClasspathResource("postgres/keycloak-dump.sql"), "/docker-entrypoint-initdb.d/keycloak-dump.sql")
```
#### Step 3.  Extend the Base class end run your tests

```groovy
package com.taptech.common.security.token

import com.taptech.common.EnableCommonConfig
import com.taptech.common.security.keycloak.BaseKeyCloakInfraStructure
import com.taptech.common.security.keycloak.EnableKeyCloak
import com.taptech.common.security.keycloak.KeyCloakAuthenticationManager
import com.taptech.common.security.user.UserContextPermissions
import com.taptech.common.security.utils.SecurityUtils
import com.fasterxml.jackson.databind.ObjectMapper
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.reactive.WebFluxTest
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.oauth2.client.registration.InMemoryReactiveClientRegistrationRepository
import org.springframework.test.context.ContextConfiguration
import org.springframework.test.web.reactive.server.EntityExchangeResult
import org.springframework.test.web.reactive.server.WebTestClient
import spock.mock.DetachedMockFactory

import org.springframework.boot.autoconfigure.security.reactive.ReactiveSecurityAutoConfiguration

@ContextConfiguration(classes = [TestApiControllerConfig.class])
@WebFluxTest(/*controllers = [TokenApiController.class],*/
        properties = [
                "spring.main.allow-bean-definition-overriding=true",
                "openapi.token.base-path=/",
                "idp.provider.keycloak.initialize-on-startup=true",
                "idp.provider.keycloak.initialize-realms-on-startup=false",
                "idp.provider.keycloak.initialize-users-on-startup=true",
        "spring.test.webtestclient.base-url=http://localhost:8888"
        ], excludeAutoConfiguration = ReactiveSecurityAutoConfiguration.class)
class TokenApiControllerTest extends BaseKeyCloakInfraStructure {

    private static final Logger logger = LoggerFactory.getLogger(TokenApiControllerTest.class);

    /*
    ./mvnw clean test -Dtest=TokenApiControllerTest
    ./mvnw clean test -Dtest=TokenApiControllerTest#test_public_validate

     */

    @Autowired
    TokenApiApiDelegate tokenApiDelegate

    @Autowired
    KeyCloakAuthenticationManager keyCloakAuthenticationManager


    @Autowired
    private WebTestClient webTestClient


    @Autowired
    TokenApiController tokenApiController
    InMemoryReactiveClientRegistrationRepository clientRegistrationRepository

    def test_configureToken() {
        expect:
        tokenApiDelegate

    }

    def test_public_jwkkeys() {

        expect:
        webTestClient.get().uri("/public/jwkKeys")
                .exchange()
                .expectStatus().isOk()
                .expectBody()
    }


    def test_public_login() {

        expect:
        webTestClient.get().uri("/public/login")
                .headers(headers -> {
                    headers.setBasicAuth(BaseKeyCloakInfraStructure.adminCC, "admin")
                })
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath(".access_token").isNotEmpty()
                .jsonPath(".refresh_token").isNotEmpty()
    }

    def test_public_login_401() {

        expect:
        webTestClient.get().uri("/public/login")
                .headers(headers -> {
                    headers.setBasicAuth(BaseKeyCloakInfraStructure.adminCC, "bad")
                })
                .exchange()
                .expectStatus().isUnauthorized()
    }

    def test_public_refresh_token() {

        given:
        def results = keyCloakAuthenticationManager.passwordGrantLoginMap(BaseKeyCloakInfraStructure.adminCC, "admin", OFFICES).toFuture().join()
        def refreshToken = results.get("refresh_token")

        expect:
        webTestClient.get().uri("/public/refresh")
                .headers(headers -> {
                    headers.set("Authorization", SecurityUtils.toBearerHeaderFromToken(refreshToken))
                    headers.set("contextId", OFFICES)
                })
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath(".access_token").isNotEmpty()
                .jsonPath(".refresh_token").isNotEmpty()
    }


    def test_public_validate() {

        given:
        def results = keyCloakAuthenticationManager.passwordGrantLoginMap(BaseKeyCloakInfraStructure.adminCC, "admin", OFFICES).toFuture().join()
        def accessToken = results.get("access_token")

        expect:
        EntityExchangeResult<UserContextPermissions> entityExchangeResult = webTestClient.get().uri("/public/validate")
                .headers(headers -> {
                    headers.set("Authorization", SecurityUtils.toBearerHeaderFromToken(accessToken))
                })
                .exchange()
                .expectStatus().isOk()
                .expectBody(UserContextPermissions.class)
                .returnResult()

        logger.info("entityExchangeResult: {}", entityExchangeResult.getResponseBody())


    }

    @Configuration
    @EnableCommonConfig
    @EnableKeyCloak
    @EnableTokenApi
    public static class TestApiControllerConfig {

        @Bean
        ObjectMapper objectMapper() {
            return new ObjectMapper();
        }

        DetachedMockFactory mockFactory = new DetachedMockFactory()

    }
}

```
With this setup, you have configured Testcontainers to run Keycloak and PostgreSQL within a Docker network, seeded the PostgreSQL database with a dump file, and created a base test class to manage the lifecycle of these containers. You can now write your integration tests extending this base class to ensure your Spring Security configuration works correctly with Keycloak.

