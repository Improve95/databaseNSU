package ru.improve.abs.core.service;

import ru.improve.abs.api.dto.user.GetUserResponse;

public interface UserService {

    GetUserResponse getUserById(int id);

    GetUserResponse getUserByAuth();
}
