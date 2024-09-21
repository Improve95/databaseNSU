package ru.improve.util;

import ru.improve.Main;
import ru.improve.dao.DoctorDao;
import ru.improve.dao.DoctorSpecializationDao;
import ru.improve.dao.PassportDao;
import ru.improve.dao.PatientDao;
import ru.improve.dao.PersonDao;
import ru.improve.dao.SpecializationDao;
import ru.improve.dao.StaffDao;
import ru.improve.models.Doctor;
import ru.improve.models.DoctorSpecialization;
import ru.improve.models.Passport;
import ru.improve.models.Person;
import ru.improve.models.Specialization;
import ru.improve.models.patient.Patient;
import ru.improve.models.staff.Staff;
import ru.improve.util.parser.CsvParser;
import ru.improve.util.parser.RecordsReader;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

public class FillTables {

    private final String pathToFiles = "../../dataForTable/";

    PersonDao personDao = new PersonDao();
    PassportDao passportDao = new PassportDao();
    SpecializationDao specializationDao = new SpecializationDao();
    StaffDao staffDao = new StaffDao();
    DoctorDao doctorDao = new DoctorDao();
    DoctorSpecializationDao doctorSpecializationDao = new DoctorSpecializationDao();
    PatientDao patientDao = new PatientDao();

    public void fill() {
        RecordsReader recordsReader = new RecordsReader();
        CsvParser csvParser = new CsvParser();

        /*try (InputStream inputStream = Main.class.getResourceAsStream(pathToFiles + "person.txt")) {
            List<Person> personList = recordsReader.getObjectList(csvParser.parse(inputStream), Person.class, 1)
                    .stream()
                    .map(object -> (Person) object)
                    .collect(Collectors.toList());
            personDao.truncateTable();
            personDao.addPeople(personList);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        try (InputStream inputStream = Main.class.getResourceAsStream("../../dataForTable/passport.txt")) {
            List<Passport> passportList = recordsReader.getObjectList(csvParser.parse(inputStream), Passport.class, 0)
                    .stream()
                    .map(object -> (Passport) object)
                    .collect(Collectors.toList());
            passportDao.truncateTable();
            passportDao.addPassports(passportList);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        try (InputStream inputStream = Main.class.getResourceAsStream("../../dataForTable/specialization.txt")) {
            List<Specialization> specializationList = recordsReader.getObjectList(csvParser.parse(inputStream), Specialization.class, 1)
                    .stream()
                    .map(object -> (Specialization) object)
                    .collect(Collectors.toList());
            specializationDao.truncateTable();
            specializationDao.addSpecializations(specializationList);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }*/

        /*try (InputStream inputStream = Main.class.getResourceAsStream("../../dataForTable/staff.txt")) {
            List<Staff> staffList = recordsReader.getObjectList(csvParser.parse(inputStream), Staff.class, 0)
                    .stream()
                    .map(object -> (Staff) object)
                    .collect(Collectors.toList());
            staffDao.truncateTable();
            staffDao.addStaffs(staffList);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        try (InputStream inputStream = Main.class.getResourceAsStream("../../dataForTable/doctor.txt")) {
            List<Doctor> doctorList = recordsReader.getObjectList(csvParser.parse(inputStream), Doctor.class, 0)
                    .stream()
                    .map(object -> (Doctor) object)
                    .collect(Collectors.toList());
            doctorDao.truncateTable();
            doctorDao.addDoctors(doctorList);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        try (InputStream inputStream = Main.class.getResourceAsStream("../../dataForTable/doctorSpecialization.txt")) {
            List<DoctorSpecialization> doctorSpecializationList = recordsReader.getObjectList(csvParser.parse(inputStream), DoctorSpecialization.class, 0)
                    .stream()
                    .map(object -> (DoctorSpecialization) object)
                    .collect(Collectors.toList());
            doctorSpecializationDao.truncateTable();
            doctorSpecializationDao.addDoctorSpecializations(doctorSpecializationList);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }*/

        try (InputStream inputStream = Main.class.getResourceAsStream("../../dataForTable/patient.txt")) {
            List<Patient> patientList = recordsReader.getObjectList(csvParser.parse(inputStream), Patient.class, 3)
                    .stream()
                    .map(object -> {
                        Patient patient = (Patient) object;
                        patient.setComingTime(LocalDateTime.now());
                        patient.setReleaseTime(null);
                        return patient;
                    })
                    .collect(Collectors.toList());
            patientDao.truncateTable();
            patientDao.addPatients(patientList);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        if (false) {
            try (InputStream inputStream = Main.class.getResourceAsStream("")) {
                List<Object> staffList = recordsReader.getObjectList(csvParser.parse(inputStream), Staff.class, 0)
                        .stream()
                        .map(object -> (Staff) object)
                        .collect(Collectors.toList());
//                staffDao.truncateTable();
    //            staffDao.addStaffs(staffList);
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
    }
}
