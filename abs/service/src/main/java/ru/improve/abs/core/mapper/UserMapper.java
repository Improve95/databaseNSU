package ru.improve.abs.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.mapstruct.ReportingPolicy;
import ru.improve.abs.api.dto.user.SignInRequest;
import ru.improve.abs.api.dto.user.SignInResponse;
import ru.improve.abs.api.dto.user.UserResponse;
import ru.improve.abs.model.User;

import static ru.improve.abs.core.mapper.MapperUtil.GET_ROLES_ID_FUNC_NAME;
import static ru.improve.abs.core.mapper.MapperUtil.MAPPER_UTIL_NAME;

@Mapper(
        componentModel = MappingConstants.ComponentModel.SPRING,
        unmappedSourcePolicy = ReportingPolicy.IGNORE,
        unmappedTargetPolicy = ReportingPolicy.IGNORE,
        uses = MapperUtil.class
)
public interface UserMapper {


    User toUser(SignInRequest signInRequest);

    SignInResponse toSignInUserResponse(User user);

    @Mapping(
            target = "rolesId",
            qualifiedByName = { MAPPER_UTIL_NAME, GET_ROLES_ID_FUNC_NAME },
            source = "user"
    )
    UserResponse toUserResponse(User user);
}
