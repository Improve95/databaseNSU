package ru.improve.abs.core.service;

import ru.improve.abs.api.dto.user.GetUserResponse;
import ru.improve.abs.api.dto.user.UserResponse;
import ru.improve.abs.model.User;

public interface UserService {

    UserResponse becomeUserClient();

    User findUserById(int id);

    User findUserByEmail(String email);

    GetUserResponse getUserById(int id);

    GetUserResponse getUserByAuth();
}
