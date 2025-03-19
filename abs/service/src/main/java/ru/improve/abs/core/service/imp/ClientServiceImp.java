package ru.improve.abs.core.service.imp;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import ru.improve.abs.api.dto.client.PostClientResponse;
import ru.improve.abs.api.dto.client.PostClientRequest;
import ru.improve.abs.api.exception.ServiceException;
import ru.improve.abs.api.mapper.ClientMapper;
import ru.improve.abs.core.model.Client;
import ru.improve.abs.core.model.User;
import ru.improve.abs.core.repository.ClientRepository;
import ru.improve.abs.core.service.ClientService;
import ru.improve.abs.util.database.DatabaseUtil;

import static ru.improve.abs.api.exception.ErrorCode.ALREADY_EXIST;
import static ru.improve.abs.api.exception.ErrorCode.INTERNAL_SERVER_ERROR;

@RequiredArgsConstructor
@Service
public class ClientServiceImp implements ClientService {

    private final ClientRepository clientRepository;

    private final ClientMapper clientMapper;

    private final SecurityContext securityContext = SecurityContextHolder.getContext();

    @Transactional
    @Override
    public PostClientResponse createNewClient(PostClientRequest postClientRequest) {
        User user = (User) securityContext.getAuthentication();

        Client client = clientMapper.toClient(postClientRequest);
        client.setId(user.getId());
        client.setUser(user);

        try {
            clientRepository.save(client);
        } catch (DataIntegrityViolationException ex) {
            if (DatabaseUtil.isUniqueConstraintException(ex)) {
                throw new ServiceException(ALREADY_EXIST, "client", "email");
            }
            throw new ServiceException(INTERNAL_SERVER_ERROR, ex);
        }

        return clientMapper.toPostClientResponse(client);
    }
}
