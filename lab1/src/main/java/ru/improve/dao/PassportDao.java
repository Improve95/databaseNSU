package ru.improve.dao;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import ru.improve.config.JdbcTemplateInstance;
import ru.improve.models.Passport;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

@RequiredArgsConstructor
public class PassportDao {

    private final JdbcTemplate jdbcTemplate = JdbcTemplateInstance.getInstance();

    public void addPassport(Passport passport) {
        jdbcTemplate.update("insert into passport values (?, ?, ?)",
                passport.getPersonId(), passport.getNumber(), passport.getSeries());
    }

    public void addPassports(List<Passport> passportList) {
        jdbcTemplate.batchUpdate("insert into passport (person_id, number, series) values (?, ?, ?)",
                new BatchPreparedStatementSetter() {
                    @Override
                    public void setValues(PreparedStatement ps, int i) throws SQLException {
                        Passport passport = passportList.get(i);
                        ps.setInt(1, passport.getPersonId());
                        ps.setInt(2, passport.getNumber());
                        ps.setInt(3, passport.getSeries());
                    }

                    @Override
                    public int getBatchSize() {
                        return passportList.size();
                    }
                });
    }

    public void truncateTable() {
        jdbcTemplate.update("truncate table passport cascade");
    }
}
