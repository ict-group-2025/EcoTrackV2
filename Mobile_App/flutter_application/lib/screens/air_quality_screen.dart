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

class _AirQualityScreenState extends State<AirQualityScreen> with TickerProviderStateMixin {
  bool _alertEnabled = true;
  late AirQualityController _controller;
  StreamSubscription? _dataSubscription;
  
  // Animation controllers for highlighting changes
  final Map<String, AnimationController> _animationControllers = {};
  final Map<String, Animation<double>> _animations = {};
  
  // Previous values for comparison
  double? _prevTemp;
  double? _prevHum;
  double? _prevPres;
  int? _prevAqi;
  double? _prevPm25;

  @override
  void initState() {
    super.initState();
    _controller = AirQualityController();
    _controller.connect();
    
    // Initialize animation controllers
    _initializeAnimations();

    _dataSubscription = _controller.dataStream.listen((data) {
      if (mounted) {
        _checkForChanges();
        setState(() {});
      }
    });
  }
  
  void _initializeAnimations() {
    final fields = ['temp', 'hum', 'pres', 'aqi', 'pm25'];
    for (final field in fields) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      );
      _animationControllers[field] = controller;
      _animations[field] = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }
  }
  
  void _checkForChanges() {
    final model = _controller.model;
    
    if (_prevTemp != null && _prevTemp != model.temperature) {
      _triggerAnimation('temp');
    }
    if (_prevHum != null && _prevHum != model.humidity) {
      _triggerAnimation('hum');
    }
    if (_prevPres != null && _prevPres != model.pressure) {
      _triggerAnimation('pres');
    }
    if (_prevAqi != null && _prevAqi != model.aqi) {
      _triggerAnimation('aqi');
    }
    if (_prevPm25 != null && _prevPm25 != model.pm25) {
      _triggerAnimation('pm25');
    }
    
    // Update previous values
    _prevTemp = model.temperature;
    _prevHum = model.humidity;
    _prevPres = model.pressure;
    _prevAqi = model.aqi;
    _prevPm25 = model.pm25;
  }
  
  void _triggerAnimation(String field) {
    final controller = _animationControllers[field];
    if (controller != null) {
      controller.reset();
      controller.forward();
    }
  }

  @override
  void dispose() {
    _dataSubscription?.cancel();
    _controller.dispose();
    
    // Dispose animation controllers
    for (final controller in _animationControllers.values) {
      controller.dispose();
    }
    
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
                aqiAnimation: _animations['aqi'],
              ),

              const SizedBox(height: 12),

              // ── Stats Row ────────────────────────────────────────────────
              StatsRow(
                temperature: model.temperatureDisplay,
                humidity: model.humidityDisplay,
                pressure: model.pressureDisplay,
                tempAnimation: _animations['temp'],
                humAnimation: _animations['hum'],
                presAnimation: _animations['pres'],
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
