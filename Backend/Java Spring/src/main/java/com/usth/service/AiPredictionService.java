package com.usth.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.usth.entity.AiForecast;
import com.usth.entity.Location;
import com.usth.repository.AiForecastRepository;
import com.usth.repository.LocationRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class AiPredictionService {

    private final AiForecastRepository aiForecastRepository;
    private final LocationRepository locationRepository;
    private final ObjectMapper objectMapper;

    @Value("${ai.python.script.path:../../AI/predict_for_java.py}")
    private String pythonScriptPath;

    @Value("${ai.python.executable:python}")
    private String pythonExecutable;

    /**
     * Chạy dự báo AI cho một thành phố
     */
    public List<AiForecast> generateForecast(String cityName) {
        try {
            log.info("Bắt đầu chạy dự báo AI cho thành phố: {}", cityName);
            
            // Tìm location ID
            Location location = locationRepository.findByCityNameIgnoreCase(cityName)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy thành phố: " + cityName));

            // Chạy Python script
            String result = runPythonScript(cityName);
            
            // Parse kết quả JSON
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> forecasts = objectMapper.readValue(result, List.class);
            
            // Lưu vào database
            List<AiForecast> aiForecasts = new ArrayList<>();
            LocalDateTime now = LocalDateTime.now();
            
            for (Map<String, Object> forecast : forecasts) {
                AiForecast aiForecast = AiForecast.builder()
                        .locationId(location.getId())
                        .forecastTime(now.plusHours((Integer) forecast.get("hour_offset")))
                        .temperature(((Number) forecast.get("temperature")).doubleValue())
                        .modelType((String) forecast.get("model_type"))
                        .confidenceScore(forecast.containsKey("confidence") ? 
                                ((Number) forecast.get("confidence")).doubleValue() : null)
                        .build();
                
                aiForecasts.add(aiForecast);
            }
            
            // Lưu tất cả dự báo
            List<AiForecast> savedForecasts = aiForecastRepository.saveAll(aiForecasts);
            log.info("Đã lưu {} dự báo cho thành phố {}", savedForecasts.size(), cityName);
            
            return savedForecasts;
            
        } catch (Exception e) {
            log.error("Lỗi khi chạy dự báo AI cho thành phố {}: {}", cityName, e.getMessage(), e);
            throw new RuntimeException("Không thể chạy dự báo AI: " + e.getMessage());
        }
    }

    /**
     * Lấy dự báo 24h cho một thành phố
     */
    public List<AiForecast> get24HourForecast(String cityName) {
        try {
            Location location = locationRepository.findByCityNameIgnoreCase(cityName)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy thành phố: " + cityName));

            LocalDateTime now = LocalDateTime.now();
            LocalDateTime endTime = now.plusHours(24);

            return aiForecastRepository.find24HourForecast(location.getId(), now, endTime);
            
        } catch (Exception e) {
            log.error("Lỗi khi lấy dự báo 24h cho thành phố {}: {}", cityName, e.getMessage());
            throw new RuntimeException("Không thể lấy dự báo: " + e.getMessage());
        }
    }

    /**
     * Chạy Python script và trả về kết quả
     */
    private String runPythonScript(String cityName) throws Exception {
        ProcessBuilder processBuilder = new ProcessBuilder(
                pythonExecutable, pythonScriptPath, "--city", cityName
        );
        
        processBuilder.redirectErrorStream(true);
        Process process = processBuilder.start();

        // Đọc output
        StringBuilder output = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
            String line;
            while ((line = reader.readLine()) != null) {
                output.append(line).append("\n");
            }
        }

        int exitCode = process.waitFor();
        if (exitCode != 0) {
            throw new RuntimeException("Python script failed with exit code " + exitCode + 
                    ". Output: " + output.toString());
        }

        return output.toString().trim();
    }

    /**
     * Lấy thống kê độ chính xác của các models
     */
    public Map<String, Object> getModelAccuracyStats() {
        Map<String, Object> stats = Map.of(
                "lstm_forecasts", aiForecastRepository.countByModelType("LSTM"),
                "rf_forecasts", aiForecastRepository.countByModelType("RF"),
                "total_forecasts", aiForecastRepository.count()
        );
        
        return stats;
    }

    /**
     * Dọn dẹp các dự báo cũ
     */
    public int cleanupOldForecasts(int daysToKeep) {
        LocalDateTime cutoffDate = LocalDateTime.now().minusDays(daysToKeep);
        int deleted = aiForecastRepository.deleteOldForecasts(cutoffDate);
        log.info("Đã xóa {} dự báo cũ hơn {} ngày", deleted, daysToKeep);
        return deleted;
    }
}
