package ru.improve.dao;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import ru.improve.models.Person;

@RequiredArgsConstructor
public class PatientDao {

    private final JdbcTemplate jdbcTemplate;

    public void addPatient(Person person) {
        jdbcTemplate.update("insert into patient (name, second_name, phone) values (?, ?, ?)",
                person.getName(), person.getSecondName(), person.getPhone());
    }
}
