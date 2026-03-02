
import 'package:flutter/material.dart';
import '../models/data_models.dart';

class HealthAdviceCard extends StatelessWidget {
  final AQIData aqi;
  final WeatherData weather;

  const HealthAdviceCard({
    super.key, 
    required this.aqi,
    required this.weather,
  });

  String getHealthAdvice() {
    final temp = weather.temperature;
    final aqiValue = aqi.aqi;
    final humidity = weather.humidity;
    
    List<String> advice = [];
    
    // AQI-based advice
    if (aqiValue <= 50) {
      advice.add("Air quality is good. Perfect for outdoor activities!");
    } else if (aqiValue <= 100) {
      advice.add("Air quality is moderate. Sensitive individuals should limit prolonged outdoor exertion.");
    } else if (aqiValue <= 150) {
      advice.add("Unhealthy for sensitive groups. Consider wearing a mask outdoors.");
    } else if (aqiValue <= 200) {
      advice.add("Unhealthy air quality. Avoid prolonged outdoor activities.");
    } else {
      advice.add("Very unhealthy air quality. Stay indoors if possible.");
    }
    
    // Temperature-based advice
    if (temp >= 35) {
      advice.add("Extreme heat! Stay hydrated and avoid sun exposure during peak hours.");
    } else if (temp >= 30) {
      advice.add("Hot weather. Drink plenty of water and seek shade when outdoors.");
    } else if (temp >= 25) {
      advice.add("Warm weather. Good for outdoor activities but stay hydrated.");
    } else if (temp >= 20) {
      advice.add("Pleasant temperature. Great weather for outdoor exercise.");
    } else if (temp >= 15) {
      advice.add("Cool weather. Light jacket recommended for outdoor activities.");
    } else if (temp >= 10) {
      advice.add("Cold weather. Dress warmly and limit prolonged outdoor exposure.");
    } else {
      advice.add("Very cold! Bundle up and avoid extended outdoor activities.");
    }
    
    // Humidity-based advice
    if (humidity > 70) {
      advice.add("High humidity may make it feel warmer. Take breaks in air-conditioned spaces.");
    } else if (humidity < 30) {
      advice.add("Low humidity. Use moisturizer and stay hydrated to prevent dry skin.");
    }
    
    // Combined conditions advice
    if (aqiValue > 100 && temp > 30) {
      advice.add("Poor air quality combined with heat. Avoid outdoor strenuous activities.");
    }
    
    if (aqiValue > 150 && temp < 10) {
      advice.add("Poor air quality with cold air. Wear mask and dress warmly if going outside.");
    }
    
    return advice.first;
  }

  String getHealthRiskLevel() {
    final aqiValue = aqi.aqi;
    final temp = weather.temperature;
    
    // Calculate overall risk based on AQI and temperature
    int riskScore = 0;
    
    // AQI risk (0-5)
    if (aqiValue <= 50) riskScore += 0;
    else if (aqiValue <= 100) riskScore += 1;
    else if (aqiValue <= 150) riskScore += 2;
    else if (aqiValue <= 200) riskScore += 3;
    else if (aqiValue <= 300) riskScore += 4;
    else riskScore += 5;
    
    // Temperature risk (0-3)
    if (temp >= 20 && temp <= 30) riskScore += 0; // Ideal
    else if (temp >= 15 && temp < 20) riskScore += 1; // Cool
    else if (temp > 30 && temp < 35) riskScore += 1; // Warm
    else if (temp >= 10 && temp < 15) riskScore += 2; // Cold
    else if (temp >= 35) riskScore += 3; // Hot
    else if (temp < 10) riskScore += 3; // Very cold
    
    // Determine risk level
    if (riskScore <= 1) return "Low Risk";
    if (riskScore <= 3) return "Moderate Risk";
    if (riskScore <= 5) return "High Risk";
    return "Very High Risk";
  }

  Color getRiskColor() {
    final riskLevel = getHealthRiskLevel();
    switch (riskLevel) {
      case "Low Risk":
        return const Color(0xFF34D399); // Green
      case "Moderate Risk":
        return const Color(0xFFFBBF24); // Yellow
      case "High Risk":
        return const Color(0xFFF97316); // Orange
      case "Very High Risk":
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  @override
  Widget build(BuildContext context) {
    final advice = getHealthAdvice();
    final riskLevel = getHealthRiskLevel();
    final riskColor = getRiskColor();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: riskColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: riskColor.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: riskColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getRiskIcon(),
              color: riskColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Health Advisory: $riskLevel',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 14,
                    color: riskColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  advice,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoChip("AQI: ${aqi.aqi}", aqi.getColor()),
                    const SizedBox(width: 8),
                    _buildInfoChip("${weather.temperature}°C", Colors.blue),
                    const SizedBox(width: 8),
                    _buildInfoChip("${weather.humidity}%", Colors.cyan),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getRiskIcon() {
    final riskLevel = getHealthRiskLevel();
    switch (riskLevel) {
      case "Low Risk":
        return Icons.check_circle;
      case "Moderate Risk":
        return Icons.warning_amber;
      case "High Risk":
        return Icons.warning;
      case "Very High Risk":
        return Icons.dangerous;
      default:
        return Icons.health_and_safety;
    }
  }

  Widget _buildInfoChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
