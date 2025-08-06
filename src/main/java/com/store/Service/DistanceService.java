package com.store.Service;

import com.store.Api.NominatimAPI;
import com.store.Api.OSRMAPI;

import java.math.BigDecimal;

public class DistanceService {
    public double calculateDistance(String startAddress, String endAddress) throws Exception {
        double[] startCoordinates = NominatimAPI.getCoordinatesFromAddress(startAddress);
        double[] endCoordinates = NominatimAPI.getCoordinatesFromAddress(endAddress);

        return OSRMAPI.getDistance(startCoordinates, endCoordinates);
    }

    public BigDecimal calculateShippingFee(String startAddress, String endAddress) {
        double distance = 1000000000;

        try {
            distance = calculateDistance(startAddress, endAddress);
        } catch (Exception ignored) {

        }

        BigDecimal shippingFee;

        if(distance <= 1000){
            shippingFee = calculateDomesticShippingFee(distance);
        }
        else{
            shippingFee = calculateInternationalShippingFee(distance);
        }

        return shippingFee;
    }

    private BigDecimal calculateDomesticShippingFee(double distance) {
        double threeKmRate = 0.5; // <= 3km
        double fromThreeKmRate = 0.07; // adding fee/km when distance > 3km
        double fromFiftyKmRate = 0.02; // add fee/km when distance > 50 km
        double fromOneHundredKmRate = 0.01; // add fee/km when distance > 100 km

        double totalFee;

        if (distance <= 3) {
            totalFee = threeKmRate * distance;
        } else if (distance <= 50) {
            totalFee = threeKmRate*3 + (distance - 3) * fromThreeKmRate;
        } else if (distance <= 100) {
            totalFee = threeKmRate*3 + fromThreeKmRate*50 + (distance - 50) * fromFiftyKmRate;
        } else {
            totalFee = threeKmRate*3 + fromThreeKmRate*50 + fromFiftyKmRate *100 + (distance-100)*fromOneHundredKmRate ;
        }

        return new BigDecimal(totalFee);
    }

    private BigDecimal calculateInternationalShippingFee(double distance) {
        double baseOne = 0.01; // <= 3km
        double baseTwo = 0.0091;
        double totalFee;

        if (distance <= 1800) {
            totalFee = 17;
        } else if (distance <= 5000) {
            totalFee = baseOne*distance;
        } else if (distance <= 7000) {
            totalFee = baseTwo*distance;
        } else {
            totalFee = 0.005 * distance;
        }
        return new BigDecimal(totalFee);
    }
}