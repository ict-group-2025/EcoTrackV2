import 'package:flutter/material.dart';
import '../controller/dashboard_controller/ai_forecast_controller.dart';
import '../models/ai_forecast_model.dart';
import '../widgets/temperature_trend_card.dart';

class AIForecastViewModel extends ChangeNotifier {
  final AIForecastController controller;

  AIForecastViewModel(this.controller) {
    // Load data after a short delay to avoid build phase issues
    Future.delayed(Duration.zero, () {
      loadAIForecast();
    });
  }

  AIForecastResponse? response;
  List<TemperaturePoint> temperaturePoints = [];
  bool isLoading = false;
  String? error;
  String currentCity = 'hanoi';

  Future<void> loadAIForecast({String? city}) async {
    if (isLoading) return;
    
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final targetCity = city ?? currentCity;
      response = await controller.fetchAIForecast(targetCity);
      
      // Convert forecasts to TemperaturePoints for UI
      temperaturePoints = response?.forecasts
          .map((forecast) => forecast.toTemperaturePoint())
          .toList() ?? [];
      
      // Generate real time labels based on current time + 1h to 6h
      final now = DateTime.now();
      final fixedLabels = <String>[];
      
      for (int i = 0; i < 6; i++) {
        final futureTime = now.add(Duration(hours: i + 1)); // Start from +1h
        final hour = futureTime.hour;
        final suffix = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour % 12 == 0 ? 12 : hour % 12;
        
        fixedLabels.add('$displayHour$suffix');
      }
      
      // Override time labels with calculated real time
      for (int i = 0; i < temperaturePoints.length && i < fixedLabels.length; i++) {
        temperaturePoints[i] = TemperaturePoint(
          label: fixedLabels[i],
          temp: temperaturePoints[i].temp,
        );
      }
      
      // Take only first 6 points for display (6 hours forecast)
      if (temperaturePoints.length > 6) {
        temperaturePoints = temperaturePoints.take(6).toList();
      }
      
    } catch (e) {
      error = e.toString();
      // Fallback to default data on error
      temperaturePoints = const [
        TemperaturePoint(label: 'NOW', temp: 25),
        TemperaturePoint(label: '1H', temp: 24),
        TemperaturePoint(label: '2H', temp: 23),
        TemperaturePoint(label: '3H', temp: 22),
        TemperaturePoint(label: '4H', temp: 21),
        TemperaturePoint(label: '5H', temp: 20),
      ];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setCity(String city) {
    if (currentCity != city) {
      currentCity = city.toLowerCase();
      loadAIForecast();
    }
  }
}
