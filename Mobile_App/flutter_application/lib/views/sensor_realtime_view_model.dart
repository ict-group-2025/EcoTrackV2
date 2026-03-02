import 'package:flutter/material.dart';
import '../services/sensor_sse_service.dart';
import '../models/data_models.dart';

class SensorRealtimeViewModel extends ChangeNotifier {
  final SensorSSEService _service = SensorSSEService();

  // Sensor data
  double? _temperature;
  double? _humidity;
  double? _pressure;
  int? _aqi;
  double? _pm25;
  String? _location;
  DateTime? _lastUpdate;

  // Getters
  double? get temperature => _temperature;
  double? get humidity => _humidity;
  double? get pressure => _pressure;
  int? get aqi => _aqi;
  double? get pm25 => _pm25;
  String? get location => _location;
  DateTime? get lastUpdate => _lastUpdate;
  bool get isLoading => _lastUpdate == null;
  bool get isConnected => _service.isConnected;

  // Formatted getters for UI
  String get temperatureDisplay => _temperature?.toStringAsFixed(1) ?? '--';
  String get humidityDisplay => _humidity?.toStringAsFixed(1) ?? '--';
  String get pressureDisplay => _pressure?.toStringAsFixed(1) ?? '--';
  String get aqiDisplay => _aqi?.toString() ?? '--';
  String get pm25Display => _pm25?.toStringAsFixed(1) ?? '--';

  String getAQILevel() {
    if (_aqi == null) return 'Unknown';
    if (_aqi! <= 50) return 'Good';
    if (_aqi! <= 100) return 'Moderate';
    if (_aqi! <= 150) return 'Unhealthy for Sensitive';
    if (_aqi! <= 200) return 'Unhealthy';
    if (_aqi! <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }

  Color getAQIColor() {
    if (_aqi == null) return const Color(0xFF6B7280);
    if (_aqi! <= 50) return const Color(0xFF34D399);
    if (_aqi! <= 100) return const Color(0xFFFBBF24);
    if (_aqi! <= 150) return const Color(0xFFF97316);
    if (_aqi! <= 200) return const Color(0xFFEF4444);
    if (_aqi! <= 300) return const Color(0xFF9333EA);
    return const Color(0xFF7F1D1D);
  }

  String getPM25Level() {
    if (_pm25 == null) return 'Unknown';
    if (_pm25! <= 12) return 'Good';
    if (_pm25! <= 35.4) return 'Moderate';
    if (_pm25! <= 55.4) return 'Unhealthy for Sensitive';
    if (_pm25! <= 150.4) return 'Unhealthy';
    if (_pm25! <= 250.4) return 'Very Unhealthy';
    return 'Hazardous';
  }

  Color getPM25Color() {
    if (_pm25 == null) return const Color(0xFF6B7280);
    if (_pm25! <= 12) return const Color(0xFF34D399);
    if (_pm25! <= 35.4) return const Color(0xFFFBBF24);
    if (_pm25! <= 55.4) return const Color(0xFFF97316);
    if (_pm25! <= 150.4) return const Color(0xFFEF4444);
    if (_pm25! <= 250.4) return const Color(0xFF9333EA);
    return const Color(0xFF7F1D1D);
  }

  SensorRealtimeViewModel() {
    _initializeStream();
  }

  void _initializeStream() {
    _service.dataStream.listen((data) {
      _updateSensorData(data);
    });
  }

  void _updateSensorData(Map<String, dynamic> data) {
    print('Updating sensor data with: $data');
    
    _temperature = (data['temp'] as num?)?.toDouble();
    _humidity = (data['hum'] as num?)?.toDouble();
    _pressure = (data['pres'] as num?)?.toDouble();
    _aqi = (data['aqi'] as num?)?.toInt();
    _pm25 = (data['pm25'] as num?)?.toDouble();
    _location = data['location'] as String?;
    
    if (data['timestamp'] != null) {
      _lastUpdate = DateTime.tryParse(data['timestamp'] as String);
    } else {
      _lastUpdate = DateTime.now();
    }

    print('Updated values - Temp: $_temperature, Humidity: $_humidity, AQI: $_aqi, PM2.5: $_pm25');
    
    notifyListeners();
    print('Notified listeners');
  }

  Future<void> connect() async {
    await _service.connect();
    notifyListeners();
  }

  void disconnect() {
    _service.disconnect();
    notifyListeners();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
