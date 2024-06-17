# Using Custom Annotations in Spring

This document provides an overview of how to use the `@EnableCommonConfig`, `@EnableKeyCloak`, and `@EnableTokenApi` annotations in a Spring application.

## @EnableCommonConfig

The `@EnableCommonConfig` annotation is used to enable common configurations across multiple modules or services in a Spring application. This annotation is typically placed on a configuration class in the application.

```java
@Configuration
@EnableCommonConfig
public class AppConfig {
    // Your configuration beans
}