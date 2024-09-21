package ru.improve.dao;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import ru.improve.config.JdbcTemplateInstance;
import ru.improve.models.Doctor;
import ru.improve.models.Person;
import ru.improve.models.staff.Staff;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

@RequiredArgsConstructor
public class DoctorDao {

    private final JdbcTemplate jdbcTemplate = JdbcTemplateInstance.getInstance();

    public void addDoctor(Doctor doctor) {
        jdbcTemplate.update("insert into doctor (staff_id) values (?)",
                doctor.getId());
    }

    public void addDoctors(List<Doctor> doctorList) {
        jdbcTemplate.batchUpdate("insert into doctor (staff_id) values (?)",
                new BatchPreparedStatementSetter() {
                    @Override
                    public void setValues(PreparedStatement ps, int i) throws SQLException {
                        Doctor doctor = doctorList.get(i);
                        ps.setInt(1, doctor.getId());
                    }

                    @Override
                    public int getBatchSize() {
                        return doctorList.size();
                    }
                });
    }

    public void truncateTable() {
        jdbcTemplate.update("truncate table doctor cascade");
    }
}
