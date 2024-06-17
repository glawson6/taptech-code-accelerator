package com.taptech.common.security.keycloak;

import com.taptech.common.security.user.UserContextPermissionsConfig;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Import;

import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE})
@Documented
//@ComponentScan(value={"com.alpha.omega.cc.common.security"})

@Import({UserContextPermissionsConfig.class, KeyCloakConfig.class})
public @interface EnableKeyCloak {
}
