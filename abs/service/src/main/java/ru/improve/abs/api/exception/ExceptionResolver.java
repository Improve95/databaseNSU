package ru.improve.abs.api.exception;

import com.google.common.collect.ImmutableMap;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authorization.AuthorizationDeniedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.HandlerMethodValidationException;

import static ru.improve.abs.api.exception.ErrorCode.ALREADY_EXIST;
import static ru.improve.abs.api.exception.ErrorCode.ILLEGAL_DTO_VALUE;
import static ru.improve.abs.api.exception.ErrorCode.INTERNAL_SERVER_ERROR;
import static ru.improve.abs.api.exception.ErrorCode.NOT_FOUND;
import static ru.improve.abs.api.exception.ErrorCode.SESSION_IS_OVER;
import static ru.improve.abs.api.exception.ErrorCode.UNAUTHORIZED;
import static ru.improve.abs.util.message.MessageKeys.TITLE_ALREADY_EXIST;
import static ru.improve.abs.util.message.MessageKeys.TITLE_ILLEGAL_DTO_VALUE;
import static ru.improve.abs.util.message.MessageKeys.TITLE_INTERNAL_SERVER_ERROR;
import static ru.improve.abs.util.message.MessageKeys.TITLE_NOT_FOUND;
import static ru.improve.abs.util.message.MessageKeys.TITLE_SESSION_IS_OVER;
import static ru.improve.abs.util.message.MessageKeys.TITLE_UNAUTHORIZED;

@Slf4j
@RequiredArgsConstructor
@RestControllerAdvice
public class ExceptionResolver {

    private static ImmutableMap<ErrorCode, String> messageKeyMap = ImmutableMap.of(
            INTERNAL_SERVER_ERROR, TITLE_INTERNAL_SERVER_ERROR,
            ALREADY_EXIST, TITLE_ALREADY_EXIST,
            ILLEGAL_DTO_VALUE,  TITLE_ILLEGAL_DTO_VALUE,
            NOT_FOUND, TITLE_NOT_FOUND,
            UNAUTHORIZED, TITLE_UNAUTHORIZED,
            SESSION_IS_OVER, TITLE_SESSION_IS_OVER
    );

    private static ImmutableMap<ErrorCode, HttpStatus> httpStatusMap = ImmutableMap.of(
            INTERNAL_SERVER_ERROR, HttpStatus.INTERNAL_SERVER_ERROR,
            ALREADY_EXIST, HttpStatus.BAD_REQUEST,
            ILLEGAL_DTO_VALUE, HttpStatus.BAD_REQUEST,
            NOT_FOUND, HttpStatus.NOT_FOUND,
            UNAUTHORIZED, HttpStatus.UNAUTHORIZED,
            SESSION_IS_OVER, HttpStatus.UNAUTHORIZED
    );

    private final MessageSource messageSource;

    @ExceptionHandler
    public ResponseEntity<ErrorResponse> resolveHandleException(Exception ex) {
        ErrorCodeMessagePair errorCode = resolveException(ex);
        return ResponseEntity.status(httpStatusMap.get(errorCode.code))
                .body(ErrorResponse.builder()
                        .errorCode(errorCode.code.getCode())
                        .message(errorCode.message)
                        .build()
                );
    }

    private ErrorCodeMessagePair resolveException(Exception ex) {
        if (ex instanceof ServiceException serviceEx) {
            return resolveServiceException(serviceEx);
        } else if (ex instanceof MethodArgumentNotValidException ||
                   ex instanceof HandlerMethodValidationException) {
            return resolveDtoException(ex);
        } else if (ex instanceof AuthorizationDeniedException authDeniedException) {
            return resolveAccessDeniedException(authDeniedException);
        }
        return ErrorCodeMessagePair.of(
                INTERNAL_SERVER_ERROR,
                resolveMessage(messageKeyMap.get(INTERNAL_SERVER_ERROR), null)
        );
    }

    private ErrorCodeMessagePair resolveServiceException(ServiceException ex) {
        ErrorCode code = ex.getCode();
        StringBuilder message = new StringBuilder();
        message.append(resolveMessage(messageKeyMap.get(code), ex.getParams()));

        if (ex.getMessage() != null) {
            message.append(": " + resolveMessage(ex.getMessage(), ex.getParams()));
        }

        if (ex.getCause() != null && ex.getCause().getMessage() != null) {
            message.append(", cause " + ex.getCause().getMessage());
        }
        return ErrorCodeMessagePair.of(code, message.toString());
    }

    private ErrorCodeMessagePair resolveDtoException(Exception ex) {
        return null;
    }

    private ErrorCodeMessagePair resolveAccessDeniedException(AuthorizationDeniedException ex) {
        String message = resolveMessage(messageKeyMap.get(UNAUTHORIZED), null) + ": " + ex.getMessage();
        return ErrorCodeMessagePair.of(
                UNAUTHORIZED,
                message
        );
    }

    private String resolveMessage(String key, String[] params) {
        return messageSource.getMessage(key, params, key, LocaleContextHolder.getLocale());
    }

    private record ErrorCodeMessagePair(ErrorCode code, String message) {
        public static ErrorCodeMessagePair of(ErrorCode code, String message) {
            return new ErrorCodeMessagePair(code, message);
        }
    }
}
