package ru.improve.abs.core.service.imp;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import ru.improve.abs.api.dto.user.GetUserResponse;
import ru.improve.abs.api.dto.user.UserResponse;
import ru.improve.abs.api.exception.ServiceException;
import ru.improve.abs.core.mapper.UserMapper;
import ru.improve.abs.core.repository.UserRepository;
import ru.improve.abs.core.service.RoleService;
import ru.improve.abs.core.service.UserService;
import ru.improve.abs.model.Role;
import ru.improve.abs.model.User;

import static ru.improve.abs.api.exception.ErrorCode.NOT_FOUND;
import static ru.improve.abs.core.security.SecurityUtil.CLIENT_ROLE;

@RequiredArgsConstructor
@Service
public class UserServiceImp implements UserService {

    private final RoleService roleService;

    private final UserRepository userRepository;

    private final UserMapper userMapper;

    @Transactional
    @Override
    public GetUserResponse getUserById(int id) {
        User user = findUserById(id);
        return userMapper.toGetUserResponse(user);
    }

    @Transactional
    @Override
    public GetUserResponse getUserByAuth() {
        return null;
    }

    @Transactional
    @Override
    public UserResponse becomeUserClient() {
        User user = getUserFromAuthentication();

        Role clientRole = roleService.findRoleByName(CLIENT_ROLE);
        if (user.getRoles().contains(clientRole)) {
            return userMapper.toUserResponse(user);
        }
        user.getRoles().add(clientRole);

        return userMapper.toUserResponse(user);
    }

    @Transactional
    @Override
    public User findUserById(int id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new ServiceException(NOT_FOUND, "user", "id"));
    }

    @Transactional
    @Override
    public User findUserByEmail(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new ServiceException(NOT_FOUND, "user", "email"));
    }

    @Transactional
    @Override
    public User getUserFromAuthentication() {
        User detachUser = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        int userId = detachUser.getId();
        return findUserById(userId);
    }
}
