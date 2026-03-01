# Tên file: predict.py
import joblib
import numpy as np
import pandas as pd
import matplotlib
matplotlib.use('Agg') # Ép vẽ ngầm, không mở cửa sổ
# ----------------------------------------

import matplotlib.pyplot as plt
from tensorflow.keras.models import load_model
from data_handler import get_openweather_hourly_data
from datetime import datetime, timedelta
def run_forecast():
    print("Đang tải các mô hình AI từ ổ cứng...")
    lstm_model = load_model('lstm_hourly_model.keras')
    scaler = joblib.load('scaler_hourly.pkl')
    
    print("Đang lấy dữ liệu 24h gần nhất từ OpenWeather API...")
    df_api_hourly = get_openweather_hourly_data()
    
    # Lấy 3 cột
    df_api_hourly = df_api_hourly[['temp', 'humidity', 'wind_speed']]
    
    api_data_values = df_api_hourly.values
    api_data_scaled = scaler.transform(api_data_values)
    X_input = api_data_scaled.reshape((1, 24, 3)) 
    
    print("Đang dự báo thời tiết cho 24 giờ tiếp theo...")
    predicted_24h_scaled = lstm_model.predict(X_input, verbose=0)
    
    dummy_inverse = np.zeros((24, 3)) 
    dummy_inverse[:, 0] = predicted_24h_scaled[0]
    predicted_24h_temp = scaler.inverse_transform(dummy_inverse)[:, 0]
    
    # ==========================================
    # CẬP NHẬT: TẠO MỐC THỜI GIAN THỰC TẾ
    # ==========================================
    # Lấy giờ hiện tại trên máy tính và làm tròn đến số giờ chẵn
    now = datetime.now()
    current_hour_rounded = now.replace(minute=0, second=0, microsecond=0)
    
    # Tạo danh sách mốc thời gian cho 24 giờ tới (Định dạng: Giờ:Phút Ngày/Tháng)
    real_time_hours = []
    for i in range(1, 25):
        next_hour = current_hour_rounded + timedelta(hours=i)
        real_time_hours.append(next_hour.strftime("%H:%M %d/%m"))
    
    # Đưa thời gian thực vào kết quả
    df_result = pd.DataFrame({
        'Thoi_Gian': real_time_hours,
        'Nhiet_Do_Du_Bao_C': np.round(predicted_24h_temp, 2)
    })
    
    # Lưu file
    df_result.to_csv("KetQua_DuBao_24h.csv", index=False)
    df_result.to_json('KetQua_DuBao_24h.json', orient='records', force_ascii=False, indent=4)
    print("\n[THÀNH CÔNG] Đã lưu file CSV và JSON với mốc thời gian thực!")
    
    # Vẽ biểu đồ
    plt.figure(figsize=(12, 5))
    plt.plot(real_time_hours, predicted_24h_temp, marker='o', color='red', linestyle='-', linewidth=2)
    plt.title(f"Dự báo nhiệt độ 24 giờ (Cập nhật lúc: {now.strftime('%H:%M %d/%m/%Y')})")
    plt.xlabel("Thời gian thực")
    plt.ylabel("Nhiệt độ (°C)")
    
    # Chỉnh góc chữ để thời gian không bị đè lên nhau
    plt.xticks(rotation=45, ha='right')
    plt.grid(True, linestyle='--', alpha=0.7)
    plt.tight_layout()
    plt.savefig('BieuDo_24h.png')
    print("[THÀNH CÔNG] Đã lưu biểu đồ vào file 'BieuDo_24h.png'")

if __name__ == "__main__":
    run_forecast()