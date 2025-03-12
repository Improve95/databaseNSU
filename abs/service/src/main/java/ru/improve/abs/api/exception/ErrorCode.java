package ru.improve.abs.api.exception;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor(access = AccessLevel.PRIVATE)
@Getter
public enum ErrorCode {

    INTERNAL_SERVER_ERROR(1),

    ALREADY_EXIST(2),

    ILLEGAL_DTO_VALUE(7),

    ILLEGAL_VALUE(3),

    NOT_FOUND(4),

    UNAUTHORIZED(5),

    SESSION_IS_OVER(6);

    private final int code;
}
