package com.store.CSV;

import Constant.Iconstant;
import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvException;

import java.io.FileReader;
import java.io.IOException;
import java.util.List;


public class ReadCSV {
    public static void main(String[] args) {
        String csvPath = Iconstant.CSV_PATH;
        try(CSVReader reader = new CSVReader(new FileReader(csvPath))){
            List<String[]> records = reader.readAll();
            records.removeFirst();

        } catch (IOException | CsvException ignored) {

        }
    }
}
