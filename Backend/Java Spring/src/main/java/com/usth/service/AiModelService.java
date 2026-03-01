package com.usth.service;

import com.usth.entity.AiModel;
import com.usth.repository.AiModelRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class AiModelService {

    private final AiModelRepository aiModelRepository;

    /**
     * Lấy model đang active theo type
     */
    public Optional<AiModel> getActiveModel(String modelType) {
        return aiModelRepository.findFirstByModelTypeAndIsActiveTrueOrderByLastTrainedAtDesc(modelType);
    }

    /**
     * Lấy tất cả models đang active
     */
    public List<AiModel> getAllActiveModels() {
        return aiModelRepository.findByIsActiveTrueOrderByLastTrainedAtDesc();
    }

    /**
     * Lấy model tốt nhất theo type (dựa trên accuracy)
     */
    public Optional<AiModel> getBestModel(String modelType) {
        return aiModelRepository.findBestModelByType(modelType);
    }

    /**
     * Đăng ký model mới
     */
    @Transactional
    public AiModel registerModel(String modelName, String modelType, String version, Double accuracy) {
        // Vô hiệu hóa các models cũ cùng type
        aiModelRepository.findByModelTypeOrderByLastTrainedAtDesc(modelType)
                .forEach(model -> {
                    model.setIsActive(false);
                    aiModelRepository.save(model);
                });

        // Tạo model mới
        AiModel newModel = AiModel.builder()
                .modelName(modelName)
                .modelType(modelType)
                .version(version)
                .accuracy(accuracy)
                .lastTrainedAt(LocalDateTime.now())
                .isActive(true)
                .build();

        AiModel savedModel = aiModelRepository.save(newModel);
        log.info("Đã đăng ký model mới: {} {} (version: {}, accuracy: {})", 
                modelType, modelName, version, accuracy);
        
        return savedModel;
    }

    /**
     * Cập nhật thông tin model
     */
    @Transactional
    public AiModel updateModel(Long modelId, String modelName, String version, Double accuracy) {
        AiModel model = aiModelRepository.findById(modelId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy model với ID: " + modelId));

        model.setModelName(modelName);
        model.setVersion(version);
        model.setAccuracy(accuracy);
        model.setLastTrainedAt(LocalDateTime.now());

        AiModel updatedModel = aiModelRepository.save(model);
        log.info("Đã cập nhật model: {} (ID: {})", modelName, modelId);
        
        return updatedModel;
    }

    /**
     * Vô hiệu hóa model
     */
    @Transactional
    public void deactivateModel(Long modelId) {
        AiModel model = aiModelRepository.findById(modelId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy model với ID: " + modelId));

        model.setIsActive(false);
        aiModelRepository.save(model);
        
        log.info("Đã vô hiệu hóa model: {} (ID: {})", model.getModelName(), modelId);
    }

    /**
     * Lấy các models cần retrain
     */
    public List<AiModel> getModelsNeedingRetraining(int daysOld) {
        LocalDateTime cutoffDate = LocalDateTime.now().minusDays(daysOld);
        return aiModelRepository.findModelsNeedingRetraining(cutoffDate);
    }

    /**
     * Lấy thống kê models
     */
    public ModelStats getModelStats() {
        long lstmCount = aiModelRepository.countByModelType("LSTM");
        long rfCount = aiModelRepository.countByModelType("RF");
        long totalModels = aiModelRepository.count();

        return new ModelStats(lstmCount, rfCount, totalModels);
    }

    /**
     * DTO cho thống kê models
     */
    public record ModelStats(long lstmCount, long rfCount, long totalCount) {}
}
