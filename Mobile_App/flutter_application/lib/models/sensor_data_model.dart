import 'package:flutter/material.dart';

class SensorDataModel {
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

  // Formatted getters for UI
  String get temperatureDisplay => _temperature?.toStringAsFixed(1) ?? '--';
  String get humidityDisplay => _humidity?.toStringAsFixed(1) ?? '--';
  String get pressureDisplay => _pressure?.toStringAsFixed(1) ?? '--';
  String get aqiDisplay => _aqi?.toString() ?? '--';
  String get pm25Display => _pm25?.toStringAsFixed(1) ?? '--';

  // AQI level and color methods
  String getAQILevel() {
    if (_aqi == null) return 'Unknown';
    
    final convertedAQI = _convertAQI(_aqi!);
    
    if (convertedAQI <= 50) return 'Good';
    if (convertedAQI <= 100) return 'Moderate';
    if (convertedAQI <= 150) return 'Unhealthy for Sensitive';
    if (convertedAQI <= 200) return 'Unhealthy';
    if (convertedAQI <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }

  Color getAQIColor() {
    if (_aqi == null) return const Color(0xFF6B7280);
    
    final convertedAQI = _convertAQI(_aqi!);
    
    if (convertedAQI <= 50) return const Color(0xFF34D399);
    if (convertedAQI <= 100) return const Color(0xFFFBBF24);
    if (convertedAQI <= 150) return const Color(0xFFF97316);
    if (convertedAQI <= 200) return const Color(0xFFEF4444);
    if (convertedAQI <= 300) return const Color(0xFF9333EA);
    return const Color(0xFF7F1D1D);
  }

  bool get isHazardous {
    if (_aqi == null) return false;
    
    // Convert AQI to standard scale if needed
    final convertedAQI = _convertAQI(_aqi!);
    return convertedAQI > 150;
  }

  // Helper method to convert AQI to standard scale
  int _convertAQI(int sensorAQI) {
    // Sensor AQI appears to be on 0-2 scale, convert to standard AQI (0-500)
    // If sensor AQI = 1 (on 0-2 scale), it should be 50 (on 0-500 scale)
    // If sensor AQI = 2 (on 0-2 scale), it should be 100 (on 0-500 scale)
    return (sensorAQI * 50).clamp(0, 500);
  }

  // Update methods
  void updateFromJson(Map<String, dynamic> data) {
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
  }

  void reset() {
    _temperature = null;
    _humidity = null;
    _pressure = null;
    _aqi = null;
    _pm25 = null;
    _location = null;
    _lastUpdate = null;
  }
}
