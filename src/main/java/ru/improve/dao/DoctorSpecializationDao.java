package ru.improve.dao;

import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import ru.improve.config.JdbcTemplateInstance;
import ru.improve.models.Doctor;
import ru.improve.models.DoctorSpecialization;
import ru.improve.models.Person;

import javax.print.Doc;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

public class DoctorSpecializationDao {

    private final JdbcTemplate jdbcTemplate = JdbcTemplateInstance.getInstance();

    public void addDoctorSpecialization(DoctorSpecialization doctorSpecialization) {
        jdbcTemplate.update("insert into doctor_specialization (doctor_id, specialization_id) values (?, ?)",
                doctorSpecialization.getDoctorId(), doctorSpecialization.getSpecializationId());
    }

    public void addDoctorSpecializations(List<DoctorSpecialization> doctorSpecializationList) {
        jdbcTemplate.batchUpdate("insert into doctor_specialization (doctor_id, specialization_id) values (?, ?)",
                new BatchPreparedStatementSetter() {
                    @Override
                    public void setValues(PreparedStatement ps, int i) throws SQLException {
                        DoctorSpecialization doctorSpecialization = doctorSpecializationList.get(i);
                        ps.setInt(1, doctorSpecialization.getDoctorId());
                        ps.setInt(2, doctorSpecialization.getSpecializationId());
                    }

                    @Override
                    public int getBatchSize() {
                        return doctorSpecializationList.size();
                    }
                });
    }

    public void truncateTable() {
        jdbcTemplate.update("truncate table doctor_specialization cascade");
    }
}
