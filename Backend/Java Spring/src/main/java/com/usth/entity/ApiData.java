package com.usth.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "api", indexes = {
        @Index(name = "idx_api_time", columnList = "recorded_at"),
        @Index(name = "idx_api_location", columnList = "location_id")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ApiData {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "temperature_api", nullable = false)
    private Double temperatureApi;

    @Column(name = "humidity")
    private Double humidity;

    @Column(name = "pressure")
    private Double pressure;

    @Column(name = "wind_speed")
    private Double windSpeed;

    @Column(name = "rainfall")
    private Double rainfall;

    @Column(name = "clouds")
    private Integer clouds;

    @Column(name = "visibility")
    private Integer visibility;

    @Column(name = "uvi")
    private Float uvi;

    @Column(name = "co")
    private Double co;

    @Column(name = "no2")
    private Double no2;

    @Column(name = "so2")
    private Double so2;

    @Column(name = "pm25")
    private Double pm25;

    @Column(name = "pm10")
    private Double pm10;

    @Column(name = "o3")
    private Double o3;

    @Column(name = "recorded_at", nullable = false)
    private LocalDateTime recordedAt;

    @Column(name = "weather_main", length = 50)
    private String weatherMain;

    @Column(name = "weather_description", length = 100)
    private String weatherDescription;

    @Column(name = "weather_icon", length = 10)
    private String weatherIcon;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "location_id", nullable = false)
    private Location location;
}