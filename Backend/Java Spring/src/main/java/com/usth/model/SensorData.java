package com.usth.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Document(collection = "sensordatas")
public class SensorData {
    @Id
    private String id;
    private String location;
    private Double temp;
    private Double hum;
    private Double pres;
    private Integer aqi;
    private Double pm25;
    private LocalDateTime timestamp;
}
