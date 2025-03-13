package ru.improve.abs.core.security;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import ru.improve.abs.api.exception.ErrorCode;
import ru.improve.abs.api.exception.ServiceException;
import ru.improve.abs.core.repository.UserRepository;

@RequiredArgsConstructor
@Service
public class UserDetailService implements UserDetailsService {

    private final UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String login) throws UsernameNotFoundException {
        return userRepository.findByEmail(login)
                .orElseThrow(() -> new ServiceException(ErrorCode.NOT_FOUND, "user", "login"));
    }
}
