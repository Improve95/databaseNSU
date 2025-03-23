package ru.improve.abs.api.dto.credit;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class PostCreditRequest {

    private BigDecimal initialAmount;

    private LocalDate takingDate;

    private int percent;

    private int creditPeriod;

    private BigDecimal monthAmount;

    private int userId;

    private int tariffId;
}
