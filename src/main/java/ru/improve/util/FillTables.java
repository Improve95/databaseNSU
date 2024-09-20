package ru.improve.util;

import ru.improve.Main;
import ru.improve.dao.PassportDao;
import ru.improve.dao.PersonDao;
import ru.improve.models.Passport;
import ru.improve.util.parser.CsvParser;
import ru.improve.util.parser.RecordsReader;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.stream.Collectors;

public class FillTables {

    private final String pathToFiles = "../../dataForTable/";

    PersonDao personDao = new PersonDao();
    PassportDao passportDao = new PassportDao();

    public void fill() {
        RecordsReader recordsReader = new RecordsReader();
        CsvParser csvParser = new CsvParser();

        /*try (InputStream inputStream = Main.class.getResourceAsStream(pathToFiles + "person.txt")) {
            List<Person> personList = recordsReader.getObjectList(csvParser.parse(inputStream), Person.class, 1)
                    .stream()
                    .map(object -> (Person) object)
                    .collect(Collectors.toList());
            personDao.addPeople(personList);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }*/

        try (InputStream inputStream = Main.class.getResourceAsStream("../../dataForTable/passport.txt")) {
            List<Passport> passportList = recordsReader.getObjectList(csvParser.parse(inputStream), Passport.class, 1)
                    .stream()
                    .map(object -> (Passport) object)
                    .collect(Collectors.toList());
            passportDao.addPassports(passportList);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        /*try (InputStream inputStream = Main.class.getResourceAsStream("../../dataForTable/polis.txt")) {
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
