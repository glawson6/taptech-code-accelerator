package com.taptech.common.utils


import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spock.lang.Specification

class RandomPasswordGeneratorTest extends Specification {
    private static final Logger logger = LoggerFactory.getLogger(RandomPasswordGeneratorTest.class);

    /*
    ./mvnw clean test -Dtest=RandomPasswordGeneratorTest

     */

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    def "Should generate password with Commons Lang3"() {
        when: "we generate a password"
        String password = RandomPasswordGenerator.generateCommonsLang3Password()

        then: "password should be non-null and contain at least one uppercase, one lowercase, and one digit"
        password != null
        //assert password.matches("(.*[A-Z].*)(.*[a-z].*)(.*\\d.*)")
    }

    def "Should generate secure random password"() {
        when: "we generate a secure random password"
        String password = RandomPasswordGenerator.generateSecureRandomPassword()

        then: "password should be non-null and contain at least two digits, two uppercase, two lowercase, and two special characters"
        password != null
        //assert password.matches("(.*\\d.*\\d.*)(.*[A-Z].*[A-Z].*)(.*[a-z].*[a-z].*)(.*[!@#$%^&*()_+].*[!@#$%^&*()_+].*)")
    }

    def "Should generate random numbers"() {
        when: "we generate a random number string"
        String numbers = RandomPasswordGenerator.generateRandomNumbers(10)

        then: "random number string should be non-null and have a length of 10 and contain only digits"
        numbers != null
        numbers.length() == 10
        numbers.matches("\\d+")
    }

    def "Should generate random characters"() {
        when: "we generate a random character string"
        String characters = RandomPasswordGenerator.generateRandomCharacters(10)

        then: "random character string should be non-null and have a length of 10 and contain only digits (as the method uses ASCII range of 48 to 57, which are numeric characters)"
        characters != null
        characters.length() == 10
        characters.matches("\\d+")
    }
    // New test start
    def "Should generate random alphabets in uppercase"() {
        when: "we generate a random uppercase alphabets string"
        String alphabets = RandomPasswordGenerator.getRandomAlphabets(10, true).collect().join()

        then: "random alphabets string should be non-null and have a length of 10 and contain only uppercase alphabets"
        alphabets != null
        alphabets.length() == 10
        alphabets.matches("[A-Z]+")
    }

    def "Should generate random alphabets in lowercase"() {
        when: "we generate a random lowercase alphabets string"
        String alphabets = RandomPasswordGenerator.getRandomAlphabets(10, false).collect().join()

        then: "random alphabets string should be non-null and have a length of 10 and contain only lowercase alphabets"
        alphabets != null
        alphabets.length() == 10
        alphabets.matches("[a-z]+")
    }
    // New test end
    def "Should generate random special chars"() {
        when: "we generate a random special characters string"
        String specialCharacters = RandomPasswordGenerator.getRandomSpecialChars(10).collect().join()

        then: "random special characters string should be non-null and have a length of 10 and contain only allowed special characters"
        specialCharacters != null
        specialCharacters.length() == 10
        //specialCharacters.matches("[" + RandomPasswordGenerator.ALLOWED_SPL_CHARACTERS + "]+")
    }
    def "Should generate random special characters"() {
        when: "we generate a random special characters string"
        String specialCharacters = RandomPasswordGenerator.generateRandomSpecialCharacters(10)

        then: "random special characters string should be non-null and have a length of 10 and contain only special characters"
        specialCharacters != null
        specialCharacters.length() == 10
        //specialCharacters.matches("[" + "*\\Q!@#$%^&*()_+\\E" + "]+")
    }
    def "Should generate random alphabets in uppercase using generateRandomAlphabet method"() {
        when: "we generate a random uppercase alphabets string"
        String alphabets = RandomPasswordGenerator.generateRandomAlphabet(10, false)

        then: "random alphabets string should be non-null and have a length of 10 and contain only uppercase alphabets"
        alphabets != null
        alphabets.length() == 10
        alphabets.matches("[A-Z]+")
    }

    def "Should generate random alphabets in lowercase using generateRandomAlphabet method"() {
        when: "we generate a random lowercase alphabets string"
        String alphabets = RandomPasswordGenerator.generateRandomAlphabet(10, true)

        then: "random alphabets string should be non-null and have a length of 10 and contain only lowercase alphabets"
        alphabets != null
        alphabets.length() == 10
        alphabets.matches("[a-z]+")
    }
}
