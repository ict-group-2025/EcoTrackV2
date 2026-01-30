import 'package:flutter/material.dart';
import '../controller/weather_controller.dart';
import '../models/weather_model.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherController controller;

  WeatherViewModel(this.controller);

  WeatherModel? weather;
  bool isLoading = false;
  String? error;

  Future<void> loadWeather(double lat, double lon) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      weather = await controller.fetchWeather(lat: lat, lon: lon);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
