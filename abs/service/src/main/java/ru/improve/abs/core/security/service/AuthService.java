package ru.improve.abs.core.security.service;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import ru.improve.abs.api.dto.auth.LoginRequest;
import ru.improve.abs.api.dto.auth.LoginResponse;
import ru.improve.abs.api.dto.auth.SignInRequest;
import ru.improve.abs.api.dto.auth.SignInResponse;

public interface AuthService {

    boolean setAuthentication(HttpServletRequest request, HttpServletResponse response);

    SignInResponse signIn(SignInRequest signInRequest);

    LoginResponse login(LoginRequest loginRequest);

    void logout();
}
