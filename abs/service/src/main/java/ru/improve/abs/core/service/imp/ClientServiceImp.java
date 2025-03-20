package ru.improve.abs.core.service.imp;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import ru.improve.abs.api.dto.client.PostClientRequest;
import ru.improve.abs.api.dto.client.PostClientResponse;
import ru.improve.abs.api.exception.ServiceException;
import ru.improve.abs.api.mapper.ClientMapper;
import ru.improve.abs.core.repository.ClientRepository;
import ru.improve.abs.core.security.service.RoleService;
import ru.improve.abs.core.service.ClientService;
import ru.improve.abs.model.Client;
import ru.improve.abs.model.Role;
import ru.improve.abs.model.User;
import ru.improve.abs.util.database.DatabaseUtil;

import static ru.improve.abs.api.exception.ErrorCode.ALREADY_EXIST;
import static ru.improve.abs.api.exception.ErrorCode.INTERNAL_SERVER_ERROR;
import static ru.improve.abs.core.security.SecurityUtil.CLIENT_ROLE;
import static ru.improve.abs.core.security.SecurityUtil.getUserFromAuthentication;

@RequiredArgsConstructor
@Service
public class ClientServiceImp implements ClientService {

    private final ClientRepository clientRepository;

    private final RoleService roleService;

    private final ClientMapper clientMapper;

    @Transactional
    @Override
    public PostClientResponse createNewClient(PostClientRequest postClientRequest) {
        User user = getUserFromAuthentication();

        Client existClient = user.getClient();
        if (existClient != null) {
            return clientMapper.toPostClientResponse(existClient);
        }

        Role clientRole = roleService.findRoleByName(CLIENT_ROLE);
        user.getRoles().add(clientRole);

        Client client = clientMapper.toClient(postClientRequest);
        client.setUserId(user.getId());

        try {
            client = clientRepository.save(client);
        } catch (DataIntegrityViolationException ex) {
            if (DatabaseUtil.isUniqueConstraintException(ex)) {
                throw new ServiceException(ALREADY_EXIST, "client", "id");
            }
            throw new ServiceException(INTERNAL_SERVER_ERROR, ex);
        }

        return clientMapper.toPostClientResponse(client);
    }
}
