package com.store.Api;

import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class OSRMAPI {
    public static double getDistance(double[] startCoordinates, double[] endCoordinates) throws Exception {
        String urlString = "http://router.project-osrm.org/route/v1/driving/"
                + startCoordinates[1] + "," + startCoordinates[0] + ";"
                + endCoordinates[1] + "," + endCoordinates[0] + "?overview=false&steps=false";

        URL url = new URL(urlString);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");

        BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
        String inputLine;
        StringBuilder response = new StringBuilder();
        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }
        in.close();

        JSONObject jsonResponse = new JSONObject(response.toString());
        JSONObject route = jsonResponse.getJSONArray("routes").getJSONObject(0);
        double distance = route.getDouble("distance");

        // Làm tròn đến 2 chữ số sau dấu phẩy và trả về
        return Math.round((distance / 1000) * 100.0) / 100.0;
    }
}
