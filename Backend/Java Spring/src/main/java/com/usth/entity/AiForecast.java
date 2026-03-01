package com.usth.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "ai_forecasts", indexes = {
        @Index(name = "idx_forecast_location_time", columnList = "location_id, forecast_time"),
        @Index(name = "idx_forecast_model", columnList = "model_type")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AiForecast {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "location_id", nullable = false)
    private Long locationId;

    @Column(name = "forecast_time", nullable = false)
    private LocalDateTime forecastTime;

    @Column(name = "temperature", nullable = false)
    private Double temperature;

    @Column(name = "model_type", nullable = false, length = 20)
    private String modelType; // 'LSTM' hoặc 'RF'

    @Column(name = "confidence_score")
    private Double confidenceScore;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

    // Liên kết đến location (lazy loading để tránh circular dependency)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "location_id", insertable = false, updatable = false)
    private Location location;
}
