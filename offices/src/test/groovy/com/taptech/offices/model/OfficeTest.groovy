package com.taptech.offices.model
import spock.lang.Specification

class OfficeTest extends Specification{
    /*
./mvnw clean test -Dtest=OfficeTest

*/

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after


    def test_pojo(){

        def office = new Office()
        office.setId("id")
        office.setName("name")
        office.setAddress("address")
        office.setCity("city")
        office.setState("state")
        office.setZip("zip")
        office.setLatitude(1.0)
        office.setLongitude(1.0)
        office.setOpen("open")
        office.setClose("close")

        office.id("id")
        office.name("name")
        office.address("address")
        office.city("city")
        office.state("state")
        office.zip("zip")
        office.latitude(1.0)
        office.longitude(1.0)
        office.open("open")
        office.close("close")

        office.getId()
        office.getName()
        office.getAddress()
        office.getCity()
        office.getState()
        office.getZip()
        office.getLatitude()
        office.getLongitude()
        office.getOpen()
        office.getClose()


        def office2 = new Office()
        office2.setId("id")
        office2.setName("name")
        office2.setAddress("address")
        office2.setCity("city")
        office2.setState("state")
        office2.setZip("zip")
        office2.setLatitude(1.0)
        office2.setLongitude(1.0)
        office2.setOpen("open")
        office2.setClose("close")


        boolean q1 = office.equals(office)
        boolean q2 = office.equals(office2)
        boolean q3 = office.equals(null)
        String str = office.toString()
        int hash = office.hashCode()

        expect:
        office != null
    }

}
