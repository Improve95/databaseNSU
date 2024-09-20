package ru.improve.util;

import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvException;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;

public class CsvParser {

    public List<String[]> parse(InputStream inputStream) {
        List<String[]> result = null;

        try (BufferedReader bf = new BufferedReader(new InputStreamReader(inputStream));
             CSVReader csvReader = new CSVReader(bf)) {

            result = csvReader.readAll();
        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (CsvException e) {
            throw new RuntimeException(e);
        }

        return result;
    }
}
