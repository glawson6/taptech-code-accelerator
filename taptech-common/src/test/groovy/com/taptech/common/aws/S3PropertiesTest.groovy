package com.taptech.common.aws


import software.amazon.awssdk.regions.Region
import spock.lang.Specification

class S3PropertiesTest extends Specification {
    /*
 ./mvnw clean test -Dtest=ContextEntityTest

  */

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    def test_pojo() {
        def scProperties = new S3Properties()
        scProperties.setAccessKey("accessKey")
        scProperties.setSecretKey("secretKey")
        scProperties.setEnabled(true)
        scProperties.setRegion(Region.US_EAST_1)
        scProperties.getAccessKey()
        scProperties.getSecretKey()
        scProperties.getEnabled()
        scProperties.getRegion()

        def scProperties2 = new S3Properties("accessKey", "secretKey", true, Region.US_EAST_1)
        scProperties.equals(scProperties2)
        scProperties.equals(scProperties)
        scProperties.equals(null)
        scProperties.canEqual(scProperties2)

        String str = scProperties.toString()
        int hash = scProperties.hashCode()

        expect:
        scProperties != null

    }
}
