package ru.improve.config;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import java.util.Properties;

public class JdbcTemplateInstance {

    private static DriverManagerDataSource dataSource;

    private static JdbcTemplate jdbcTemplate;

    public static JdbcTemplate getInstance() {
        if (jdbcTemplate != null) {
            return jdbcTemplate;
        }

        Properties properties = Property.getInstance();

        dataSource = new DriverManagerDataSource();
        dataSource.setUrl(properties.getProperty("database.connection.url"));
        dataSource.setUsername(properties.getProperty("database.connection.username"));
        dataSource.setPassword(properties.getProperty("database.connection.password"));

        jdbcTemplate = new JdbcTemplate(dataSource);
        return jdbcTemplate;
    }
}
