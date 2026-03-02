package com.usth.controller;

import com.usth.service.WeatherService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api/weather")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class WeatherController {

    private final WeatherService weatherService;

    @GetMapping("/search")
    public ResponseEntity<?> searchCity(@RequestParam String city) {
        if (city == null || city.trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Tên thành phố không được để trống");
        }

        try {
            return ResponseEntity.ok(weatherService.getWeatherByCity(city.trim()));
        } catch (IllegalArgumentException e) {
            log.warn("Lỗi validation khi tìm kiếm thành phố: {}", e.getMessage());
            return ResponseEntity.badRequest().body("Lỗi: " + e.getMessage());
        } catch (Exception e) {
            log.error("Lỗi khi tìm kiếm thành phố: {}", city, e);
            return ResponseEntity.internalServerError().body("Lỗi server: " + e.getMessage());
        }
    }

    @GetMapping("/list")
    public ResponseEntity<?> getAllCities() {
        return ResponseEntity.ok(weatherService.getAllLocations());
    }

    @GetMapping("/forecast/{city}")
    public ResponseEntity<?> getForecast(@PathVariable String city) {
        try {
            return ResponseEntity.ok(weatherService.getForecast(city));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Lỗi: " + e.getMessage());
        }
    }
}