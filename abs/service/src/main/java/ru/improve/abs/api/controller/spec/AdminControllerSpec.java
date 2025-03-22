package ru.improve.abs.api.controller.spec;

import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Positive;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import ru.improve.abs.api.dto.user.UserResponse;

import static ru.improve.abs.api.ApiPaths.ROLE_ID;
import static ru.improve.abs.api.ApiPaths.USER_ID;
import static ru.improve.abs.util.message.MessageKeys.SWAGGER_SECURITY_SCHEME_NAME;

public interface AdminControllerSpec {

    @SecurityRequirement(name = SWAGGER_SECURITY_SCHEME_NAME)
    ResponseEntity<UserResponse> getUserById(@PathVariable @Valid int id);

    @SecurityRequirement(name = SWAGGER_SECURITY_SCHEME_NAME)
    ResponseEntity<UserResponse> addRoleToUser(
            @Valid @RequestParam(name = USER_ID) @Positive int userId,
            @Valid @RequestParam(name = ROLE_ID) @Positive int roleId
    );

    @SecurityRequirement(name = SWAGGER_SECURITY_SCHEME_NAME)
    ResponseEntity<UserResponse> removeRoleToUser(
            @Valid @RequestParam(name = USER_ID) @Positive int userId,
            @Valid @RequestParam(name = ROLE_ID) @Positive int roleId
    );
}
