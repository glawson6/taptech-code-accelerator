package com.taptech.common.exception;

public class CannotValidateTokenException extends RuntimeException{
    public CannotValidateTokenException() {
        super();
    }

    public CannotValidateTokenException(String message) {
        super(message);
    }

}
