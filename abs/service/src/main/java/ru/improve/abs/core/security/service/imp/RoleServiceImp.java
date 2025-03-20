package ru.improve.abs.core.security.service.imp;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import ru.improve.abs.api.exception.ServiceException;
import ru.improve.abs.core.repository.RoleRepository;
import ru.improve.abs.core.security.service.RoleService;
import ru.improve.abs.model.Role;

import static ru.improve.abs.api.exception.ErrorCode.NOT_FOUND;

@RequiredArgsConstructor
@Service
public class RoleServiceImp implements RoleService {

    private final RoleRepository roleRepository;

    @Transactional
    @Override
    public Role findRoleById(int id) {
        return roleRepository.findById(id)
                .orElseThrow(() -> new ServiceException(NOT_FOUND, "role", "id"));
    }

    @Transactional
    @Override
    public Role findRoleByName(String name) {
        return roleRepository.findByName(name)
                .orElseThrow(() -> new ServiceException(NOT_FOUND, "role", "email"));
    }
}
