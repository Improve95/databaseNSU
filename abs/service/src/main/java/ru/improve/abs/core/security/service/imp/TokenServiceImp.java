package ru.improve.abs.core.security.service.imp;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.JwsHeader;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtClaimsSet;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.JwtEncoderParameters;
import org.springframework.security.oauth2.jwt.JwtException;
import org.springframework.stereotype.Service;
import ru.improve.abs.api.exception.ServiceException;
import ru.improve.abs.core.security.service.TokenService;
import ru.improve.abs.model.Session;

import static ru.improve.abs.api.exception.ErrorCode.ILLEGAL_VALUE;
import static ru.improve.abs.core.security.SecurityUtil.SESSION_ID_CLAIM;
import static ru.improve.abs.util.message.MessageKeys.SESSION_TOKEN_INVALID;

@RequiredArgsConstructor
@Service
public class TokenServiceImp implements TokenService {

    private final JwtEncoder jwtEncoder;

    private final JwtDecoder jwtDecoder;

    @Override
    public Jwt generateToken(UserDetails userDetails, Session session) {
        JwtClaimsSet claims = JwtClaimsSet.builder()
                .subject(userDetails.getUsername())
                .issuedAt(session.getIssuedAt())
                .expiresAt(session.getExpiredAt())
                .claim(SESSION_ID_CLAIM, session.getId())
                .build();
        JwsHeader jwsHeader = JwsHeader.with(MacAlgorithm.HS256).build();
        return jwtEncoder.encode(JwtEncoderParameters.from(jwsHeader, claims));
    }

    @Override
    public long getSessionId(Jwt jwt) {
        return jwt.getClaim(SESSION_ID_CLAIM);
    }

    @Override
    public Jwt parseJwt(String jwt) {
        try {
            return jwtDecoder.decode(jwt);
        } catch (JwtException ex) {
            throw new ServiceException(ILLEGAL_VALUE, SESSION_TOKEN_INVALID, ex.getCause());
        }
    }
}
