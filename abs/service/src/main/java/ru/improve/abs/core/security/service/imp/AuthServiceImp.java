package ru.improve.abs.core.security.service.imp;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Service;
import ru.improve.abs.api.dto.auth.LoginRequest;
import ru.improve.abs.api.dto.auth.LoginResponse;
import ru.improve.abs.api.dto.auth.SignInRequest;
import ru.improve.abs.api.dto.auth.SignInResponse;
import ru.improve.abs.api.exception.ServiceException;
import ru.improve.abs.api.mapper.AuthMapper;
import ru.improve.abs.api.mapper.UserMapper;
import ru.improve.abs.core.model.Session;
import ru.improve.abs.core.model.User;
import ru.improve.abs.core.repository.UserRepository;
import ru.improve.abs.core.security.UserDetailService;
import ru.improve.abs.core.security.service.AuthService;
import ru.improve.abs.core.security.service.TokenService;
import ru.improve.abs.core.service.SessionService;
import ru.improve.abs.util.database.DatabaseUtil;

import static ru.improve.abs.api.exception.ErrorCode.SESSION_IS_OVER;
import static ru.improve.abs.api.exception.ErrorCode.UNAUTHORIZED;

@Slf4j
@RequiredArgsConstructor
@Service
public class AuthServiceImp implements AuthService {

    private final UserDetailService userDetailService;

    private final AuthenticationManager authManager;

    private final UserRepository userRepository;

    private final SessionService sessionService;

    private final TokenService tokenService;

    private final PasswordEncoder passwordEncoder;

    private final UserMapper userMapper;

    private final AuthMapper authMapper;

    @Override
    public boolean setAuthentication(HttpServletRequest request, HttpServletResponse response) {
        SecurityContext securityContext = SecurityContextHolder.getContext();
        Authentication auth = securityContext.getAuthentication();
        if (!(auth instanceof JwtAuthenticationToken)) {
            log.info("Not authenticated request: {}: {}", request.getMethod(), request.getRequestURL());
            return false;
        }

        try {
            Jwt jwtToken = (Jwt) auth.getPrincipal();

            if (!sessionService.checkSessionEnableById(tokenService.getSessionId(jwtToken))) {
                throw new ServiceException(SESSION_IS_OVER);
            }

            UserDetails userDetails = userDetailService.loadUserByUsername(jwtToken.getSubject());
            UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                    userDetails, null, userDetails.getAuthorities()
            );
            authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
            securityContext.setAuthentication(authentication);
            return true;
        } catch (ServiceException ex) {
            securityContext.setAuthentication(null);
            SecurityContextHolder.clearContext();
            response.reset();

            ServiceException exception = (ex.getCode() == SESSION_IS_OVER ?
                    new ServiceException(SESSION_IS_OVER) :
                    new ServiceException(UNAUTHORIZED));
            throw exception;
        }
    }

    @Transactional
    @Override
    public SignInResponse signIn(SignInRequest signInRequest) {
        User user = User.builder()
                .email(signInRequest.getEmail())
                .name(signInRequest.getName())
                .password(passwordEncoder.encode(signInRequest.getPassword()))
                .build();

        try {
            userRepository.save(user);
        } catch (DataIntegrityViolationException ex) {
            DatabaseUtil.parseDatabaseException(ex);
        }

        return userMapper.toSignInUserResponse(user);
    }

    @Override
    public LoginResponse login(LoginRequest loginRequest) {
        Authentication authentication;
        try {
            authentication = authManager.authenticate(
                    new UsernamePasswordAuthenticationToken(loginRequest.getLogin(), loginRequest.getPassword())
            );
        } catch (AuthenticationException ex) {
            throw new ServiceException(UNAUTHORIZED);
        }

        User user = (User) authentication.getPrincipal();
        if (user == null) {
            throw new ServiceException(UNAUTHORIZED);
        }

        Session session = sessionService.create(user);
        Jwt accessTokenJwt = tokenService.generateToken(user, session);

        LoginResponse loginResponse = authMapper.toLoginResponse(session);
        loginResponse.setAccessToken(accessTokenJwt.getTokenValue());

        return loginResponse;
    }
}
