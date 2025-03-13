package ru.improve.abs.core.configuration.security;

import lombok.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;

import java.time.Duration;

@Value
@ConfigurationProperties(prefix = "app.session", ignoreUnknownFields = false)
public class SessionConfig {

    private Duration duration;
}
