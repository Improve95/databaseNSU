package ru.improve.abs.core.service;

import ru.improve.abs.api.dto.client.PostClientResponse;
import ru.improve.abs.api.dto.client.PostClientRequest;

public interface ClientService {

    PostClientResponse createNewClient(PostClientRequest postClientRequest);
}
