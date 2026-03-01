# AI Model Integration Guide

## Tổng quan
Đã tích hợp thành công AI Model (LSTM, Random Forest) từ Python vào Java Spring Backend với database MySQL.

## Cấu trúc mới

### 1. Database Tables
- `ai_forecasts`: Lưu kết quả dự báo AI 24h
- `ai_models`: Lưu thông tin các AI models

### 2. Java Classes
- **Entities**: `AiForecast.java`, `AiModel.java`
- **Repositories**: `AiForecastRepository.java`, `AiModelRepository.java`
- **Services**: `AiPredictionService.java`, `AiModelService.java`
- **Controller**: `AiController.java`

### 3. Python Integration
- `predict_for_java.py`: Script Python mới để tích hợp với Java
- Trả về JSON format dễ parse cho Java

## API Endpoints

### AI Forecast APIs
```
GET  /api/ai/forecast/{city}           - Lấy dự báo 24h
POST /api/ai/forecast/{city}           - Tạo dự báo mới
```

### AI Model Management APIs
```
GET    /api/ai/models                  - Lấy danh sách models
GET    /api/ai/models/best/{type}      - Lấy model tốt nhất
POST   /api/ai/models                  - Đăng ký model mới
GET    /api/ai/stats                   - Thống kê AI
DELETE /api/ai/forecasts/cleanup       - Dọn dẹp dự báo cũ
```

## Cách chạy

### 1. Setup Database
```sql
-- Chạy file Final.sql để tạo tables
source D:\Project_2025\Group_Project_2025\Backend\Java Spring\Final.sql
```

### 2. Cấu hình Python
- Đảm bảo Python environment có các packages trong `requirement.txt`
- Test Python script: `python predict_for_java.py --city Hanoi`

### 3. Chạy Java Spring
```bash
cd "D:\Project_2025\Group_Project_2025\Backend\Java Spring"
mvnw.cmd spring-boot:run
```

### 4. Test APIs
```bash
# Tạo dự báo mới cho Hà Nội
curl -X POST http://localhost:8080/api/ai/forecast/hanoi

# Lấy dự báo 24h
curl http://localhost:8080/api/ai/forecast/hanoi

# Lấy thống kê AI
curl http://localhost:8080/api/ai/stats
```

## Luồng hoạt động

1. **Frontend** gọi `/api/ai/forecast/hanoi`
2. **Java Spring** tìm location ID của Hà Nội
3. **Java Spring** gọi Python script: `python predict_for_java.py --city Hanoi`
4. **Python** chạy LSTM model, trả về JSON
5. **Java Spring** parse JSON, lưu vào database
6. **Java Spring** trả về kết quả cho frontend

## File cấu hình

### application-ai.properties
```properties
ai.python.executable=python
ai.python.script.path=../../AI/predict_for_java.py
ai.forecast.hours=24
ai.forecast.cleanup.days=30
```

## Troubleshooting

### Lỗi "Python script failed"
- Kiểm tra Python environment
- Đảm bảo các file model tồn tại
- Test script thủ công: `python predict_for_java.py --city Hanoi`

### Lỗi "Không tìm thấy thành phố"
- Đảm bảo thành phố có trong database `locations`
- Kiểm tra API `/api/weather/list` để xem danh sách thành phố

### Lỗi Database connection
- Kiểm tra MySQL service đang chạy
- Kiểm tra connection string trong `application.properties`

## Monitoring

### Logs
- Java logs: Console output
- Python logs: Được capture trong Java logs

### Performance
- Response time: ~2-5 giây cho mỗi dự báo
- Database growth: ~24 records/thành phố/ngày

## Next Steps

1. **Caching**: Implement Redis cache cho predictions
2. **Async**: Implement async processing cho heavy forecasts
3. **Model Retraining**: Auto-retrain models hàng tuần
4. **Monitoring**: Add metrics và health checks
