package ru.improve.abs.api.dto.credit;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class PostCreditRequestRequest {

    @NotNull
    @Min(0)
    private int creditTariffId;

    @NotNull
    @Min(0)
    private BigDecimal creditAmount;

    @NotNull
    @Min(0)
    private long creditDuration;
}
