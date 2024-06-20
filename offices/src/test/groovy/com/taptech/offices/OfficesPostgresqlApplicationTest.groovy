package com.taptech.offices

import com.taptech.common.EnableCommonConfig
import com.taptech.common.security.keycloak.EnableKeyCloak
import com.taptech.common.security.token.EnableTokenApi
import com.taptech.common.security.utils.SecurityUtils
import com.taptech.offices.model.Office
import com.taptech.offices.model.OfficePage
import com.taptech.offices.server.OfficesApi
import com.taptech.offices.server.OfficesApiController
import com.taptech.offices.service.OfficeEntity
import com.taptech.offices.service.OfficeRepository
import com.taptech.offices.service.OfficesConfiguration
import com.taptech.offices.service.OfficesServiceDelegate
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.autoconfigure.AutoConfigureAfter
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.ApplicationContext
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.Import
import org.springframework.test.web.reactive.server.WebTestClient
import org.springframework.web.server.ServerWebExchange
import org.testcontainers.containers.PostgreSQLContainer
import reactor.core.publisher.Mono
import reactor.test.StepVerifier
import spock.mock.DetachedMockFactory

@SpringBootTest(classes = [
        OfficesConfiguration.class,
        TestOfficeConfig.class],
        properties = [
                "spring.main.allow-bean-definition-overriding=true",
                "spring.data.jpa.repositories.enabled=true",
                "spring.profiles.active=secure",
                "spring.main.allow-bean-definition-overriding=true",
                "openapi.token.base-path=/",
                "openapi.office.base-path=/api/v1",
                "idp.provider.keycloak.initialize-on-startup=true",
                "idp.provider.keycloak.initialize-realms-on-startup=false",
                "idp.provider.keycloak.initialize-users-on-startup=true",
        ])
class OfficesPostgresqlApplicationTest extends BaseKeyCloakInfraStructure {

    private static final Logger logger = LoggerFactory.getLogger(OfficesPostgresqlApplicationTest.class);

    /*
    ./mvnw clean test -Dtest=OfficesPostgresqlApplicationTest
     */
    static String jdbcUrlFormat = "jdbc:postgresql://%s:%s/%s"
    static PostgreSQLContainer<?> container = createPostgresqlContainer()

    static PostgreSQLContainer createPostgresqlContainer() {
        PostgreSQLContainer container = new PostgreSQLContainer<>("postgres:15-alpine")

        return container

    }


    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {
        container.start()
        //String jdbcUrl = String.format(jdbcUrlFormat, container.getHost(), container.getMappedPort(5432), container.getDatabaseName());

        String jdbcUrl = container.getJdbcUrl()
        logger.info("JDBC URL: {}", jdbcUrl)
        System.setProperty("spring.datasource.url", jdbcUrl)
        System.setProperty("spring.datasource.username", container.getUsername())
        System.setProperty("spring.datasource.password", container.getPassword())
        System.setProperty("spring.datasource.driverClassName", "org.postgresql.Driver");
        System.setProperty("POSTGRES_URL", jdbcUrl)
        System.setProperty("POSRGRES_USER", container.getUsername())
        System.setProperty("POSRGRES_PASSWORD", container.getPassword());

    }     // run before the first feature method
    def cleanupSpec() {
        container.stop()
    }   // run after


    @Autowired
    OfficesServiceDelegate officesServiceDelegate

    @Autowired
    OfficeRepository officeRepository

    @Autowired
    IntegrationTestDataLoader integrationTestDataLoader

    @Autowired
    ApplicationContext applicationContext

    @Autowired
    WebTestClient webTestClient;


    @Autowired
    OfficesApiController officesApiController

    def testOffice() {
        String testOfficeName = "Test Office " + System.currentTimeMillis()
        Office office = new Office()
        office.setName(testOfficeName)
        office.setAddress("Test Address")
        office.setCity("Test City")
        office.setLatitude(0.0)
        office.setLongitude(0.0)
        office.state("Test State")
        return office
    }

