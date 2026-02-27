import 'package:flutter/material.dart';

import 'package:flutter_application/views/location_view_model.dart';

import '../controller/dashboard_controller/air_quality_controller.dart';
import '../models/air_quality_model.dart';

class AirQualityViewModel extends ChangeNotifier {
  final AirQualityController controller;
  final LocationViewModel locationVM;

  AirQualityViewModel(this.controller, this.locationVM) {
    locationVM.addListener(_onLocationChanged);
  }

  AirQualityModel? airQuality;
  AirQualityItem? currentItem;
  bool isLoading = false;
  String? error;
  String? _lastCoordKey;

  /// Get current AQI value
  int? get currentAQI => currentItem?.components.calculatePM25AQI();

  /// Get quality level based on AQI
  String getQualityLevel() {
    final aqi = currentAQI;
    if (aqi == null) return '';
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy for Sensitive Groups';
    if (aqi <= 200) return 'Unhealthy';
    if (aqi <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }

  /// Get quality description based on AQI
  String getQualityDescription() {
    final aqi = currentAQI;
    if (aqi == null) return '';
    if (aqi <= 50) return 'Air quality is satisfactory';
    if (aqi <= 100) return 'Air quality is acceptable';
    if (aqi <= 150) {
      return 'Members of sensitive groups may experience health effects';
    }
    if (aqi <= 200) {
      return 'Some members of the general public may experience health effects';
    }
    if (aqi <= 300) {
      return 'Health alert: The risk of health effects is increased for everyone';
    }
    return 'Health warning of emergency conditions: everyone is more likely to be affected';
  }

  void _onLocationChanged() {
    final coord = locationVM.coordinate;
    if (coord == null) return;
    final key = '${coord.latitude},${coord.longitude}';
    if (_lastCoordKey == key) return;
    _lastCoordKey = key;
    loadAirQuality(coord.latitude, coord.longitude);
  }

  Future<void> loadAirQuality(double lat, double lon) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      airQuality = await controller.fetchAirQuality(lat: lat, lon: lon);

      // Get the first item from the list
      if (airQuality != null && airQuality!.list.isNotEmpty) {
        currentItem = airQuality!.list.first;
      }
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
