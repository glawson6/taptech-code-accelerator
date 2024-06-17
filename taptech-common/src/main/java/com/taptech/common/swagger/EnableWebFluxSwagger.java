package com.taptech.common.swagger;

import org.springframework.context.annotation.ComponentScan;
import springfox.documentation.swagger2.annotations.EnableSwagger2WebFlux;

import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE})
@Documented
@EnableSwagger2WebFlux
@ComponentScan(value={"com.taptech.common.swagger"})
public @interface EnableWebFluxSwagger {
}
