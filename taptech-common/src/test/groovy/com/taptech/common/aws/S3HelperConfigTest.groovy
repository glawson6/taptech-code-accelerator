package com.taptech.common.aws


import com.fasterxml.jackson.databind.ObjectMapper
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.core.io.ClassPathResource
import org.springframework.core.io.InputStreamResource
import software.amazon.awssdk.auth.credentials.AwsCredentials
import software.amazon.awssdk.auth.credentials.AwsCredentialsProvider
import software.amazon.awssdk.core.internal.waiters.ResponseOrException
import software.amazon.awssdk.core.waiters.WaiterResponse
import software.amazon.awssdk.services.s3.S3Client
import software.amazon.awssdk.services.s3.model.Bucket
import software.amazon.awssdk.services.s3.model.GetObjectResponse
import software.amazon.awssdk.services.s3.model.HeadBucketResponse
import software.amazon.awssdk.services.s3.model.HeadObjectResponse
import software.amazon.awssdk.services.s3.model.ListBucketsResponse
import software.amazon.awssdk.services.s3.model.ListObjectsResponse
import software.amazon.awssdk.services.s3.model.S3Object
import software.amazon.awssdk.services.s3.waiters.S3Waiter
import spock.lang.Specification
import spock.mock.DetachedMockFactory

@SpringBootTest(classes = [S3TestConfig.class],
        properties = [
                "spring.main.allow-bean-definition-overriding=true",
                "s3.enabled=true",
        ])
class S3HelperConfigTest extends Specification {
    private static final Logger logger = LoggerFactory.getLogger(S3HelperConfigTest.class);

    /*
    ./mvnw clean test -Dtest=S3HelperConfigTest
     */


    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    @Autowired
    S3Client s3Client

    @Autowired
    S3Helper s3Helper

    def test_config() {
        expect:
        s3Client
        s3Helper
    }

    def test_s3Helper() {
        given:
        def s3helper = new S3Helper()

        expect:
        s3Helper != null
    }

    def test_createBucket() {
        given:
        def bucketName = "test-bucket"

        ResponseOrException<HeadBucketResponse> responseOrException = ResponseOrException.response(HeadBucketResponse.builder().build())
        software.amazon.awssdk.core.waiters.WaiterResponse<HeadBucketResponse> waiterResponse = Mock(WaiterResponse){
            matched() >> responseOrException
        }
        S3Waiter s3Waiter = Mock(S3Waiter)
        when:
        def response = s3Helper.createBucket(bucketName)

        then:
        response != null
        1 * s3Client.createBucket(_)
        1 * s3Client.waiter() >> s3Waiter
        1 * s3Waiter.waitUntilBucketExists(_) >> waiterResponse
        response.isPresent()
        response.get() == responseOrException.response().get()
    }


    def test_createFolder() {
        given:
        def bucketName = "test-bucket"
        def folderName = "test-folder"

        ResponseOrException<HeadObjectResponse> responseOrException = ResponseOrException.response(HeadObjectResponse.builder().build())
        software.amazon.awssdk.core.waiters.WaiterResponse<HeadObjectResponse> waiterResponse = Mock(WaiterResponse){
            matched() >> responseOrException
        }
        S3Waiter s3Waiter = Mock(S3Waiter)
        when:
        def response = s3Helper.createFolder(bucketName, folderName)

        then:
        response != null
        1 * s3Client.putObject(_,_)
        1 * s3Client.waiter() >> s3Waiter
        1 * s3Waiter.waitUntilObjectExists(_) >> waiterResponse
        response.isPresent()
        response.get() == responseOrException.response().get()
    }

    def test_listBuckets() {
        given:
        def bucketName = "test-bucket"
        Bucket bucket1 = Bucket.builder().name(bucketName+"1").build()
        Bucket bucket2 = Bucket.builder().name(bucketName+"2").build()
        Bucket bucket3 = Bucket.builder().name(bucketName+"3").build()
        ListBucketsResponse listBucketsResponse = Mock(ListBucketsResponse)
        List<Bucket> buckets = [bucket1, bucket2, bucket3]

        when:
        s3Helper.listBucketsInLogger()

        then:
        1 * s3Client.listBuckets(_) >> listBucketsResponse
        1 * listBucketsResponse.buckets() >> buckets
    }

