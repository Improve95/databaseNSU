package ru.improve.abs.api.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.ReportingPolicy;
import ru.improve.abs.api.dto.user.GetUserResponse;
import ru.improve.abs.api.dto.user.PostUserRequest;
import ru.improve.abs.api.dto.user.PostUserResponse;
import ru.improve.abs.core.model.User;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING,
        unmappedSourcePolicy = ReportingPolicy.IGNORE,
        unmappedTargetPolicy = ReportingPolicy.IGNORE
)
public interface UserMapper {

    User toUser(PostUserRequest postUserRequest);

    PostUserResponse toPostUserResponse(User user);

    GetUserResponse toGetUserResponse(User user);
}
