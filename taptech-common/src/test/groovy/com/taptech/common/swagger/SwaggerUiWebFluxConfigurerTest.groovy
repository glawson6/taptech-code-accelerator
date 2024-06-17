package com.taptech.common.swagger


import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.core.io.DefaultResourceLoader
import org.springframework.web.reactive.config.ResourceHandlerRegistry
import spock.lang.Specification

class SwaggerUiWebFluxConfigurerTest extends Specification {
    private static final Logger logger = LoggerFactory.getLogger(SwaggerUiWebFluxConfigurerTest.class);

    /*
    ./mvnw clean test -Dtest=SwaggerUiWebFluxConfigurerTest

     */

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    def test_SwaggerUiWebFluxConfigurer(){
        given:
        String url = "url"
        def configurer = new SwaggerUiWebFluxConfigurer(url)
        def resourceHandlerRegistry = new ResourceHandlerRegistry(new DefaultResourceLoader())

        when:
        configurer.addResourceHandlers(resourceHandlerRegistry)

        then:
        configurer != null

    }

    def test_WebfluxConfig(){
        given:
        def configurer = new WebfluxConfig()
        def resourceHandlerRegistry = new ResourceHandlerRegistry(new DefaultResourceLoader())

        when:
        configurer.addResourceHandlers(resourceHandlerRegistry)

        then:
        configurer != null
    }
}
