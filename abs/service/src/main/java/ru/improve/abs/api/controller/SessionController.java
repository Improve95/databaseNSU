package ru.improve.abs.api.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.improve.abs.api.dto.login.LoginRequest;
import ru.improve.abs.api.dto.login.LoginResponse;

import static ru.improve.abs.api.ApiPaths.LOGIN;
import static ru.improve.abs.api.ApiPaths.LOGOUT;
import static ru.improve.abs.api.ApiPaths.SESSIONS;

@RequiredArgsConstructor
@RestController
@RequestMapping(SESSIONS)
public class SessionController {

    @PostMapping(LOGIN)
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest loginRequest) {
        return ResponseEntity.ok(null);
    }

    @PostMapping(LOGOUT)
    public ResponseEntity<Void> logout() {
        return ResponseEntity.ok().build();
    }
}