    def changeOffice() {
        String uuid = UUID.randomUUID().toString();
        String testOfficeName = "Test Office " + uuid
        Office office = new Office()
        office.setName(testOfficeName)
        office.setAddress("Test Address " + uuid)
        office.setCity("Test City " + uuid)
        office.setLatitude(68.0)
        office.setLongitude(76.0)
        office.state("Test State " + uuid)
        return office
    }

    def test_config() {

        expect:
        officesServiceDelegate != null
        officeRepository.count() == 10
        webTestClient != null
        officesApiController != null

    }


    def should_create_office() {
        given: "an office instance"

        def serverWebExchange = Mock(ServerWebExchange)
        // setup your office instance
        Office office = testOffice()

        when: "office is created"
        def result = officesServiceDelegate.createOffice(Mono.just(office), serverWebExchange)

        then: "office is created successfully"
        result != null
        StepVerifier.create(result)
                .assertNext(ofRs -> {
                    ofRs != null
                    ofRs.getBody() != null
                    logger.info("Office created: {}", ofRs.getBody())
                    ofRs.getBody().getName() == office.getName()
                    ofRs.getBody().getId() != null
                    ofRs.getBody().getId() != office.getId()
                })
                .verifyComplete();
        // assertion for office creation
    }

    def should_delete_office_by_id() {
        given: "an office id"
        def serverWebExchange = Mock(ServerWebExchange)
        // setup your office instance
        Office office = testOffice()
        OfficeEntity officeEntityGiven = OfficesServiceDelegate.convertOfficeToOfficeEntity.apply(office)
        OfficeEntity officeEntity = officeRepository.save(officeEntityGiven)

        when: "delete operation is performed"
        def result = officesServiceDelegate.deleteOfficeById(officeEntity.getId(), serverWebExchange)

        then: "office is deleted successfully"
        // assertion for office deletion
        result != null
        StepVerifier.create(result)
                .assertNext(ofRs -> {
                    ofRs != null
                    ofRs.getStatusCode().is2xxSuccessful()
                })
                .verifyComplete();
        officeRepository.findById(officeEntity.getId()).isEmpty()
    }

    def should_get_office_by_id() {

        given: "an office id"
        def serverWebExchange = Mock(ServerWebExchange)
        // setup your office instance
        Office office = testOffice()
        OfficeEntity officeEntityGiven = OfficesServiceDelegate.convertOfficeToOfficeEntity.apply(office)
        OfficeEntity officeEntity = officeRepository.save(officeEntityGiven)

        when: "delete operation is performed"
        def result = officesServiceDelegate.getOfficeById(officeEntity.getId(), serverWebExchange)

        then: "office is retrieved successfully"
        result != null
        StepVerifier.create(result)
                .assertNext(ofRs -> {
                    ofRs != null
                    ofRs.getBody() != null
                    logger.info("Office retrieved: {}", ofRs.getBody())
                    ofRs.getBody().getName() == office.getName()
                    ofRs.getBody().getId() == officeEntity.getId()
                })
                .verifyComplete();
    }


    def should_get_offices() {

        given: "determine count"
        integrationTestDataLoader.load10TestData()
        def count = officeRepository.count()
        def serverWebExchange = Mock(ServerWebExchange)


        when: "get operation is performed"
        def result = officesServiceDelegate.getOffices(serverWebExchange)

        then: "offices are retrieved successfully"
        // assertion for office retrieval
        StepVerifier.create(result)
                .assertNext(ofRs -> {
                    ofRs != null
                    ofRs.getBody() != null
                    logger.info("Offices retrieved: {}", ofRs.getBody())
                    ofRs.getBody().getContent().size() == count
                })
                .verifyComplete();
    }

