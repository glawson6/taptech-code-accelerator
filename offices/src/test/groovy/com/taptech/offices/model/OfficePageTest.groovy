package com.taptech.offices.model

import spock.lang.Specification

class OfficePageTest extends Specification {
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

        def officePage = new OfficePage()
        officePage.setPage(1)
       officePage.setContent(new ArrayList<Office>())
        officePage.setCorrelationId("correlationId")
        officePage.setPageSize(1)
        officePage.setTotal(1)
        officePage.setElapsed("1")
        officePage.page(1)
        officePage.content(new ArrayList<Office>())
        officePage.correlationId("correlationId")
        officePage.pageSize(1)
        officePage.total(1)
        officePage.elapsed("1")
        officePage.addContentItem(new Office())

        def officePage2 = new OfficePage()
        officePage2.setElapsed(officePage.getElapsed())
        officePage2.setPage(officePage.getPage())
        officePage2.setContent(officePage.getContent())
        officePage2.setCorrelationId(officePage.getCorrelationId())
        officePage2.setTotal(officePage.getTotal())
        officePage2.setPageSize(officePage.getPageSize())
        officePage.equals(officePage2)
        officePage.equals(officePage)
        officePage.equals(null)

        String str = officePage.toString()
        int hash = officePage.hashCode()

        expect:
        officePage != null

    }
}
