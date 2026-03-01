package com.usth.controller;

import com.usth.entity.AiForecast;
import com.usth.entity.AiModel;
import com.usth.service.AiModelService;
import com.usth.service.AiPredictionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/ai")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AiController {

    private final AiPredictionService aiPredictionService;
    private final AiModelService aiModelService;

    /**
     * API 1: Lấy dự báo AI 24h cho một thành phố
     */
    @GetMapping("/forecast/{city}")
    public ResponseEntity<?> getForecast(@PathVariable String city) {
        try {
            List<AiForecast> forecasts = aiPredictionService.get24HourForecast(city);
            
            if (forecasts.isEmpty()) {
                // Nếu chưa có dự báo, chạy tạo mới
                forecasts = aiPredictionService.generateForecast(city);
            }
            
            return ResponseEntity.ok(Map.of(
                    "status", "success",
                    "city", city,
                    "forecasts", forecasts,
                    "count", forecasts.size()
            ));
            
        } catch (IllegalArgumentException e) {
            log.warn("Lỗi validation khi lấy dự báo cho thành phố {}: {}", city, e.getMessage());
            return ResponseEntity.badRequest().body(Map.of(
                    "status", "error",
                    "message", e.getMessage()
            ));
        } catch (Exception e) {
            log.error("Lỗi khi lấy dự báo cho thành phố {}: {}", city, e.getMessage(), e);
            return ResponseEntity.internalServerError().body(Map.of(
                    "status", "error",
                    "message", "Lỗi server: " + e.getMessage()
            ));
        }
    }

    /**
     * API 2: Tạo mới dự báo cho một thành phố
     */
    @PostMapping("/forecast/{city}")
    public ResponseEntity<?> generateForecast(@PathVariable String city) {
        try {
            List<AiForecast> forecasts = aiPredictionService.generateForecast(city);
            
            return ResponseEntity.ok(Map.of(
                    "status", "success",
                    "message", "Đã tạo dự báo mới cho " + city,
                    "city", city,
                    "forecasts", forecasts,
                    "count", forecasts.size()
            ));
            
        } catch (Exception e) {
            log.error("Lỗi khi tạo dự báo cho thành phố {}: {}", city, e.getMessage(), e);
            return ResponseEntity.internalServerError().body(Map.of(
                    "status", "error",
                    "message", "Không thể tạo dự báo: " + e.getMessage()
            ));
        }
    }

    /**
     * API 3: Lấy danh sách các AI models đang active
     */
    @GetMapping("/models")
    public ResponseEntity<?> getActiveModels() {
        try {
            List<AiModel> models = aiModelService.getAllActiveModels();
            
            return ResponseEntity.ok(Map.of(
                    "status", "success",
                    "models", models,
                    "count", models.size()
            ));
            
        } catch (Exception e) {
            log.error("Lỗi khi lấy danh sách models: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body(Map.of(
                    "status", "error",
                    "message", "Không thể lấy danh sách models: " + e.getMessage()
            ));
        }
    }

    /**
     * API 4: Lấy model tốt nhất theo type
     */
    @GetMapping("/models/best/{modelType}")
    public ResponseEntity<?> getBestModel(@PathVariable String modelType) {
        try {
            return aiModelService.getBestModel(modelType)
                    .map(model -> ResponseEntity.ok(Map.of(
                            "status", "success",
                            "model", model
                    )))
                    .orElse(ResponseEntity.notFound().build());
                    
        } catch (Exception e) {
            log.error("Lỗi khi lấy model tốt nhất cho type {}: {}", modelType, e.getMessage(), e);
            return ResponseEntity.internalServerError().body(Map.of(
                    "status", "error",
                    "message", "Không thể lấy model: " + e.getMessage()
            ));
        }
    }

    /**
     * API 5: Đăng ký model mới
     */
    @PostMapping("/models")
    public ResponseEntity<?> registerModel(@RequestBody RegisterModelRequest request) {
        try {
            AiModel model = aiModelService.registerModel(
                    request.getModelName(),
                    request.getModelType(),
                    request.getVersion(),
                    request.getAccuracy()
            );
            
            return ResponseEntity.ok(Map.of(
                    "status", "success",
                    "message", "Đã đăng ký model mới",
                    "model", model
            ));
            
        } catch (Exception e) {
            log.error("Lỗi khi đăng ký model: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body(Map.of(
                    "status", "error",
                    "message", "Không thể đăng ký model: " + e.getMessage()
            ));
        }
    }

    /**
     * API 6: Lấy thống kê AI
     */
    @GetMapping("/stats")
    public ResponseEntity<?> getAiStats() {
        try {
            Map<String, Object> predictionStats = aiPredictionService.getModelAccuracyStats();
            AiModelService.ModelStats modelStats = aiModelService.getModelStats();
            
            return ResponseEntity.ok(Map.of(
                    "status", "success",
                    "prediction_stats", predictionStats,
                    "model_stats", modelStats
            ));
            
        } catch (Exception e) {
            log.error("Lỗi khi lấy thống kê AI: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body(Map.of(
                    "status", "error",
                    "message", "Không thể lấy thống kê: " + e.getMessage()
            ));
        }
    }

    /**
     * API 7: Dọn dẹp các dự báo cũ
     */
    @DeleteMapping("/forecasts/cleanup")
    public ResponseEntity<?> cleanupOldForecasts(@RequestParam(defaultValue = "30") int daysToKeep) {
        try {
            int deleted = aiPredictionService.cleanupOldForecasts(daysToKeep);
            
            return ResponseEntity.ok(Map.of(
                    "status", "success",
                    "message", "Đã dọn dẹp các dự báo cũ",
                    "deleted_count", deleted,
                    "days_kept", daysToKeep
            ));
            
        } catch (Exception e) {
            log.error("Lỗi khi dọn dẹp dự báo cũ: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body(Map.of(
                    "status", "error",
                    "message", "Không thể dọn dẹp: " + e.getMessage()
            ));
        }
    }

    /**
     * DTO cho request đăng ký model
     */
    public static class RegisterModelRequest {
        private String modelName;
        private String modelType;
        private String version;
        private Double accuracy;

        // Getters and Setters
        public String getModelName() { return modelName; }
        public void setModelName(String modelName) { this.modelName = modelName; }

        public String getModelType() { return modelType; }
        public void setModelType(String modelType) { this.modelType = modelType; }

        public String getVersion() { return version; }
        public void setVersion(String version) { this.version = version; }

        public Double getAccuracy() { return accuracy; }
        public void setAccuracy(Double accuracy) { this.accuracy = accuracy; }
    }
}
