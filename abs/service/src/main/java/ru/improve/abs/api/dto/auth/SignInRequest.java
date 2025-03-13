package ru.improve.abs.api.dto.auth;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;
import lombok.extern.jackson.Jacksonized;

@Data
@Jacksonized
public class SignInRequest {

    @NotNull
    @NotBlank
    @Size(min = 5, max = 50)
    private String name;

    @NotNull
    @NotBlank
    @Size(min = 5, max = 100)
    private String email;

    @NotNull
    @NotBlank
    @Size(min = 8, max = 50)
    private String password;
}
