package com.usth.controller;

import com.usth.model.SensorData;
import com.usth.repository.SensorDataRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/sensor-data")
public class SensorDataController {

    @Autowired
    private SensorDataRepository sensorDataRepository;

    @GetMapping("/test-connection")
    public ResponseEntity<String> testConnection() {
        try {
            long count = sensorDataRepository.count();
            return ResponseEntity.ok("MongoDB connection successful! Total sensor data documents: " + count);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("MongoDB connection failed: " + e.getMessage());
        }
    }

    @GetMapping("/all")
    public ResponseEntity<List<SensorData>> getAllSensorData() {
        try {
            List<SensorData> sensorData = sensorDataRepository.findAllDocuments();
            return ResponseEntity.ok(sensorData);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(null);
        }
    }

    @GetMapping("/location/{location}")
    public ResponseEntity<List<SensorData>> getSensorDataByLocation(@PathVariable String location) {
        try {
            List<SensorData> sensorData = sensorDataRepository.findByLocationOrderByTimestampDesc(location);
            return ResponseEntity.ok(sensorData);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(null);
        }
    }

    @GetMapping("/location/{location}/between")
    public ResponseEntity<List<SensorData>> getSensorDataByLocationAndTimeRange(
            @PathVariable String location,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end) {
        try {
            List<SensorData> sensorData = sensorDataRepository.findByLocationAndTimestampBetween(location, start, end);
            return ResponseEntity.ok(sensorData);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(null);
        }
    }

    @PostMapping("/add")
    public ResponseEntity<SensorData> addSensorData(@RequestBody SensorData sensorData) {
        try {
            if (sensorData.getTimestamp() == null) {
                sensorData.setTimestamp(LocalDateTime.now());
            }
            SensorData saved = sensorDataRepository.save(sensorData);
            return ResponseEntity.ok(saved);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(null);
        }
    }
}
