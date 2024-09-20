package ru.improve.dao;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import ru.improve.models.Passport;

@RequiredArgsConstructor
public class PassportDao {

    private final JdbcTemplate jdbcTemplate;

    public void addPassport(Passport passport) {
        jdbcTemplate.update("insert into passport values (?, ?, ?)",
                passport.getId(), passport.getNumber(), passport.getSeries());
    }
}
