package ru.improve.abs.api.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.improve.abs.api.controller.spec.RoleControllerSpec;
import ru.improve.abs.api.dto.role.RoleResponse;

import java.util.List;

import static ru.improve.abs.api.ApiPaths.ROLES;

@RestController
@RequiredArgsConstructor
@RequestMapping(ROLES)
public class RoleController implements RoleControllerSpec {

    @GetMapping
    public ResponseEntity<List<RoleResponse>> getRoleList() {
        return ResponseEntity.ok(null);
    }
}
