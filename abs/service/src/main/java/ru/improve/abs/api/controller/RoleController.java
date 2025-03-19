package ru.improve.abs.api.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.improve.abs.api.dto.client.PostClientResponse;
import ru.improve.abs.api.dto.client.PostClientRequest;
import ru.improve.abs.core.service.ClientService;

import static ru.improve.abs.api.ApiPaths.BECOME;
import static ru.improve.abs.api.ApiPaths.CLIENT;
import static ru.improve.abs.api.ApiPaths.ROLES;

@RestController
@RequiredArgsConstructor
@RequestMapping(ROLES)
public class RoleController {

    private final ClientService clientServiceImp;

    @PostMapping(BECOME + CLIENT)
    public ResponseEntity<PostClientResponse> becomeClient(@RequestBody @Valid PostClientRequest postClientRequest) {
        PostClientResponse postClientResponse = clientServiceImp.createNewClient(postClientRequest);
        return ResponseEntity.ok(postClientResponse);
    }
}
