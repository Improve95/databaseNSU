package ru.improve.abs.api.dto.credit;

import lombok.Builder;
import lombok.Data;
import lombok.extern.jackson.Jacksonized;

import java.time.Instant;

@Data
@Builder
@Jacksonized
public class CreditRequestResponse {

    private long id;

    private int creditTariffId;

    private int userId;

    private Instant createdAt;
}
