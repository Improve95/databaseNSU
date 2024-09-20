package ru.improve.util;

import ru.improve.Main;
import ru.improve.dao.PersonDao;
import ru.improve.models.Person;
import ru.improve.util.parser.CsvParser;
import ru.improve.util.parser.RecordsReader;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.stream.Collectors;

public class FillTables {

    private final String pathToFiles = "../../dataForTable/";

    PersonDao personDao = new PersonDao();

    public void fill() {
        RecordsReader recordsReader = new RecordsReader();
        CsvParser csvParser = new CsvParser();

        try (InputStream inputStream = Main.class.getResourceAsStream(pathToFiles + "person.txt")) {
            List<Person> personList = recordsReader.getObjectList(csvParser.parse(inputStream), Person.class, 1)
                    .stream()
                    .map(object -> (Person) object)
                    .collect(Collectors.toList());
            personDao.addPeople(personList);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        /*try (InputStream inputStream = Main.class.getResourceAsStream("../../dataForTable/passport.txt")) {
            List<Object> personList = recordsReader.getObjectList(csvParser.parse(inputStream), Person.class, 0);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        try (InputStream inputStream = Main.class.getResourceAsStream("../../dataForTable/polis.txt")) {
            List<Object> personList = recordsReader.getObjectList(csvParser.parse(inputStream), Person.class, 0);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        try (InputStream inputStream = Main.class.getResourceAsStream("../../dataForTable/staff.txt")) {
            List<Object> personList = recordsReader.getObjectList(csvParser.parse(inputStream), Person.class, 1);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }*/
    }
}
