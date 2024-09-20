package ru.improve.util.parser;

import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvException;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class CsvParser {

    public List<String[]> parse(InputStream inputStream) {
        List<String[]> result = new ArrayList<>();
        try (BufferedReader bf = new BufferedReader(new InputStreamReader(inputStream));
             CSVReader csvReader = new CSVReader(bf)) {

            String[] line;
            while ((line = csvReader.readNext()) != null) {
                String[] record = line[0].split(" ");
                if (record[0] == "###") {
                    break;
                }
                result.add(record);
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (CsvException e) {
            throw new RuntimeException(e);
        }
        return result;
    }
}
