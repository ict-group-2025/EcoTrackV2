package com.usth.repository;

import com.usth.entity.AiModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AiModelRepository extends JpaRepository<AiModel, Long> {

    // Tìm model đang active theo type
    Optional<AiModel> findFirstByModelTypeAndIsActiveTrueOrderByLastTrainedAtDesc(String modelType);

    // Lấy tất cả models đang active
    List<AiModel> findByIsActiveTrueOrderByLastTrainedAtDesc();

    // Lấy models theo type
    List<AiModel> findByModelTypeOrderByLastTrainedAtDesc(String modelType);

    // Tìm model theo tên và version
    Optional<AiModel> findByModelNameAndVersion(String modelName, String version);

    // Lấy model có accuracy cao nhất theo type
    @Query("SELECT am FROM AiModel am WHERE am.modelType = :modelType AND am.isActive = true " +
           "ORDER BY am.accuracy DESC")
    Optional<AiModel> findBestModelByType(@Param("modelType") String modelType);

    // Đếm số models theo type
    long countByModelType(String modelType);

    // Lấy các models cần retrain (cũ hơn X ngày)
    @Query("SELECT am FROM AiModel am WHERE am.lastTrainedAt < :cutoffDate AND am.isActive = true")
    List<AiModel> findModelsNeedingRetraining(@Param("cutoffDate") java.time.LocalDateTime cutoffDate);
}
