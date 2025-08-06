package com.store.Api;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class NominatimAPI {

    public static double[] getCoordinatesFromAddress(String address) throws Exception {
        // Mã hóa địa chỉ để đưa vào URL
        String encodedAddress = URLEncoder.encode(address, StandardCharsets.UTF_8);

        // Gọi đến API Nominatim
        String urlString = "https://nominatim.openstreetmap.org/search?q=" + encodedAddress + "&format=json";

        URL url = new URL(urlString);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");

        // Set User-Agent theo yêu cầu
        connection.setRequestProperty("User-Agent", "StoreWebsite/1.0");

        // Đọc phản hồi JSON
        BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
        StringBuilder response = new StringBuilder();
        String inputLine;
        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }
        in.close();

        // Phân tích JSON để lấy lat/lon
        JSONArray jsonResponse = new JSONArray(response.toString());
        if (!jsonResponse.isEmpty()) {
            JSONObject firstResult = jsonResponse.getJSONObject(0);
            double lat = Double.parseDouble(firstResult.getString("lat"));
            double lon = Double.parseDouble(firstResult.getString("lon"));
            return new double[]{lat, lon};
        } else {
            throw new Exception("Can not find address: ");
        }


        // fixed
    }
}
