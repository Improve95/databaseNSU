package ru.improve.abs.api.dto.auth;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Builder;
import lombok.Data;
import lombok.extern.jackson.Jacksonized;

@Data
@Builder
@Jacksonized
public class SignInRequest {

    @NotNull
    @NotBlank
    @Size(min = 5, max = 50)
    private String name;

    @Schema(
            example = "email1@gmail.com"
    )
    @NotNull
    @NotBlank
    @Size(min = 5, max = 100)
    private String email;

    @Schema(
            example = "password1"
    )
    @NotNull
    @NotBlank
    @Size(min = 8, max = 50)
    private String password;
}
