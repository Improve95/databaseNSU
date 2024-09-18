package ru.improve.dao;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import ru.improve.models.Person;

@RequiredArgsConstructor
public class PersonDao {

    private final JdbcTemplate jdbcTemplate;

    public void addPeople(Person person) {
        jdbcTemplate.update("insert into person (name, second_name, phone) values (?, ?, ?)",
                person.getName(), person.getSecondName(), person.getPhone());
    }
}