    def 'getBucketForEnv should append environment to bucket name'() {
        given:
        String bucketName = 'test-bucket'
        String env = 'production'
        String expectedBucketName = 'test-bucket-production'

        when:
        String actualBucketName = s3Helper.getBucketForEnv(bucketName, env)

        then:
        actualBucketName == expectedBucketName
    }

    def 'getBucketForEnv should return same bucket name for null environment'() {
        given:
        String bucketName = 'test-bucket'
        String env = null
        String expectedBucketName = bucketName+'-null'

        when:
        String actualBucketName = s3Helper.getBucketForEnv(bucketName, env)

        then:
        actualBucketName == expectedBucketName
    }

    def test_getS3Objects() {
        given:
        def bucketName = "test-bucket"
        def folderName = "test-folder"
        ListObjectsResponse listObjectsResponse = Mock(ListObjectsResponse)
        def expectedObjects = [S3Object.builder().key("test-key").build()]

        when:
        s3Helper.getS3Objects(bucketName, folderName)

        then:
        1 * s3Client.listObjects(_) >> listObjectsResponse
        1 * listObjectsResponse.contents() >> expectedObjects
    }

    def test_fromS3Object() {
        given:
        def bucketName = "test-bucket"
        def folderName = "test-folder"
        def s3Object = S3Object.builder().key(folderName).build()
        software.amazon.awssdk.core.ResponseInputStream<GetObjectResponse> responseInputStream = Mock(software.amazon.awssdk.core.ResponseInputStream){
            readAllBytes() >> "test".getBytes()
        }

        when:
        def resource = s3Helper.fromS3Object(bucketName, s3Object)

        then:
        resource != null
        1 * s3Client.getObject(_) >> responseInputStream
        resource instanceof InputStreamResource
    }


    def test_getResourceFromS3Object() {
        given:
        def bucketName = "test-bucket"
        def folderName = "test-folder"
        def s3Object = S3Object.builder().key(folderName).build()
        software.amazon.awssdk.core.ResponseInputStream< GetObjectResponse> responseInputStream = Mock(software.amazon.awssdk.core.ResponseInputStream){
            readAllBytes() >> "test".getBytes()
        }

        when:
        def resource = s3Helper.getResourceFromS3Object(bucketName, s3Object)

        then:
        resource != null
        1 * s3Client.getObject(_) >> responseInputStream
        resource instanceof InputStreamResource
    }

    /*
    def test_createPresignedGetUrl() {
        given:
        def bucketName = "test-bucket"
        def folderName = "test-folder"
        def expectedUrl = "http://test.com"

        when:
        def url = s3Helper.createPresignedGetUrl(bucketName, folderName)

        then:
        logger.info("url: {}", url)
        url == expectedUrl
    }

     */

    def test_listBucketsInLogger(){
        given:
        ListBucketsResponse listBucketsResponse = Mock(ListBucketsResponse)
        List<Bucket> buckets = [Bucket.builder().name("test-bucket").build()]

        when:
        s3Helper.listBucketsInLogger()

        then:
        1 * s3Client.listBuckets(_) >> listBucketsResponse
        1 * listBucketsResponse.buckets() >> buckets
    }

    def test_deleteBucket() {
        given:
        def bucketName = "test-bucket"

        ResponseOrException<HeadBucketResponse> responseOrException = ResponseOrException.response(HeadBucketResponse.builder().build())
        software.amazon.awssdk.core.waiters.WaiterResponse<HeadBucketResponse> waiterResponse = Mock(WaiterResponse){
            matched() >> responseOrException
        }
        S3Waiter s3Waiter = Mock(S3Waiter)
        when:
        def response = s3Helper.deleteBucket(bucketName)

        then:
        response != null
        1 * s3Client.deleteBucket(_)
        1 * s3Client.waiter() >> s3Waiter
        1 * s3Waiter.waitUntilBucketExists(_) >> waiterResponse
        response.isPresent()
        response.get() == responseOrException.response().get()
    }


