package com.taptech.offices.model

import spock.lang.Specification

class HoursTest extends Specification {
    /*
./mvnw clean test -Dtest=HoursTest

*/

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    def test_pojo(){

        def hours = new Hours()
           hours.open("open")
        hours.close("close")
        hours.setOpen("open")
        hours.setClose("close")
        hours.getOpen()
        hours.getClose()


        def hours2 = new Hours()
        hours2.setOpen("open")
        hours2.setClose("close")
        hours2.open("open")
        hours2.close("close")
        String str = hours.toString()
        int hash = hours.hashCode()
        hours.equals(hours2)
        hours.equals(hours)
        hours.equals(null)

        expect:
        hours != null

    }
}
