package com.usth.controller;

import com.usth.entity.AiForecast;
import com.usth.entity.Location;
import com.usth.repository.AiForecastRepository;
import com.usth.repository.LocationRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/model")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ModelOutputController {

    private final AiForecastRepository aiForecastRepository;
    private final LocationRepository locationRepository;

    /**
     * Nhận dữ liệu từ Python AI model
     */
    @PostMapping("/output")
    public ResponseEntity<?> receiveModelOutput(@RequestBody ModelOutputRequest request) {
        try {
            log.info("Nhận dự báo từ Python cho thành phố: {}", request.getCity());
            
            // Tìm location ID
            Location location = locationRepository.findByCityNameIgnoreCase(request.getCity())
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy thành phố: " + request.getCity()));

            // Chuyển đổi và lưu vào database
            List<AiForecast> forecasts = new ArrayList<>();
            LocalDateTime now = LocalDateTime.now();
            
            for (PredictionData prediction : request.getPredictions()) {
                AiForecast forecast = AiForecast.builder()
                        .locationId(location.getId())
                        .forecastTime(now.plusHours(prediction.getHourOffset()))
                        .temperature(prediction.getTemperature())
                        .modelType(request.getModelType())
                        .confidenceScore(prediction.getConfidence())
                        .build();
                
                forecasts.add(forecast);
            }
            
            List<AiForecast> savedForecasts = aiForecastRepository.saveAll(forecasts);
            log.info("Đã lưu {} dự báo cho thành phố {}", savedForecasts.size(), request.getCity());
            
            return ResponseEntity.ok(Map.of(
                    "status", "success",
                    "message", "Đã nhận và lưu " + savedForecasts.size() + " dự báo",
                    "city", request.getCity(),
                    "saved_count", savedForecasts.size()
            ));
            
        } catch (Exception e) {
            log.error("Lỗi khi nhận dữ liệu từ Python: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body(Map.of(
                    "status", "error",
                    "message", "Lỗi khi lưu dữ liệu: " + e.getMessage()
            ));
        }
    }

    /**
     * DTO cho request từ Python
     */
    public static class ModelOutputRequest {
        private String city;
        private String modelType;
        private List<PredictionData> predictions;
        
        // Getters and Setters
        public String getCity() { return city; }
        public void setCity(String city) { this.city = city; }
        
        public String getModelType() { return modelType; }
        public void setModelType(String modelType) { this.modelType = modelType; }
        
        public List<PredictionData> getPredictions() { return predictions; }
        public void setPredictions(List<PredictionData> predictions) { this.predictions = predictions; }
    }

    /**
     * DTO cho prediction data
     */
    public static class PredictionData {
        private int hourOffset;
        private Double temperature;
        private Double confidence;
        
        // Getters and Setters
        public int getHourOffset() { return hourOffset; }
        public void setHourOffset(int hourOffset) { this.hourOffset = hourOffset; }
        
        public Double getTemperature() { return temperature; }
        public void setTemperature(Double temperature) { this.temperature = temperature; }
        
        public Double getConfidence() { return confidence; }
        public void setConfidence(Double confidence) { this.confidence = confidence; }
    }
}
