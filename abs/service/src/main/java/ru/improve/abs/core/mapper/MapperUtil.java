package ru.improve.abs.core.mapper;

import lombok.experimental.UtilityClass;
import org.mapstruct.Named;
import ru.improve.abs.model.Role;
import ru.improve.abs.model.User;

import java.util.Set;
import java.util.stream.Collectors;

@Named("MapperUtil")
@UtilityClass
public class MapperUtil {

    @Named("getRolesId")
    public static Set<Integer> getRolesId(User user) {
        return user.getRoles().stream()
                .map(Role::getId)
                .collect(Collectors.toSet());
    }
}
