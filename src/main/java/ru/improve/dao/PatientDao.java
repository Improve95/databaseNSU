package ru.improve.dao;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import ru.improve.config.JdbcTemplateInstance;
import ru.improve.models.Person;
import ru.improve.models.patient.Patient;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.ZoneId;
import java.util.List;

@RequiredArgsConstructor
public class PatientDao {

    private final JdbcTemplate jdbcTemplate = JdbcTemplateInstance.getInstance();

    public void addPatient(Patient patient) {
        jdbcTemplate.update("insert into patient (coming_time, release_time, doctor_id, status, person_id) values (?, ?, ?, ?, ?)",
                patient.getComingTime(), patient.getReleaseTime(), patient.getDoctorId(), patient.getStatus(), patient.getPersonId());
    }

    public void addPatients(List<Patient> patientList) {
        jdbcTemplate.batchUpdate("insert into patient (coming_time, release_time, doctor_id, status, person_id) values (?, ?, ?, ?, ?)",
                new BatchPreparedStatementSetter() {
                    @Override
                    public void setValues(PreparedStatement ps, int i) throws SQLException {
                        Patient patient = patientList.get(i);
                        ps.setTimestamp(1, Timestamp.valueOf(patient.getComingTime()));
                        ps.setDate(2, null);
                        ps.setInt(3, patient.getDoctorId());
                        ps.setObject(4, patient.getStatus(), java.sql.Types.OTHER);
                        ps.setInt(5, patient.getPersonId());
                    }

                    @Override
                    public int getBatchSize() {
                        return patientList.size();
                    }
                });
    }

    public void truncateTable() {
        jdbcTemplate.update("alter sequence patient_id_seq restart with 1");
        jdbcTemplate.update("truncate table patient cascade");
    }
}