    def should_update_office_by_id() {
        given: "an office instance and id"
        def serverWebExchange = Mock(ServerWebExchange)
        // setup your office instance
        Office office = testOffice()
        OfficeEntity officeEntityGiven = OfficesServiceDelegate.convertOfficeToOfficeEntity.apply(office)
        OfficeEntity officeEntity = officeRepository.save(officeEntityGiven)
        Office updateOffice = changeOffice()

        when: "office is updated"
        def result = officesServiceDelegate.updateOfficeById(officeEntity.getId(), Mono.just(updateOffice), serverWebExchange)

        then: "office is updated successfully"
        // assertion for office update
        result != null
        StepVerifier.create(result)
                .assertNext(ofRs -> {
                    ofRs != null
                    ofRs.getBody() != null
                    logger.info("Office updated: {}", ofRs.getBody())
                    ofRs.getBody().getName() != office.getName()
                    ofRs.getBody().getId() != office.getId()
                })
                .verifyComplete();
        Optional<OfficeEntity> optionalOffice = officeRepository.findById(officeEntity.getId());
        optionalOffice.isPresent()
        OfficeEntity updatedOfficeEntity = optionalOffice.get()
        updatedOfficeEntity.getName() == updateOffice.getName()
        updatedOfficeEntity.getName() != office.getName()
    }

    def test_offices_delegate_builder() {
        def officesServiceDelegateBuilder = OfficesServiceDelegate.builder()
        def officeRepository = Mock(OfficeRepository)
        officesServiceDelegateBuilder.officeRepository(officeRepository)
        def officesServiceDelegate = officesServiceDelegateBuilder.build()

        expect:
        officesServiceDelegateBuilder != null
        officesServiceDelegateBuilder.toString() != null
    }

    def test_public_refresh_token() {

        given:
        def results = keyCloakAuthenticationManager.passwordGrantLoginMap(adminCC, "admin", OFFICES).toFuture().join()
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
        def results = keyCloakAuthenticationManager.passwordGrantLoginMap(adminCC, "admin", OFFICES).toFuture().join()
        def accessToken = results.get("access_token")

        expect:
        webTestClient.get().uri("/public/validate")
                .headers(headers -> {
                    headers.set("Authorization", SecurityUtils.toBearerHeaderFromToken(accessToken))
                })
                .exchange()
                .expectStatus().isOk()
                .expectBody()
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
                    headers.setBasicAuth(adminCC, "admin")
                })
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath(".access_token").isNotEmpty()
                .jsonPath(".refresh_token").isNotEmpty()
    }


    def test_get_offices() {

        given:
        def results = keyCloakAuthenticationManager.passwordGrantLoginMap(adminCC, "admin", OFFICES).toFuture().join()
        def accessToken = results.get("access_token")

        expect:
        webTestClient.get().uri("/api/v1/offices")
                .headers(headers -> {
                    headers.set("Authorization", SecurityUtils.toBearerHeaderFromToken(accessToken))
                })
                .exchange()
                .expectStatus().isOk()
                .expectBody(OfficePage.class)
                .consumeWith(result -> {
                    OfficePage officePage = result.getResponseBody()
                    logger.info("OfficePage: {}", officePage)
                    officeRepository.count() == officePage.getContent().size()
                });

    }

    def test_OfficesApi_getDelegate(){
        given:
        def officesApi = new OfficesApi() {

        }
        def delegate = officesApi.getDelegate()
        expect:
        delegate != null
    }


    @Configuration
    @AutoConfigureAfter(OfficesConfiguration.class)
    @EnableCommonConfig
    @Import(SecurityConfig.class)
    @EnableKeyCloak
    @EnableTokenApi
    public static class TestOfficeConfig {


        TestOfficeConfig() {
            logger.info("####################### TestOfficeConfig created");
        }
        DetachedMockFactory mockFactory = new DetachedMockFactory()


        @Bean
        IntegrationTestDataLoader integrationTestDataLoader(OfficeRepository officeRepository) {
            IntegrationTestDataLoader loader = new IntegrationTestDataLoader(officeRepository)
            loader.load10TestData()
            return loader
        }

        @Bean
        WebTestClient webTestClient(ApplicationContext applicationContext) {
            return WebTestClient.bindToApplicationContext(applicationContext).build()
        }

    }
}