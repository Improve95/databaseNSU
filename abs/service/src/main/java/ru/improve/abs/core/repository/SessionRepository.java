package ru.improve.abs.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.improve.abs.core.model.Session;
import ru.improve.abs.core.model.User;

import java.util.Optional;

public interface SessionRepository extends JpaRepository<Session, Long> {

    Optional<Session> findByUserAndIsEnable(User user, boolean isEnable);
}
