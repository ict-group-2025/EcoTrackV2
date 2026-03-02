import 'package:flutter_application/widgets/temperature_trend_card.dart';

class AIForecastResponse {
  final int count;
  final List<AIForecastItem> forecasts;
  final String status;
  final String city;

  AIForecastResponse({
    required this.count,
    required this.forecasts,
    required this.status,
    required this.city,
  });

  factory AIForecastResponse.fromJson(Map<String, dynamic> json) {
    return AIForecastResponse(
      count: json['count'] as int? ?? 0,
      forecasts: (json['forecasts'] as List<dynamic>?)
          ?.map((e) => AIForecastItem.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      status: json['status'] as String? ?? '',
      city: json['city'] as String? ?? '',
    );
  }
}

class AIForecastItem {
  final int id;
  final int locationId;
  final DateTime forecastTime;
  final double temperature;
  final String modelType;
  final double confidenceScore;
  final DateTime createdAt;
  final AILocation location;

  AIForecastItem({
    required this.id,
    required this.locationId,
    required this.forecastTime,
    required this.temperature,
    required this.modelType,
    required this.confidenceScore,
    required this.createdAt,
    required this.location,
  });

  factory AIForecastItem.fromJson(Map<String, dynamic> json) {
    return AIForecastItem(
      id: json['id'] as int? ?? 0,
      locationId: json['locationId'] as int? ?? 0,
      forecastTime: DateTime.parse(json['forecastTime'] as String),
      temperature: (json['temperature'] as num).toDouble(),
      modelType: json['modelType'] as String? ?? '',
      confidenceScore: (json['confidenceScore'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      location: AILocation.fromJson(json['location'] as Map<String, dynamic>),
    );
  }

  /// Convert to TemperaturePoint for UI
  TemperaturePoint toTemperaturePoint() {
    // Generate fixed time labels for next 6 hours
    String getFixedTimeLabel(int index) {
      switch (index) {
        case 0:
          return 'NOW';
        case 1:
          return '1H';
        case 2:
          return '2H';
        case 3:
          return '3H';
        case 4:
          return '4H';
        case 5:
          return '5H';
        default:
          return '${index}H';
      }
    }
    
    // Find the index of this forecast in the list (assuming it's ordered by time)
    // For now, we'll use a simple approach based on current hour
    final now = DateTime.now();
    final currentHour = now.hour;
    final forecastHour = forecastTime.hour;
    
    // Calculate hours difference
    int hoursDiff = forecastHour - currentHour;
    if (hoursDiff < 0) hoursDiff += 24; // Handle next day
    
    // Map to 0-5 index for our 6-hour display
    int displayIndex = hoursDiff.clamp(0, 5);
    
    return TemperaturePoint(
      label: getFixedTimeLabel(displayIndex),
      temp: temperature.round(),
    );
  }
}

class AILocation {
  final int id;
  final String cityName;
  final String countryCode;
  final double latitude;
  final double longitude;

  AILocation({
    required this.id,
    required this.cityName,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
  });

  factory AILocation.fromJson(Map<String, dynamic> json) {
    return AILocation(
      id: json['id'] as int? ?? 0,
      cityName: json['cityName'] as String? ?? '',
      countryCode: json['countryCode'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
