package com.taptech.common.security.keycloak;

public class KeyCloakServiceException extends RuntimeException
{
    public KeyCloakServiceException(String message) {
        super(message);
    }

    public KeyCloakServiceException(String message, Throwable cause) {
        super(message, cause);
    }
}
