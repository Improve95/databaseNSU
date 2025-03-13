package ru.improve.abs.api.dto.auth;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.extern.jackson.Jacksonized;

@Data
@Jacksonized
public class LoginRequest {

    @NotNull
    @NotBlank
    private String login;

    @NotNull
    @NotBlank
    private String password;
}
