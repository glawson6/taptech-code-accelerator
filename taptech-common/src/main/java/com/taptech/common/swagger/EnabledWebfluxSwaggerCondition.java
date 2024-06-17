package com.taptech.common.swagger;

import org.springframework.context.annotation.Condition;
import org.springframework.context.annotation.ConditionContext;
import org.springframework.core.type.AnnotatedTypeMetadata;

public class EnabledWebfluxSwaggerCondition implements Condition {
    @Override
    public boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata) {
        return metadata.isAnnotated("com.taptech.common.swagger.EnableWebFluxSwagger");
    }
}
