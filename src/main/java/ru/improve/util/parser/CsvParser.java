package ru.improve.util.parser;

import com.opencsv.CSVParser;
import com.opencsv.CSVParserBuilder;
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
            CSVParser csvParser = new CSVParserBuilder().withSeparator(' ').build();
            while ((line = csvReader.readNext()) != null) {
                 result.add(csvParser.parseLine(line[0]));
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (CsvException e) {
            throw new RuntimeException(e);
        }
        return result;
    }
}
