package ru.improve.abs.api.dto.login;

import lombok.Builder;
import lombok.Data;
import lombok.extern.jackson.Jacksonized;

@Data
@Builder
@Jacksonized
public class LoginResponse {

    private String accessToken;
}
