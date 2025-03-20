package ru.improve.abs.api.dto.user;

import lombok.Builder;
import lombok.Data;
import lombok.extern.jackson.Jacksonized;

@Data
@Builder
@Jacksonized
public class UserResponse {

    private int id;

    private String email;

    private String name;

    private String employment;
}
