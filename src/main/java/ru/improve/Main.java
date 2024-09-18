package ru.improve;

import ru.improve.config.JdbcTemplateInstance;
import ru.improve.dao.PersonDao;

public class Main {
    public static void main(String[] args) {

        PersonDao personDao = new PersonDao(JdbcTemplateInstance.getInstance());
    }
}