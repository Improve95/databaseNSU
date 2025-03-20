package ru.improve.abs.core.service;

import ru.improve.abs.model.Session;
import ru.improve.abs.model.User;

public interface SessionService {

    Session create(User user);

    boolean checkSessionEnableById(long id);

    boolean checkSessionEnable(Session session);

    void setUserSessionDisable(User user);
}
