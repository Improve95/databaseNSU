package ru.improve.abs.configuration.security;

import lombok.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;

import java.util.List;

@Value
@ConfigurationProperties(prefix = "spring.cache")
public class CacheConfig {

    private List<String> cacheNames;
}
