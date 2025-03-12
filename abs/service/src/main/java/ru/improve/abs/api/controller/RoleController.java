package ru.improve.abs.api.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.improve.abs.api.dto.role.BecomeClientRequest;

import static ru.improve.abs.api.ApiPaths.BECOME;
import static ru.improve.abs.api.ApiPaths.CLIENT;
import static ru.improve.abs.api.ApiPaths.ROLES;

@RestController
@RequiredArgsConstructor
@RequestMapping(ROLES)
public class RoleController {

    @PostMapping(BECOME + CLIENT)
    public ResponseEntity<Void> becomeClient(@RequestBody @Valid BecomeClientRequest becomeClientRequest) {
        return ResponseEntity.ok().build();
    }
}
