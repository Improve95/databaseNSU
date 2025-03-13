package ru.improve.abs.core.service.imp;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import ru.improve.abs.api.dto.user.GetUserResponse;
import ru.improve.abs.api.exception.ServiceException;
import ru.improve.abs.api.mapper.UserMapper;
import ru.improve.abs.core.model.User;
import ru.improve.abs.core.repository.UserRepository;
import ru.improve.abs.core.service.UserService;

import static ru.improve.abs.api.exception.ErrorCode.NOT_FOUND;

@RequiredArgsConstructor
@Service
public class UserServiceImp implements UserService {

    private final UserRepository userRepository;

    private final UserMapper userMapper;

    @Transactional
    @Override
    public GetUserResponse getUserById(int id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ServiceException(NOT_FOUND, "user", "id"));
        return userMapper.toGetUserResponse(user);
    }

    @Transactional
    @Override
    public GetUserResponse getUserByAuth() {
        return null;
    }
}
