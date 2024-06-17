package com.taptech.common


import spock.lang.Specification

class ConstantsTest extends Specification {
    /*
 ./mvnw clean test -Dtest=ConstantsTest

  */

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after


    def some_tests(){

        given:
        String[] defaultIgnoreURLS = Constants.DEFAULT_IGNORE_URLS_ARRAY
        List<String> defaultIgnoreURLSList = Constants.DEFAULT_IGNORE_URLS_LIST
        String elapsedTime = Constants.elapsedSeconds.apply(1000L)

        when:

        expect:
        defaultIgnoreURLS != null
        defaultIgnoreURLSList != null
        elapsedTime != null
        elapsedTime.contains("seconds")
    }
}
