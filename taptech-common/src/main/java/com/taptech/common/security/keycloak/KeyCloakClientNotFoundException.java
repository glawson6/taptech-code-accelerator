package com.taptech.common.security.keycloak;

public class KeyCloakClientNotFoundException extends RuntimeException{
    public KeyCloakClientNotFoundException() {
    }

    public KeyCloakClientNotFoundException(String message) {
        super(message);
    }
}
