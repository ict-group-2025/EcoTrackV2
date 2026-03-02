import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application/widgets/air_quality_header.dart';
import 'package:flutter_application/widgets/alert_card.dart';
import 'package:flutter_application/widgets/compare_card.dart';
import 'package:flutter_application/widgets/stats_row.dart';
import '../controller/air_quality_controller.dart';


class AirQualityScreen extends StatefulWidget {
  const AirQualityScreen({super.key});

  @override
  State<AirQualityScreen> createState() => _AirQualityScreenState();
}

class _AirQualityScreenState extends State<AirQualityScreen> {
  bool _alertEnabled = true;
  late AirQualityController _controller;
  StreamSubscription? _dataSubscription;

  @override
  void initState() {
    super.initState();
    _controller = AirQualityController();
    _controller.connect();

    _dataSubscription = _controller.dataStream.listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _dataSubscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  /// Converts the sensor's 0-2 scale AQI to the standard 0-500 scale.
  int? get _convertedAQI {
    final raw = _controller.model.aqi;
    if (raw == null) return null;
    return (raw * 50).clamp(0, 500);
  }

  bool get _isHazardous {
    final aqi = _convertedAQI;
    return aqi != null && aqi > 150;
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final model = _controller.model;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              AirQualityHeader(
                location: model.location,
                isConnected: _controller.isConnected,
                lastUpdate: model.lastUpdate,
              ),

              const SizedBox(height: 16),

              // ── Compare Card ─────────────────────────────────────────────
              CompareCard(
                indoorPanelColor: model.getAQIColor(),
                indoorAqi: _convertedAQI,
                indoorQualityLevel: model.getAQILevel(),
                indoorPm25Display: model.pm25Display,
              ),

              const SizedBox(height: 12),

              // ── Stats Row ────────────────────────────────────────────────
              StatsRow(
                temperature: model.temperatureDisplay,
                humidity: model.humidityDisplay,
                pressure: model.pressureDisplay,
              ),

              const SizedBox(height: 12),

              // ── Alert Card ───────────────────────────────────────────────
              AlertCard(
                isHazardous: _isHazardous,
                alertEnabled: _alertEnabled,
                onToggle: (val) => setState(() => _alertEnabled = val),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
