package ru.improve.abs.api.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.improve.abs.api.dto.auth.LoginRequest;
import ru.improve.abs.api.dto.auth.LoginResponse;
import ru.improve.abs.api.dto.auth.SignInRequest;
import ru.improve.abs.api.dto.auth.SignInResponse;
import ru.improve.abs.core.security.service.AuthService;

import static ru.improve.abs.api.ApiPaths.LOGIN;
import static ru.improve.abs.api.ApiPaths.LOGOUT;
import static ru.improve.abs.api.ApiPaths.AUTH;
import static ru.improve.abs.api.ApiPaths.SIGN_IN;

@RequiredArgsConstructor
@RestController
@RequestMapping(AUTH)
public class AuthController {

    private final AuthService authService;

    @PostMapping(SIGN_IN)
    public ResponseEntity<SignInResponse> createUser(@RequestBody @Valid SignInRequest signInRequest) {
        SignInResponse signInResponse = authService.signIn(signInRequest);
        return ResponseEntity.ok(signInResponse);
    }

    @PostMapping(LOGIN)
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest loginRequest) {
        LoginResponse loginResponse = authService.login(loginRequest);
        return ResponseEntity.ok(loginResponse);
    }

    @PostMapping(LOGOUT)
    public ResponseEntity<Void> logout() {
        return ResponseEntity.ok().build();
    }
}
