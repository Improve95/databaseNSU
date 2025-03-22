package ru.improve.abs.core.service;

import ru.improve.abs.api.dto.user.UserResponse;
import ru.improve.abs.model.User;

public interface UserService {

    User getUserFromAuthentication();

    UserResponse becomeUserClient();

    UserResponse addRole(int userId, int roleId);

    UserResponse removeRole(int userId, int roleId);

    User findUserById(int id);

    User findUserByEmail(String email);

    UserResponse getUserById(int id);

    UserResponse getUserByAuth();
}
