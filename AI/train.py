import numpy as np
import pandas as pd
import joblib
from sklearn.preprocessing import MinMaxScaler
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense, Input
from data_handler import load_historical_daily_data

def train_and_save_models():
    print("1. Đang tải và biến đổi dữ liệu NGÀY thành GIỜ...")
    df_daily = load_historical_daily_data("df_weather.csv")
    df_recent = df_daily.tail(150).reset_index(drop=True)
    
    hourly_records = []
    for i in range(len(df_recent) - 1):
        day1 = df_recent.iloc[i]
        day2 = df_recent.iloc[i+1]
        
        temps = np.linspace(day1['day.avgtemp_c'], day2['day.avgtemp_c'], 24)
        hums = np.linspace(day1['day.avghumidity'], day2['day.avghumidity'], 24)
        winds = np.linspace(day1['day.maxwind_kph'], day2['day.maxwind_kph'], 24)
        
        for h in range(24):
            hour_factor = np.sin(np.pi * (h - 6) / 12) 
            temp_h = temps[h] + hour_factor * 4.0 
            hourly_records.append([temp_h, hums[h], winds[h]])
            
    # CHỈ DÙNG 3 CỘT: Nhiệt độ, Độ ẩm, Gió
    df_hourly = pd.DataFrame(hourly_records, columns=['temp', 'humidity', 'wind_speed'])

    print("\n2. Đang chuẩn hóa dữ liệu cho Mạng Nơ-ron...")
    scaler = MinMaxScaler()
    scaled_data = scaler.fit_transform(df_hourly.values)
    joblib.dump(scaler, 'scaler_hourly.pkl')

    print("\n3. Đang cắt dữ liệu thành các chuỗi...")
    X_train, y_train = [], []
    for i in range(len(scaled_data) - 48):
        X_train.append(scaled_data[i : i+24])
        y_train.append(scaled_data[i+24 : i+48, 0]) 
        
    X_train = np.array(X_train)
    y_train = np.array(y_train)

    print("\n4. Đang HUẤN LUYỆN AI...")
    lstm_model = Sequential([
        Input(shape=(24, 3)), # ĐỔI THÀNH 3 FEATURES
        LSTM(64, return_sequences=True, activation='relu'),
        LSTM(32, activation='relu'),
        Dense(24)
    ])
    lstm_model.compile(optimizer='adam', loss='mse')
    lstm_model.fit(X_train, y_train, epochs=30, batch_size=16, verbose=1)
    
    lstm_model.save('lstm_hourly_model.keras')
    print("\n[THÀNH CÔNG] Đã huấn luyện xong!")

if __name__ == "__main__":
    train_and_save_models()