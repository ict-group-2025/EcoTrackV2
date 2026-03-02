package com.usth.config;

import com.usth.repository.LocationRepository;
import com.usth.service.WeatherService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.Arrays;
import java.util.List;

@Configuration
public class DatabaseLoader {

    @Bean
    CommandLineRunner initDatabase(LocationRepository locationRepository, WeatherService weatherService) {
        return args -> {
            System.out.println("--- BẮT ĐẦU KIỂM TRA VÀ NẠP DỮ LIỆU (BACKGROUND) ---");

            List<String> famousCities = Arrays.asList(
                    "Hanoi", "Ho Chi Minh City", "Tokyo", "Seoul", "Beijing", "Bangkok", "Singapore", "Mumbai", "Dubai",
                    "London", "Paris", "Berlin", "Madrid", "Rome", "Moscow", "Amsterdam", "Istanbul",
                    "New York", "Los Angeles", "Chicago", "Toronto", "Rio de Janeiro", "Buenos Aires",
                    "Sydney", "Melbourne", "Cairo", "Cape Town"
            );

            new Thread(() -> {
                int count = 0;
                for (String city : famousCities) {
                    try {
                        if (locationRepository.findByCityName(city).isEmpty()) {
                            weatherService.getWeatherByCity(city);
                            System.out.println("✅ Đã thêm mới: " + city);
                            count++;
                            Thread.sleep(300);
                        } else {
                        }
                    } catch (Exception e) {
                        System.err.println("❌ Lỗi nạp " + city + ": " + e.getMessage());
                    }
                }
                System.out.println("--- HOÀN TẤT: ĐÃ NẠP THÊM " + count + " THÀNH PHỐ MỚI ---");
            }).start();
        };
    }
}