package com.taptech.common.security.user

import com.taptech.common.EnableCommonConfig
import com.fasterxml.jackson.databind.ObjectMapper
import org.mockserver.client.MockServerClient
import org.mockserver.model.HttpRequest
import org.mockserver.model.HttpResponse
import org.mockserver.model.MediaType
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.testcontainers.containers.MockServerContainer
import org.testcontainers.utility.DockerImageName
import reactor.test.StepVerifier
import spock.lang.Specification
import spock.mock.DetachedMockFactory


@SpringBootTest(classes = [HttpReadTestConfig.class],
        properties = [
                "spring.main.allow-bean-definition-overriding=true",
                "idp.provider.keycloak.initialize-on-startup=true",
                "idp.provider.keycloak.initialize-realms-on-startup=true",
                "idp.provider.keycloak.initialize-users-on-startup=true"
        ])
class HttpReadingUserContextPermissionsServiceTest extends Specification {
    private static final Logger logger = LoggerFactory.getLogger(HttpReadingUserContextPermissionsServiceTest.class);

    public static final DockerImageName MOCKSERVER_IMAGE = DockerImageName
            .parse("mockserver/mockserver")


    static final Set<String> ADMIN = Set.of("read", "delete", "update", "create");
    static final Set<String> USER = Set.of("read");

    /*
    ./mvnw clean test -Dtest=HttpReadingUserContextPermissionsServiceTest
    ./mvnw clean test -Dtest=HttpReadingUserContextPermissionsServiceTest

     */

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {
    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    @Autowired
    MockServerClient mockServerClient

    @Autowired
    MockServerContainer mockServer

    @Autowired
    UserContextPermissions userContextPermissions

    def test_config() {
        expect:
        mockServerClient != null
        mockServer != null
        userContextPermissions != null
    }

    def test_getUserContextPermissions() {
        given:
        HttpReadingUserContextPermissionsService service = HttpReadingUserContextPermissionsService.builder()
                .baseUrl(mockServer.getEndpoint())
                .build()
        service.init()

        UserContextRequest userContextRequest = UserContextRequest.builder()
                .contextId("offices")
                .userId("admin@cc.com")
                .token("token")
                .build()

        when:
        def result = service.getUserContextByUserIdAndContextId(userContextRequest)

        then:
        result != null
        StepVerifier.create(result)
                .assertNext(userctx -> {
                    userctx != null
                    userctx instanceof UserContextPermissions
                    userctx.equals(userContextPermissions)

                })
                .verifyComplete()

    }

    @Configuration
    @EnableCommonConfig
    public static class HttpReadTestConfig {

        DetachedMockFactory mockFactory = new DetachedMockFactory()

        @Bean
        UserContextPermissions userContextPermissions(){
            return UserContextPermissions.builder()
                    .roleId("admin")
                    .username("admin@cc.com")
                    .contextId("offices")
                    .permissions(ADMIN)
                    .build();
        }

        @Bean
        MockServerContainer mockServer() {
            MockServerContainer mockServer = new MockServerContainer(MOCKSERVER_IMAGE);
            mockServer.start();
            return mockServer
        }

        @Bean
        MockServerClient mockServerClient(MockServerContainer mockServer,
                                          UserContextPermissions userContextPermissions) {

            MockServerClient mockServerClient = new MockServerClient(mockServer.getHost(), mockServer.getServerPort())
            ObjectMapper objectMapper = new ObjectMapper();
            String body = objectMapper.writeValueAsString(userContextPermissions);
            mockServerClient.when(HttpRequest.request().withPath("/public/validate"))
                    .respond(HttpResponse.response()
                            .withContentType(MediaType.APPLICATION_JSON)
                            .withBody(body));
            return mockServerClient;
        }

    }

}
