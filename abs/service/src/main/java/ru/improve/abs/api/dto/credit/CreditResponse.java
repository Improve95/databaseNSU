package ru.improve.abs.api.dto.credit;

import lombok.Builder;
import lombok.Data;
import lombok.extern.jackson.Jacksonized;
import ru.improve.abs.model.credit.CreditStatus;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@Builder
@Jacksonized
public class CreditResponse {

    private long id;

    private BigDecimal initialAmount;

    private LocalDate takingDate;

    private int percent;

    private int creditPeriod;

    private BigDecimal monthAmount;

    private CreditStatus creditStatus;

    private int userId;

    private int creditTariffId;
}
