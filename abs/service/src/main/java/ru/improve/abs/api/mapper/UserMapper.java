package ru.improve.abs.api.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.ReportingPolicy;
import ru.improve.abs.api.dto.user.GetUserResponse;
import ru.improve.abs.api.dto.auth.SignInRequest;
import ru.improve.abs.api.dto.auth.SignInResponse;
import ru.improve.abs.model.User;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING,
        unmappedSourcePolicy = ReportingPolicy.IGNORE,
        unmappedTargetPolicy = ReportingPolicy.IGNORE
)
public interface UserMapper {

    User toUser(SignInRequest signInRequest);

    SignInResponse toSignInUserResponse(User user);

    GetUserResponse toGetUserResponse(User user);
}
