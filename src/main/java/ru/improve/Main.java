package ru.improve;

import ru.improve.models.Person;
import ru.improve.util.CsvParser;
import ru.improve.util.FillTables;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

public class Main {

    public static void main(String[] args) {
        FillTables fillTables = new FillTables();
        CsvParser csvParser = new CsvParser();

        try (InputStream inputStream = Main.class.getResourceAsStream("../../dataForTable/person.txt")) {
            List<String[]> people = csvParser.parse(inputStream);
            List<Object> personList = fillTables.fillPersonTable(people);

            for (Object person : personList) {
                Person person1 = (Person) person;
                System.out.println(person1);
            }

        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}