package com.usth.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "sensor", indexes = {
        @Index(name = "idx_sensor_time", columnList = "recorded_at")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Sensor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "temperature_sensor", nullable = false)
    private Double temperatureSensor;

    @Column(name = "pressure")
    private Double pressure;

    @Column(name = "altitude")
    private Double altitude;

    @Column(name = "humidity")
    private Double humidity;

    @Column(name = "aqi")
    private Integer aqi;

    @Column(name = "tvoc")
    private Double tvoc;

    @Column(name = "eco2")
    private Double eco2;

    @Column(name = "dust_density")
    private Double dustDensity;

    @Column(name = "recorded_at", nullable = false)
    private LocalDateTime recordedAt;
}