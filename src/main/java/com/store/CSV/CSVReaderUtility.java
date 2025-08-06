package com.store.CSV;

import Constant.Iconstant;
import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvException;

import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CSVReaderUtility {

    public static Map<String, String> loadCSVData(){
        Map<String, String> messageMap = new HashMap<>();
        String csvFilePath = Iconstant.CSV_PATH;
        try(CSVReader reader = new CSVReader(new FileReader(csvFilePath))){
            List<String[]> records = reader.readAll();
            if (!records.isEmpty()) {
                records.removeFirst(); // Remove the first row (headers)
            }
            for(String[] record : records){
                if(record.length >= 2){
                    messageMap.put(record[0], record[1]);
                }
            }
        }
        catch (IOException | CsvException ignored){

        }
        return  messageMap;
    }
}
