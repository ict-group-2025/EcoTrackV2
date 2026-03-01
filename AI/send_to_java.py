# Python script gửi dữ liệu AI đến Java Spring Backend
import requests
import json
import sys
from datetime import datetime
from predict_for_java import run_forecast_for_city

def send_forecast_to_java(city="Hanoi", java_url="http://localhost:8080"):
    """
    Chạy AI model và gửi kết quả đến Java Spring Backend
    """
    try:
        print(f"Đang chạy dự báo AI cho {city}...")
        
        # Chạy AI model để lấy dữ liệu
        forecast_json_str = run_forecast_for_city(city)
        forecast_data = json.loads(forecast_json_str)
        
        if forecast_data.get("status") != "success":
            print(f"Lỗi khi chạy AI model: {forecast_data.get('message')}")
            return False
            
        # Chuẩn bị data để gửi đến Java
        java_payload = {
            "city": city,
            "modelType": "LSTM",
            "predictions": []
        }
        
        # Chuyển đổi format
        for forecast in forecast_data.get("forecasts", []):
            prediction = {
                "hourOffset": forecast.get("hour_offset"),
                "temperature": forecast.get("temperature"),
                "confidence": forecast.get("confidence")
            }
            java_payload["predictions"].append(prediction)
        
        print(f"Đang gửi dữ liệu đến Java Backend: {java_url}/api/model/output")
        
        # Gửi POST request đến Java
        response = requests.post(
            f"{java_url}/api/model/output",
            json=java_payload,
            headers={"Content-Type": "application/json"},
            timeout=30
        )
        
        if response.status_code == 200:
            result = response.json()
            print(f"✅ Thành công! {result.get('message')}")
            print(f"Đã lưu {result.get('saved_count')} dự báo cho {city}")
            return True
        else:
            print(f"❌ Lỗi HTTP {response.status_code}: {response.text}")
            return False
            
    except requests.exceptions.RequestException as e:
        print(f"❌ Lỗi kết nối đến Java Backend: {e}")
        return False
    except Exception as e:
        print(f"❌ Lỗi không xác định: {e}")
        return False

def main():
    import argparse
    
    parser = argparse.ArgumentParser(description='Send AI forecast to Java Spring Backend')
    parser.add_argument('--city', type=str, default='Hanoi', help='City name for forecast')
    parser.add_argument('--java-url', type=str, default='http://localhost:8080', help='Java Backend URL')
    
    args = parser.parse_args()
    
    print("="*50)
    print("PYTHON AI MODEL → JAVA SPRING BACKEND INTEGRATION")
    print("="*50)
    
    success = send_forecast_to_java(args.city, args.java_url)
    
    if success:
        print("\n🎉 Hoàn thành! Dữ liệu AI đã được gửi và lưu vào database.")
    else:
        print("\n💥 Thất bại! Không thể gửi dữ liệu đến Java Backend.")
        
    print("="*50)

if __name__ == "__main__":
    main()
