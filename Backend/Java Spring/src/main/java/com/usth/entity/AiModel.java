package com.usth.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "ai_models")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AiModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "model_name", nullable = false, length = 50)
    private String modelName;

    @Column(name = "model_type", nullable = false, length = 20)
    private String modelType; // 'LSTM', 'RF', etc.

    @Column(name = "version", length = 20)
    private String version;

    @Column(name = "accuracy")
    private Double accuracy;

    @Column(name = "last_trained_at")
    private LocalDateTime lastTrainedAt;

    @Column(name = "is_active")
    private Boolean isActive;

    @PrePersist
    protected void onCreate() {
        if (isActive == null) {
            isActive = true;
        }
    }
}
