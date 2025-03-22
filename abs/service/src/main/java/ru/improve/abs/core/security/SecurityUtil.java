package ru.improve.abs.core.security;

import lombok.experimental.UtilityClass;

@UtilityClass
public class SecurityUtil {

    public static final String SESSION_ID_CLAIM = "sessionId";

    public static final String CLIENT_ROLE = "ROLE_CLIENT";

    public static final String OPERATOR_ROLE = "ROLE_OPERATOR";

    public static final String ADMIN_ROLE = "ROLE_ADMIN";
}
