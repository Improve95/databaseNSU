package ru.improve.abs.core.configuration.security;

import com.nimbusds.jose.jwk.OctetSequenceKey;
import com.nimbusds.jose.jwk.source.ImmutableSecret;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.oauth2.jwt.NimbusJwtEncoder;

import javax.crypto.SecretKey;

@Configuration
public class AuthServerConfig {

     @Bean
     public JwtDecoder jwtDecoder(SecretKey secretKey) {
          return NimbusJwtDecoder.withSecretKey(secretKey).build();
     }

     @Bean
     public JwtEncoder jwtEncoder(SecretKey secretKey) {
          return new NimbusJwtEncoder(new ImmutableSecret<>(secretKey));
     }

     @Bean
     public SecretKey secretKey(TokenConfig tokenConfiguration) {
          return new OctetSequenceKey.Builder(tokenConfiguration.getSecret().getBytes()).build().toSecretKey();
     }
}
