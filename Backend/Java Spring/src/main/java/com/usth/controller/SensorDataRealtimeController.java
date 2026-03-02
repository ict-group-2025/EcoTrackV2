package com.usth.controller;

import com.usth.model.SensorData;
import com.usth.repository.SensorDataRepository;
import com.usth.service.SensorDataRealtimeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/sensor-realtime")
public class SensorDataRealtimeController {

    @Autowired
    private SensorDataRepository sensorDataRepository;
    
    @Autowired
    private SensorDataRealtimeService realtimeService;

    @GetMapping(value = "/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter streamSensorData() {
        SseEmitter emitter = new SseEmitter(Long.MAX_VALUE);
        realtimeService.addEmitter(emitter);

        // Send initial data - only latest data
        try {
            List<SensorData> allData = sensorDataRepository.findAll();
            if (!allData.isEmpty()) {
                // Sort by timestamp descending and get latest
                SensorData latestData = allData.stream()
                    .sorted((a, b) -> b.getTimestamp().compareTo(a.getTimestamp()))
                    .findFirst()
                    .orElse(null);
                
                if (latestData != null) {
                    emitter.send(SseEmitter.event()
                        .name("initial-data")
                        .data(latestData));
                }
            }
        } catch (IOException e) {
            emitter.completeWithError(e);
        }

        return emitter;
    }

    @PostMapping("/add")
    public ResponseEntity<String> addSensorData(@RequestBody SensorData sensorData) {
        try {
            if (sensorData.getTimestamp() == null) {
                sensorData.setTimestamp(LocalDateTime.now());
            }
            SensorData saved = sensorDataRepository.save(sensorData);
            
            // Broadcast to all connected clients
            realtimeService.broadcastData(saved);
            
            return ResponseEntity.ok("Data added and broadcasted successfully");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error: " + e.getMessage());
        }
    }
}
