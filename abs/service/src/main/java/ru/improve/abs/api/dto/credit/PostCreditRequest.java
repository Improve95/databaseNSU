package ru.improve.abs.api.dto.credit;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class PostCreditRequest {

    @NotNull
    @Positive
    private BigDecimal initialAmount;

    @NotNull
    @Positive
    private int percent;

    @NotNull
    private int creditPeriod;

    @NotNull
    @Positive
    private BigDecimal monthAmount;

    @NotNull
    @Positive
    private int userId;

    @NotNull
    @Positive
    private int tariffId;
}
