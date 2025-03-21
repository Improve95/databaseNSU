package ru.improve.abs.api.dto.auth;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class LoginRequest {

    @Schema(
            example = "email1@gmail.com"
    )
    @NotNull
    @NotBlank
    private String login;

    @Schema(
            example = "password1"
    )
    @NotNull
    @NotBlank
    private String password;
}
