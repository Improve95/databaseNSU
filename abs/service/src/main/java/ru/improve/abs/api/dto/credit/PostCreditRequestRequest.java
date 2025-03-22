package ru.improve.abs.api.dto.credit;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class PostCreditRequestRequest {

    @Schema(
            defaultValue = "1"
    )
    @NotNull
    @Positive
    private int creditTariffId;

    @Schema(
            defaultValue = "1000000"
    )
    @NotNull
    @Positive
    private BigDecimal creditAmount;

    @Schema(
            defaultValue = "24"
    )
    @NotNull
    @Positive
    private long creditDuration;
}
