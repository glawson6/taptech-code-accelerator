package com.taptech.offices

import com.taptech.offices.service.OfficeEntity
import spock.lang.Specification

class OfficeEntityTest extends Specification {
    /*
./mvnw clean test -Dtest=OfficeEntityTest

*/

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    def test_pojo() {
        def officeEntity = OfficeEntity.builder()
                .id("id")
                .name("name")
                .address("address")
                .city("city")
                .zip("zip")
                .latitude(1.0)
                .longitude(1.0)
                .close("close")
                .state("state")
                .open("open")
                .build()
        officeEntity.setId("id")
        def req = new OfficeEntity()

        boolean q1 = officeEntity.equals(officeEntity)
        boolean q2 = officeEntity.equals(req)
        boolean q3 = officeEntity.equals(null)
        String str = officeEntity.toString()
        int hash = officeEntity.hashCode()

        expect:
        officeEntity != null
    }

    def test_pojo_builder() {
        def officeEntityBuilder = OfficeEntity.builder()
                .id("id")
                .name("name")
                .address("address")
                .city("city")
                .zip("zip")
                .latitude(1.0)
                .longitude(1.0)
                .close("close")
                .state("state")
                .open("open")
        String str = officeEntityBuilder.toString()
        int hash = officeEntityBuilder.hashCode()
        def officeEntity = officeEntityBuilder.build()

        expect:
        officeEntityBuilder != null
        officeEntityBuilder.toString() != null
    }
}
