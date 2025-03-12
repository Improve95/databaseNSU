package ru.improve.abs.api.dto.user;

import lombok.Builder;
import lombok.Data;
import lombok.extern.jackson.Jacksonized;

@Data
@Builder
@Jacksonized
public class GetUserResponse {

    private int id;

    private String name;

    private String email;

    private String employment;
}
