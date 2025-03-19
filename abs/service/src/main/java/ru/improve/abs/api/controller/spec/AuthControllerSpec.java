package ru.improve.abs.api.controller.spec;


import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import org.springframework.http.ResponseEntity;
import ru.improve.abs.api.dto.auth.LoginRequest;
import ru.improve.abs.api.dto.auth.LoginResponse;
import ru.improve.abs.api.dto.auth.SignInRequest;
import ru.improve.abs.api.dto.auth.SignInResponse;

import static ru.improve.abs.util.message.MessageKeys.SWAGGER_SECURITY_SCHEME_NAME;

public interface AuthControllerSpec {

    ResponseEntity<SignInResponse> signIn(SignInRequest signInRequest);

    ResponseEntity<LoginResponse> login(LoginRequest loginRequest);

    @SecurityRequirement(name = SWAGGER_SECURITY_SCHEME_NAME)
    ResponseEntity<Void> logout();
}
