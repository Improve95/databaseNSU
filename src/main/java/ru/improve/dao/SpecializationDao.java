package ru.improve.dao;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import ru.improve.config.JdbcTemplateInstance;
import ru.improve.models.Specialization;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

@RequiredArgsConstructor
public class SpecializationDao {

    private final JdbcTemplate jdbcTemplate = JdbcTemplateInstance.getInstance();

    public void addSpecialization(Specialization specialization) {
        jdbcTemplate.update("insert into specialization (name) values (?)",
                specialization.getName());
    }

    public void addSpecializations(List<Specialization> specializationList) {
        jdbcTemplate.batchUpdate("insert into specialization (name) values (?)",
                new BatchPreparedStatementSetter() {
                    @Override
                    public void setValues(PreparedStatement ps, int i) throws SQLException {
                        Specialization specialization = specializationList.get(i);
                        ps.setString(1, specialization.getName());
                    }

                    @Override
                    public int getBatchSize() {
                        return specializationList.size();
                    }
                });
    }

    public void truncateTable() {
        jdbcTemplate.update("alter sequence specialization_id_seq restart with 1");
        jdbcTemplate.update("truncate table specialization cascade");
    }
}
