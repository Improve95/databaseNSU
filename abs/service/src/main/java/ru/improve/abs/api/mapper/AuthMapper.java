package ru.improve.abs.api.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.ReportingPolicy;
import ru.improve.abs.api.dto.auth.LoginResponse;
import ru.improve.abs.core.model.Session;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING,
        unmappedSourcePolicy = ReportingPolicy.IGNORE,
        unmappedTargetPolicy = ReportingPolicy.IGNORE
)
public interface AuthMapper {

    LoginResponse toLoginResponse(Session session);
}
