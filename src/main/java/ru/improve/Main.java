package ru.improve;

import ru.improve.config.JdbcTemplateInstance;
import ru.improve.dao.PersonDao;
import ru.improve.models.Person;

public class Main {

    public static void main(String[] args) {
        PersonDao personDao = new PersonDao(JdbcTemplateInstance.getInstance());

        Person person = new Person("personName5", "personSecondName5", "77777777705");

        personDao.addPerson(person);
    }
}