package com.taptech.common.security.token;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Import;
import springfox.documentation.swagger2.annotations.EnableSwagger2WebFlux;

import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE})
@Documented
@EnableSwagger2WebFlux
@Import({TokenApiConfiguration.class})
public @interface EnableTokenApi {
}
