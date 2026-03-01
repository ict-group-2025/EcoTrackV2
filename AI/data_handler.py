import pandas as pd
import numpy as np
import requests

API_KEY = "51fd68be8c2e7e6b965291693ec85e04"

def load_historical_daily_data(csv_path="df_weather.csv", location_name="Hà Nội"):
    df = pd.read_csv(csv_path)
    df_loc = df[df['location.name'] == location_name].sort_values('date').reset_index(drop=True)
    cols = ['day.maxtemp_c', 'day.mintemp_c', 'day.avgtemp_c', 
            'day.totalprecip_mm', 'day.maxwind_kph', 'day.avghumidity']
    return df_loc[cols]

def get_openweather_hourly_data(lat=21.0285, lon=105.8542):
    url = f"https://api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&units=metric&appid={API_KEY}"
    try:
        response = requests.get(url)
        if response.status_code == 200:
            data = response.json()
            forecast_list = data['list'][:8] 
            
            df_hourly = pd.DataFrame([{
                'temp': item['main']['temp'],
                'humidity': item['main']['humidity'],
                'wind_speed': item['wind']['speed'] * 3.6 # ĐỔI M/S SANG KM/H
            } for item in forecast_list])
            
            df_hourly.index = range(0, 24, 3)
            df_hourly = df_hourly.reindex(range(24)).interpolate(method='linear')
            return df_hourly
        else:
            print(f"Lỗi API (Mã {response.status_code}). Tạo dữ liệu mẫu...")
    except Exception as e:
        print(f"Không kết nối được API ({e}). Tạo dữ liệu mẫu...")
        
    return pd.DataFrame({
        'temp': np.random.uniform(22, 30, 24),
        'humidity': np.random.uniform(70, 95, 24),
        'wind_speed': np.random.uniform(5, 15, 24)
    })