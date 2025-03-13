package ru.improve.abs.core.security.imp;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Service;
import ru.improve.abs.api.dto.login.LoginResponse;
import ru.improve.abs.core.security.AuthService;

@Service
public class AuthServiceImp implements AuthService {

    @Override
    public boolean authenticate(HttpServletRequest request, HttpServletResponse response) {
        return true;
    }

    public LoginResponse login() {
        return null;
    }
}
