package ru.improve.abs.core.service;

import ru.improve.abs.api.dto.role.RoleResponse;
import ru.improve.abs.model.Role;

import java.util.List;

public interface RoleService {

    List<RoleResponse> getResponseList();

    Role findRoleById(int id);

    Role findRoleByName(String name);
}
