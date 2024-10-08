package ru.improve.dao;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import ru.improve.config.JdbcTemplateInstance;
import ru.improve.models.staff.Staff;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

@RequiredArgsConstructor
public class StaffDao {

    private final JdbcTemplate jdbcTemplate = JdbcTemplateInstance.getInstance();

    public void addStaff(Staff staff) {
        jdbcTemplate.update("insert into staff (id, salary, department_id, position) values (?, ?, ?, ?)",
                staff.getId(), staff.getSalary(), staff.getDepartmentId(), staff.getPosition());
    }

    public void addStaffs(List<Staff> staffList) {
        jdbcTemplate.batchUpdate("insert into staff (id, salary, department_id, position) values (?, ?, ?, ?)",
                new BatchPreparedStatementSetter() {
                    @Override
                    public void setValues(PreparedStatement ps, int i) throws SQLException {
                        Staff staff = staffList.get(i);
                        ps.setInt(1, staff.getId());
                        ps.setInt(2, staff.getSalary());
                        ps.setInt(3, staff.getDepartmentId());
                        ps.setObject(4, staff.getPosition().name(), java.sql.Types.OTHER);
                    }

                    @Override
                    public int getBatchSize() {
                        return staffList.size();
                    }
                });
    }

    public void truncateTable() {
        jdbcTemplate.update("truncate table staff cascade");
    }
}
