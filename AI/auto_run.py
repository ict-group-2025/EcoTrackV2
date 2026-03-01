# Tên file: auto_run.py
import schedule
import time
import datetime
from predict import run_forecast

def job():
    print("\n" + "="*50)
    print(f"BẮT ĐẦU CẬP NHẬT DỰ BÁO LÚC: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("="*50)
    
    try:
        # Gọi hàm dự báo từ file predict.py
        run_forecast()
        print(f"\n[HOÀN TẤT] Dữ liệu đã được làm mới thành công!")
    except Exception as e:
        print(f"\n[LỖI CẬP NHẬT] Đã xảy ra lỗi: {e}")
        
    print("="*50 + "\n")

# Lên lịch chạy tự động: Ở đây đang cài đặt là MỖI 1 GIỜ CHẠY 1 LẦN.
# (Bạn có thể đổi thành .minutes nếu muốn test chạy mỗi vài phút)
schedule.every(1).hours.do(job)

# Chạy mồi lần đầu tiên ngay lập tức khi vừa bật tool
job()

print("Hệ thống tự động cập nhật đang hoạt động ngầm...")
print("Hãy giữ nguyên cửa sổ Terminal này. (Nhấn Ctrl + C để dừng hệ thống)")

# Vòng lặp vô hạn để giữ file luôn mở và theo dõi thời gian
while True:
    schedule.run_pending()
    time.sleep(60) # Cứ 60 giây (1 phút) sẽ kiểm tra đồng hồ 1 lần