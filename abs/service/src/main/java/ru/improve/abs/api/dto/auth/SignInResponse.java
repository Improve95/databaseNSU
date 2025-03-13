package ru.improve.abs.api.dto.auth;

import lombok.Builder;
import lombok.Data;
import lombok.extern.jackson.Jacksonized;

@Data
@Builder
@Jacksonized
public class SignInResponse {

    private int id;
}
