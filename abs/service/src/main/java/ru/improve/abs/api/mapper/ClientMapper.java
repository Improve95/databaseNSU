package ru.improve.abs.api.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.ReportingPolicy;
import ru.improve.abs.api.dto.client.PostClientRequest;
import ru.improve.abs.api.dto.client.PostClientResponse;
import ru.improve.abs.core.model.Client;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING,
        unmappedSourcePolicy = ReportingPolicy.IGNORE,
        unmappedTargetPolicy = ReportingPolicy.IGNORE
)
public interface ClientMapper {

    Client toClient(PostClientRequest postClientRequest);

    PostClientResponse toPostClientResponse(Client client);
}
