package ru.improve.abs.core.service.imp;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import ru.improve.abs.api.exception.ServiceException;
import ru.improve.abs.core.configuration.security.SessionConfig;
import ru.improve.abs.core.model.Session;
import ru.improve.abs.core.model.User;
import ru.improve.abs.core.repository.SessionRepository;
import ru.improve.abs.core.service.SessionService;

import java.time.Instant;

import static ru.improve.abs.api.exception.ErrorCode.NOT_FOUND;

@RequiredArgsConstructor
@Service
public class SessionServiceImp implements SessionService {

    private final SessionRepository sessionRepository;

    private final SessionConfig sessionConfig;

    @Transactional
    @Override
    public Session create(User user) {
        setUserSessionDisable(user);
        Session session = Session.builder()
                .expiredAt(Instant.now().plus(sessionConfig.getDuration()))
                .user(user)
                .build();
        sessionRepository.save(session);
        return session;
    }

    @Transactional
    @Override
    public boolean checkSessionEnableById(long id) {
        Session session = sessionRepository.findById(id).orElseThrow(
                () -> new ServiceException(NOT_FOUND, "session", "id"));

        return checkSessionEnable(session);
    }

    @Override
    public boolean checkSessionEnable(Session session) {
        Instant nowTime = Instant.now();
        if (nowTime.isAfter(session.getExpiredAt())) {
            session.setEnable(false);
        }
        return session.isEnable();
    }

    @Transactional
    @Override
    public void setUserSessionDisable(User user) {
        sessionRepository.findByUserAndIsEnable(user, true)
                .ifPresent(session -> session.setEnable(false));
    }
}
