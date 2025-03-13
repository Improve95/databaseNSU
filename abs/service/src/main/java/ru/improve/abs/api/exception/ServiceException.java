package ru.improve.abs.api.exception;

import lombok.Getter;

@Getter
public class ServiceException extends RuntimeException {

    private final ErrorCode code;

    private String[] params = null;

    private Throwable cause = null;

    private String message = null;

    public ServiceException(ErrorCode errorCode) {
        this.code = errorCode;
    }

    public ServiceException(ErrorCode errorCode, String... params) {
        this.code = errorCode;
        this.params = params;
    }

    public ServiceException(ErrorCode errorCode, String message, String[] params) {
        this.code = errorCode;
        this.message = message;
        this.params = params;
    }

    public ServiceException(ErrorCode errorCode, String message, Throwable cause) {
        this.code = errorCode;
        this.message = message;
        this.cause = cause;
    }
}
