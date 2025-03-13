package ru.improve.abs.api.dto.auth;

import lombok.Builder;
import lombok.Data;
import lombok.extern.jackson.Jacksonized;

import java.time.Instant;

@Data
@Builder
@Jacksonized
public class LoginResponse {

    private long id;

    private String accessToken;

    private Instant issuedAt;

    private Instant expiredAt;
}
