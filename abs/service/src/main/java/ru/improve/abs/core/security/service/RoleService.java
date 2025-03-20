package ru.improve.abs.core.security.service;

import ru.improve.abs.model.Role;

public interface RoleService {

    Role findRoleById(int id);

    Role findRoleByName(String name);
}