    def test_deleteFolder() {
        given:
        def bucketName = "test-bucket"
        def folderName = "test-folder"

        ResponseOrException<HeadObjectResponse> responseOrException = ResponseOrException.response(HeadObjectResponse.builder().build())
        software.amazon.awssdk.core.waiters.WaiterResponse<HeadObjectResponse> waiterResponse = Mock(WaiterResponse){
            matched() >> responseOrException
        }
        S3Waiter s3Waiter = Mock(S3Waiter)
        when:
        def response = s3Helper.deleteFolder(bucketName, folderName)

        then:
        response != null
        1 * s3Client.deleteObject(_)
        1 * s3Client.waiter() >> s3Waiter
        1 * s3Waiter.waitUntilObjectExists(_) >> waiterResponse
        response.isPresent()
        response.get() == responseOrException.response().get()
    }


    def test_uploadFile() {
        given:
        def bucketName = "test-bucket"
        def folderName = "test-folder"
        File testResource = new ClassPathResource("test-resource.txt").getFile();

        ResponseOrException<HeadObjectResponse> responseOrException = ResponseOrException.response(HeadObjectResponse.builder().build())
        software.amazon.awssdk.core.waiters.WaiterResponse<HeadObjectResponse> waiterResponse = Mock(WaiterResponse){
            matched() >> responseOrException
        }
        S3Waiter s3Waiter = Mock(S3Waiter)

        when:
        def response = s3Helper.uploadFile(bucketName, folderName, testResource)

        then:
        response != null
        1 * s3Client.putObject(_,_)
        1 * s3Client.waiter() >> s3Waiter
        1 * s3Waiter.waitUntilObjectExists(_) >> waiterResponse
        response.isPresent()
        response.get() == responseOrException.response().get()
    }


    def test_uploadBytes() {
        given:
        def bucketName = "test-bucket"
        def folderName = "test-folder"
        byte[] testResource = "test".getBytes()

        ResponseOrException<HeadObjectResponse> responseOrException = ResponseOrException.response(HeadObjectResponse.builder().build())
        software.amazon.awssdk.core.waiters.WaiterResponse<HeadObjectResponse> waiterResponse = Mock(WaiterResponse){
            matched() >> responseOrException
        }
        S3Waiter s3Waiter = Mock(S3Waiter)

        when:
        def response = s3Helper.uploadBytes(bucketName, folderName, testResource)

        then:
        response != null
        1 * s3Client.putObject(_,_)
        1 * s3Client.waiter() >> s3Waiter
        1 * s3Waiter.waitUntilObjectExists(_) >> waiterResponse
        response.isPresent()
        response.get() == responseOrException.response().get()
    }

    def test_determineRequestBody_IllegalArgumentException(){
        given:
        def val = 1000L

        when:
        def response = s3Helper.determineRequestBody(val)

        then:
        Exception ex = thrown(IllegalArgumentException)
    }

    @Configuration
    @EnableS3Helper
    public static class S3TestConfig {

        DetachedMockFactory mockFactory = new DetachedMockFactory()

        @Bean
        ObjectMapper objectMapper() {
            return new ObjectMapper();
        }

        @Bean
        AwsCredentials awsCredentials(S3Properties s3Properties) {
            return mockFactory.Mock(AwsCredentials)
        }

        @Bean
        AwsCredentialsProvider awsCredentialsProvider(AwsCredentials awsCredentials) {
            return mockFactory.Mock(AwsCredentialsProvider)
        }

        @Bean
        S3Client s3Client(S3Properties s3Properties, AwsCredentialsProvider awsCredentialsProvider) {
            return mockFactory.Mock(S3Client)
        }


    }
}
