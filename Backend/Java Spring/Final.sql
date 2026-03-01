DROP DATABASE IF EXISTS weather_db;
CREATE DATABASE weather_db;
USE weather_db;

-- Bảng lưu kết quả dự báo AI
CREATE TABLE ai_forecasts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    location_id BIGINT NOT NULL,
    forecast_time DATETIME NOT NULL,
    temperature DOUBLE NOT NULL,
    model_type VARCHAR(20) NOT NULL, -- 'LSTM' hoặc 'RF'
    confidence_score DOUBLE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (location_id) REFERENCES locations(id),
    INDEX idx_forecast_location_time (location_id, forecast_time)
);

-- Bảng lưu thông tin model AI
CREATE TABLE ai_models (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(50) NOT NULL,
    model_type VARCHAR(20) NOT NULL,
    version VARCHAR(20),
    accuracy DOUBLE,
    last_trained_at TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Sau đó chạy lại Spring Boot App, nó sẽ tự tạo bảng và điền dữ liệu.