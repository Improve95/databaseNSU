package ru.improve.dao;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import ru.improve.models.Polis;

@RequiredArgsConstructor
public class PolisDao {

    private final JdbcTemplate jdbcTemplate;

    public void addPolis(Polis polis) {
        jdbcTemplate.update("insert into polis (patient_id, number) values (?, ?)",
                polis.getPatientId(), polis.getNumber());
    }
}
