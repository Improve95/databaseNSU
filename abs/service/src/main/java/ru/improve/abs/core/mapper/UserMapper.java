package ru.improve.abs.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.mapstruct.ReportingPolicy;
import ru.improve.abs.api.dto.user.GetUserResponse;
import ru.improve.abs.api.dto.user.SignInRequest;
import ru.improve.abs.api.dto.user.SignInResponse;
import ru.improve.abs.api.dto.user.UserResponse;
import ru.improve.abs.model.User;

@Mapper(
        componentModel = MappingConstants.ComponentModel.SPRING,
        unmappedSourcePolicy = ReportingPolicy.IGNORE,
        unmappedTargetPolicy = ReportingPolicy.IGNORE,
        uses = MapperUtil.class
)
public interface UserMapper {

    User toUser(SignInRequest signInRequest);

    SignInResponse toSignInUserResponse(User user);

    GetUserResponse toGetUserResponse(User user);

    @Mapping(
            target = "rolesId",
            qualifiedByName = {"MapperUtil", "getRolesId"},
            source = "user"
    )
    UserResponse toUserResponse(User user);
}
