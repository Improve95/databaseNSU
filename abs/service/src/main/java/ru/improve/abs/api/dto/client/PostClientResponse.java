package ru.improve.abs.api.dto.client;

import lombok.Builder;
import lombok.Data;
import lombok.extern.jackson.Jacksonized;

@Data
@Builder
@Jacksonized
public class PostClientResponse {

    private int userId;
}
