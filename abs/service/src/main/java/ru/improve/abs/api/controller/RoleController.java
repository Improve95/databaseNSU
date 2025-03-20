package ru.improve.abs.api.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.improve.abs.api.controller.spec.RoleControllerSpec;

import static ru.improve.abs.api.ApiPaths.ROLES;

@RestController
@RequiredArgsConstructor
@RequestMapping(ROLES)
public class RoleController implements RoleControllerSpec {

}
