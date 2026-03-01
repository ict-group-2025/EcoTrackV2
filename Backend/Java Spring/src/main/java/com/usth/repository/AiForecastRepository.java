package com.usth.repository;

import com.usth.entity.AiForecast;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface AiForecastRepository extends JpaRepository<AiForecast, Long> {

    // Tìm dự báo theo location và thời gian
    List<AiForecast> findByLocationIdAndForecastTimeBetweenOrderByForecastTime(
            Long locationId, LocalDateTime startTime, LocalDateTime endTime);

    // Lấy dự báo mới nhất cho một location
    Optional<AiForecast> findFirstByLocationIdOrderByForecastTimeDesc(Long locationId);

    // Lấy dự báo 24h tới cho một location
    @Query("SELECT af FROM AiForecast af WHERE af.locationId = :locationId " +
           "AND af.forecastTime BETWEEN :startTime AND :endTime " +
           "ORDER BY af.forecastTime ASC")
    List<AiForecast> find24HourForecast(
            @Param("locationId") Long locationId,
            @Param("startTime") LocalDateTime startTime,
            @Param("endTime") LocalDateTime endTime);

    // Lấy dự báo theo model type
    List<AiForecast> findByLocationIdAndModelTypeOrderByForecastTime(
            Long locationId, String modelType);

    // Xóa các dự báo cũ (để dọn dẹp database)
    @Query("DELETE FROM AiForecast af WHERE af.createdAt < :cutoffDate")
    int deleteOldForecasts(@Param("cutoffDate") LocalDateTime cutoffDate);

    // Đếm số dự báo theo model type
    long countByModelType(String modelType);

    // Lấy các dự báo có confidence score cao
    List<AiForecast> findByLocationIdAndConfidenceScoreGreaterThanOrderByForecastTime(
            Long locationId, Double minConfidence);
}
