package ru.improve.abs.core.security;

import lombok.experimental.UtilityClass;
import org.springframework.security.core.context.SecurityContextHolder;
import ru.improve.abs.model.User;

@UtilityClass
public class SecurityUtil {

    public static final String SESSION_ID_CLAIM = "sessionId";

    public static final String CLIENT_ROLE = "ROLE_CLIENT";

    public static final String OPERATOR_ROLE = "ROLE_OPERATOR";

    public static final String ADMIN_ROLE = "ROLE_ADMIN";

    public static User getUserFromAuthentication() {
        return (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
    }
}
