package ru.improve.abs.api.controller;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Positive;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import ru.improve.abs.api.controller.spec.AdminControllerSpec;
import ru.improve.abs.api.dto.user.UserResponse;
import ru.improve.abs.core.service.UserService;

import static ru.improve.abs.api.ApiPaths.ADMIN;
import static ru.improve.abs.api.ApiPaths.ID;
import static ru.improve.abs.api.ApiPaths.REMOVE;
import static ru.improve.abs.api.ApiPaths.ROLES;
import static ru.improve.abs.api.ApiPaths.ROLE_ID;
import static ru.improve.abs.api.ApiPaths.ADD;
import static ru.improve.abs.api.ApiPaths.USER_ID;
import static ru.improve.abs.core.security.SecurityUtil.ADMIN_ROLE;

@RestController
@RequiredArgsConstructor
@RequestMapping(ADMIN)
@PreAuthorize("hasRole('" + ADMIN_ROLE + "')")
public class AdminController implements AdminControllerSpec {

    private final UserService userService;

    @GetMapping(ID)
    public ResponseEntity<UserResponse> getUserById(@PathVariable @Valid int id) {
        UserResponse getUserResponse = userService.getUserById(id);
        return ResponseEntity.ok(getUserResponse);
    }

    @PostMapping(ROLES + ADD)
    public ResponseEntity<UserResponse> addRoleToUser(
            @Valid @RequestParam(name = USER_ID) @Positive int userId,
            @Valid @RequestParam(name = ROLE_ID) @Positive int roleId
    ) {
        UserResponse userResponse = userService.addRole(userId, roleId);
        return ResponseEntity.ok(userResponse);
    }

    @PostMapping(ROLES + REMOVE)
    public ResponseEntity<UserResponse> removeRoleToUser(
            @Valid @RequestParam(name = USER_ID) @Positive int userId,
            @Valid @RequestParam(name = ROLE_ID) @Positive int roleId
    ) {
        UserResponse userResponse = userService.removeRole(userId, roleId);
        return ResponseEntity.ok(userResponse);
    }
}
