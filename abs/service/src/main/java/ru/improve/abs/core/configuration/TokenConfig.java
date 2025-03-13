package ru.improve.abs.core.configuration;

import lombok.Data;
import lombok.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;

@Value
@ConfigurationProperties(prefix = "app.token")
public class TokenConfig {

    private String secret;
}
