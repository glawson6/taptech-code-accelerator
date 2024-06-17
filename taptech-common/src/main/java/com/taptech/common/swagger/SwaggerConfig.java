package com.taptech.common.swagger;

import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;

@Configuration
//@Conditional(EnabledWebfluxSwaggerCondition.class)
@SecurityScheme(type = SecuritySchemeType.HTTP, name = "BearerAuth",
        description = "authentication with JWT token", scheme = "bearer",
        bearerFormat = "JWT")

@SecurityScheme(type = SecuritySchemeType.HTTP, name = "BasicAuth",
        description = "authentication using basic authentication", scheme = "basic")
public class SwaggerConfig {

    private static final Logger logger = LoggerFactory.getLogger(SwaggerConfig.class);

    @Bean
    public Docket api() {
        logger.info("SwaggerConfig.api()");
        return new Docket(DocumentationType.SWAGGER_2)
                .select()
                .apis(RequestHandlerSelectors.any())
                .paths(PathSelectors.any())
                .build();
    }

    @Bean
    SwaggerUiWebFluxConfigurer webFluxConfigurer(){
        logger.info("SwaggerConfig.webFluxConfigurer()");
        return new SwaggerUiWebFluxConfigurer("http://localhost:9090");
    }
}