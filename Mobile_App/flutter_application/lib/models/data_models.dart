
import 'dart:ui';

class WeatherData { 
  final String condition;
  final int temperature;
  final int highTemp;
  final int lowTemp;
  final int humidity;
  final int windSpeed;
  final String uvIndex;

  WeatherData({
    required this.temperature,
    required this.condition,
    required this.highTemp,
    required this.lowTemp,
    required this.humidity,
    required this.windSpeed,
    required this.uvIndex,
  });
}

class AQIData {
  final int aqi;
  final String quality;
  final String description;

  AQIData({
    required this.aqi,
    required this.quality,
    required this.description,
  });

  Color getColor() {
    if (aqi <= 50) return const Color(0xFF34D399);
    if (aqi <= 100) return const Color(0xFFFBBF24);
    if (aqi <= 150) return const Color(0xFFF97316);
    if (aqi <= 200) return const Color(0xFFEF4444);
    if (aqi <= 300) return const Color(0xFF9333EA);
    return const Color(0xFF7F1D1D);
  }
}

class ForecastData {
  final String time;
  final String icon;
  final int temperature;
  final String status;

  ForecastData({
    required this.time,
    required this.icon,
    required this.temperature,
    required this.status,
  });
}

class PollutantData {
  final String symbol;
  final String name;
  final double value;
  final String unit;
  final String status;

  PollutantData({
    required this.symbol,
    required this.name,
    required this.value,
    required this.unit,
    required this.status,
  });

  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'good':
        return const Color(0xFF34D399);
      case 'moderate':
        return const Color(0xFFFBBF24);
      case 'unhealthy':
        return const Color(0xFFF97316);
      default:
        return const Color(0xFFEF4444);
    }
  }
}

class NewsArticle {
  final String category;
  final String title;
  final String timeAgo;
  final String readTime;
  final String? imageUrl;

  NewsArticle({
    required this.category,
    required this.title,
    required this.timeAgo,
    required this.readTime,
    this.imageUrl,
  });
}

class CommunityMessage {
  final String userName;
  final String message;
  final String timeAgo;
  final String? avatarUrl;

  CommunityMessage({
    required this.userName,
    required this.message,
    required this.timeAgo,
    this.avatarUrl,
  });
}

class SmartDevice {
  final String name;
  final String location;
  final String status;
  final String type;

  SmartDevice({
    required this.name,
    required this.location,
    required this.status,
    required this.type,
  });
}

class UserData {
  final String name;
  final String id;
  final String lastActive;
  final int reports;

  UserData({
    required this.name,
    required this.id,
    required this.lastActive,
    required this.reports,
  });
}

class ModerationItem {
  final String username;
  final String content;
  final String timeAgo;
  final String type;

  ModerationItem({
    required this.username,
    required this.content,
    required this.timeAgo,
    required this.type,
  });
}
