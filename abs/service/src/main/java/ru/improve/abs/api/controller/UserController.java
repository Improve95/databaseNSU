package ru.improve.abs.api.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.improve.abs.api.dto.user.GetUserResponse;
import ru.improve.abs.api.dto.user.PostUserRequest;
import ru.improve.abs.api.dto.user.PostUserResponse;
import ru.improve.abs.core.service.UserService;

import static ru.improve.abs.api.ApiPaths.ID;
import static ru.improve.abs.api.ApiPaths.USERS;

@RestController
@RequiredArgsConstructor
@RequestMapping(USERS)
public class UserController {

    private final UserService userService;

    @GetMapping(ID)
    public ResponseEntity<GetUserResponse> getUserById(@PathVariable @Valid int id) {
        GetUserResponse getUserResponse = userService.getUserById(id);
        return ResponseEntity.ok(getUserResponse);
    }

    @GetMapping()
    public ResponseEntity<GetUserResponse> getUserByAuth() {
        GetUserResponse getUserResponse = userService.getUserByAuth();
        return ResponseEntity.ok(getUserResponse);
    }

    @PostMapping()
    public ResponseEntity<PostUserResponse> createUser(@RequestBody @Valid PostUserRequest postUserRequest) {
        PostUserResponse postUserResponse = userService.createNewUser(postUserRequest);
        return ResponseEntity.ok(postUserResponse);
    }
}
