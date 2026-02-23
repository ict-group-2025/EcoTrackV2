// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_application/views/location_view_model.dart';

import '../controller/weather_controller.dart';
import '../models/weather_model.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherController controller;
  final LocationViewModel locationVM;

  WeatherViewModel(this.controller, this.locationVM) {
    locationVM.addListener(_onLocationChanged);
  }

  WeatherModel? weather;
  bool isLoading = false;
  String? error;
  String? _lastCoordKey;
  void _onLocationChanged() {
    final coord = locationVM.coordinate;
    if (coord == null) return;
    final key = '${coord.latitude},${coord.longitude}';
    if (_lastCoordKey == key) return;
    _lastCoordKey = key;
    loadWeather(coord.latitude, coord.longitude);
  }

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

  @override
  void dispose() {
    locationVM.removeListener(_onLocationChanged);
    super.dispose();
  }
}
