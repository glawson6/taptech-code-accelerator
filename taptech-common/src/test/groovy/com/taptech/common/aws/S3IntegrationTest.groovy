package com.taptech.common.aws

import com.fasterxml.jackson.databind.ObjectMapper
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.testcontainers.containers.localstack.LocalStackContainer
import org.testcontainers.utility.DockerImageName
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials
import software.amazon.awssdk.auth.credentials.AwsCredentials
import software.amazon.awssdk.auth.credentials.AwsCredentialsProvider
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.s3.S3Client
import spock.mock.DetachedMockFactory

@SpringBootTest(classes = [S3TestConfig.class],
        properties = [
                "spring.main.allow-bean-definition-overriding=true",
                "s3.enabled=true",
        ])
class S3IntegrationTest extends spock.lang.Specification {
    private static final Logger logger = LoggerFactory.getLogger(S3IntegrationTest.class);

    /*
    ./mvnw clean test -Dtest=S3IntegrationTest
     */

    static final String TEST_BUCKET_NAME = "test-bucket"

    static final String LOCALSTACK_IMAGE_NAME = "localstack/localstack"
    static DockerImageName localstackImage = DockerImageName.parse(LOCALSTACK_IMAGE_NAME);
    public static LocalStackContainer localstack = new LocalStackContainer(localstackImage)
            .withServices(LocalStackContainer.Service.S3);


    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
        localstack.stop()
    }   // run after

    @Autowired
    S3Helper s3Helper

    def test_config() {
        expect:
        s3Helper != null
    }

    def test_createBucket() {
        given:
        def bucketName = TEST_BUCKET_NAME

        when:
        def result = s3Helper.createBucket(bucketName)
        then:
        result != null
        result.isPresent()
        logger.info("Bucket created: {}", result.get().toString())

    }

    def test_listBuckets() {
        given:
        def bucketName = TEST_BUCKET_NAME
        s3Helper.createBucket(bucketName+"1")
        s3Helper.createBucket(bucketName+"2")
        s3Helper.createBucket(bucketName+"3")

        when:
        def results = s3Helper.listBuckets()
        then:
        results != null
        !results.isEmpty()
        logger.info("Buckets listed: {}", results)
    }

    @Configuration
    @EnableS3Helper
    public static class S3TestConfig {

        /*
        https://java.testcontainers.org/modules/localstack/
         */

        DetachedMockFactory mockFactory = new DetachedMockFactory()

        @Bean
        ObjectMapper objectMapper() {
            return new ObjectMapper();
        }

        @Bean
        AwsCredentials awsCredentials() {
            localstack.start()
            return AwsBasicCredentials.create(localstack.getAccessKey(), localstack.getSecretKey())
        }

        @Bean
        AwsCredentialsProvider awsCredentialsProvider(AwsCredentials awsCredentials) {
            return StaticCredentialsProvider.create(awsCredentials)

        }

        @Bean
        S3Client s3Client(AwsCredentialsProvider awsCredentialsProvider) {
            return S3Client.builder()
                    .endpointOverride(localstack.getEndpoint())
                    .credentialsProvider(awsCredentialsProvider)
                    .region(Region.of(localstack.getRegion()))
                    .build();
        }


    }
}
