package ru.improve.abs.api.dto.client;

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
public class PostClientRequest {

    @Schema(
            example = "employment1"
    )
    @NotNull
    @NotBlank
    @Size(min = 5, max = 100)
    private String employment;
}
