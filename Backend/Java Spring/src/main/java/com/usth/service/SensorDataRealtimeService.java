package com.usth.service;

import com.usth.model.SensorData;
import com.usth.repository.SensorDataRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

@Service
public class SensorDataRealtimeService {

    @Autowired
    private SensorDataRepository sensorDataRepository;

    private final List<SseEmitter> emitters = new CopyOnWriteArrayList<>();
    private LocalDateTime lastCheck = LocalDateTime.now();

    public void addEmitter(SseEmitter emitter) {
        emitters.add(emitter);
        emitter.onCompletion(() -> emitters.remove(emitter));
        emitter.onTimeout(() -> emitters.remove(emitter));
    }

    @Scheduled(fixedRate = 5000) // Check every 5 seconds
    public void checkForNewData() {
        try {
            List<SensorData> allData = sensorDataRepository.findAll();
            if (!allData.isEmpty()) {
                // Get the latest data
                SensorData latestData = allData.stream()
                    .sorted((a, b) -> b.getTimestamp().compareTo(a.getTimestamp()))
                    .findFirst()
                    .orElse(null);
                
                if (latestData != null && latestData.getTimestamp().isAfter(lastCheck)) {
                    // Broadcast the latest data to all connected clients
                    for (SseEmitter emitter : emitters) {
                        try {
                            emitter.send(SseEmitter.event()
                                .name("new-data")
                                .data(latestData));
                        } catch (IOException e) {
                            emitter.complete();
                            emitters.remove(emitter);
                        }
                    }
                    lastCheck = latestData.getTimestamp();
                }
            }
        } catch (Exception e) {
            System.err.println("Error checking for new data: " + e.getMessage());
        }
    }

    public void broadcastData(SensorData data) {
        for (SseEmitter emitter : emitters) {
            try {
                emitter.send(SseEmitter.event()
                    .name("new-data")
                    .data(data));
            } catch (IOException e) {
                emitter.complete();
                emitters.remove(emitter);
            }
        }
    }
}
