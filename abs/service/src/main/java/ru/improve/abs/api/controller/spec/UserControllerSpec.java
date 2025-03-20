package ru.improve.abs.api.controller.spec;

import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import org.springframework.http.ResponseEntity;
import ru.improve.abs.api.dto.user.GetUserResponse;
import ru.improve.abs.api.dto.user.UserResponse;

import static ru.improve.abs.util.message.MessageKeys.SWAGGER_SECURITY_SCHEME_NAME;

public interface UserControllerSpec {

    ResponseEntity<GetUserResponse> getUserById(int id);

    ResponseEntity<GetUserResponse> getUserByAuth();

    @SecurityRequirement(name = SWAGGER_SECURITY_SCHEME_NAME)
    ResponseEntity<UserResponse> becomeClient();
}
