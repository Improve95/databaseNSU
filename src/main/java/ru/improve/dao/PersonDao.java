package ru.improve.dao;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import ru.improve.config.JdbcTemplateInstance;
import ru.improve.models.Person;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

@RequiredArgsConstructor
public class PersonDao {

    private final JdbcTemplate jdbcTemplate = JdbcTemplateInstance.getInstance();

    public void addPerson(Person person) {
        jdbcTemplate.update("insert into person (name, second_name, phone) values (?, ?, ?)",
                person.getName(), person.getSecondName(), person.getPhone());
    }

    public void addPeople(List<Person> personList) {
        jdbcTemplate.batchUpdate("insert into person (name, second_name, phone) values (?, ?, ?)",
                new BatchPreparedStatementSetter() {
                    @Override
                    public void setValues(PreparedStatement ps, int i) throws SQLException {
                        Person person = personList.get(i);
                        ps.setString(1, person.getName());
                        ps.setString(2, person.getSecondName());
                        ps.setString(3, person.getPhone());
                    }

                    @Override
                    public int getBatchSize() {
                        return personList.size();
                    }
                });
    }
}
