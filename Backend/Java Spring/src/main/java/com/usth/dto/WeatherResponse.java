package com.usth.dto;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Builder
public class WeatherResponse {
    private Long locationId;
    private String cityName;
    private String country;

    private Double temperature;
    private Double humidity;
    private Double pressure;
    private Double windSpeed;
    private String weatherMain;
    private String weatherDescription;
    private String weatherIcon;

    private Double lat;
    private Double lon;

    private Double co;
    private Double no2;
    private Double so2;
    private Double pm25;
    private Double pm10;
    private Double o3;
    private Integer aqi;

    private LocalDateTime recordedAt;

    private String advice;

    private String warning;
}