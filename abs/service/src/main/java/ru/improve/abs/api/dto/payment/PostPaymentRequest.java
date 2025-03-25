package ru.improve.abs.api.dto.payment;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class PostPaymentRequest {

    @NotNull
    @Positive
    private BigDecimal amount;

    @NotNull
    @Positive
    private long creditId;
}
