package ru.improve.abs.core.service;

import ru.improve.abs.api.dto.user.GetUserResponse;
import ru.improve.abs.api.dto.user.PostUserRequest;
import ru.improve.abs.api.dto.user.PostUserResponse;

public interface UserService {

    GetUserResponse getUserById(int id);

    GetUserResponse getUserByAuth();

    PostUserResponse createNewUser(PostUserRequest postUserRequest);
}
