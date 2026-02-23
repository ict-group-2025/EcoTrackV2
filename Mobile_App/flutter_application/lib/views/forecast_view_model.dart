// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_application/views/location_view_model.dart';

import '../controller/forecast_controller.dart';
import '../models/forecast_model.dart';
import '../models/data_models.dart';

class ForecastViewModel extends ChangeNotifier {
  final ForecastController controller;
  final LocationViewModel locationVM;

  ForecastViewModel(this.controller, this.locationVM) {
    locationVM.addListener(_onLocationChanged);
  }

  ForecastResponse? response;
  List<ForecastData> forecasts = [];
  bool isLoading = false;
  String? error;
  String? _lastCoordKey;

  void _onLocationChanged() {
    final coord = locationVM.coordinate;
    if (coord == null) return;
    final key = '${coord.latitude},${coord.longitude}';
    if (_lastCoordKey == key) return;
    _lastCoordKey = key;
    loadForecast(coord.latitude, coord.longitude);
  }

  Future<void> loadForecast(double lat, double lon) async {
    if (isLoading) return;
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      response = await controller.fetchForecast(lat: lat, lon: lon);
      forecasts = response?.list.map((e) => e.toForecastData()).toList() ?? [];
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
