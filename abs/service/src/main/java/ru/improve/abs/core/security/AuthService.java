package ru.improve.abs.core.security;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public interface AuthService {

    boolean authenticate(HttpServletRequest request, HttpServletResponse response);
}
