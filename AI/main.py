# Tên file: main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from predict import run_forecast
import json
import base64
import os

# Khởi tạo ứng dụng API
app = FastAPI(title="Weather Forecast AI API")

# Cấu hình CORS: Cho phép mọi Frontend (từ các domain khác nhau) gọi API mà không bị chặn
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # Trong thực tế có thể thay "*" bằng domain web của bạn
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"message": "Chào mừng đến với API Dự báo Thời tiết bằng LSTM!"}

@app.get("/api/forecast")
def get_weather_forecast():
    """
    Endpoint này được Frontend gọi để lấy dữ liệu dự báo 24h mới nhất.
    """
    print("\n--- NHẬN YÊU CẦU TỪ FRONTEND, ĐANG XỬ LÝ... ---")
    
    try:
        # 1. Chạy lại mô hình AI để luôn có dữ liệu mới nhất (Real-time)
        run_forecast()
    except Exception as e:
        return {"status": "error", "message": f"Lỗi khi chạy mô hình: {str(e)}"}

    # 2. Đọc kết quả từ file JSON vừa được tạo ra
    forecast_data = []
    if os.path.exists("KetQua_DuBao_24h.json"):
        with open("KetQua_DuBao_24h.json", "r", encoding="utf-8") as f:
            forecast_data = json.load(f)

    # 3. Đọc ảnh biểu đồ và chuyển thành mã Base64 để Frontend hiển thị thẳng lên màn hình
    chart_base64 = ""
    if os.path.exists("BieuDo_24h.png"):
        with open("BieuDo_24h.png", "rb") as img_file:
            # Mã hoá ảnh sang dạng văn bản
            encoded_string = base64.b64encode(img_file.read()).decode('utf-8')
            chart_base64 = f"data:image/png;base64,{encoded_string}"

    print("--- ĐÃ GỬI TRẢ DỮ LIỆU CHO FRONTEND ---")
    
    # 4. Trả về cụm dữ liệu chuẩn JSON cho Frontend
    return {
        "status": "success",
        "message": "Dự báo thời tiết 24 giờ tiếp theo",
        "data": forecast_data,
        "chart": chart_base64
    }