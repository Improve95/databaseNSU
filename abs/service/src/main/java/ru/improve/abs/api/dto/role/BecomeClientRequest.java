package ru.improve.abs.api.dto.role;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;
import lombok.extern.jackson.Jacksonized;

@Data
@Jacksonized
public class BecomeClientRequest {

    @NotNull
    @NotBlank
    @Size(min = 5, max = 100)
    private String employment;
}
