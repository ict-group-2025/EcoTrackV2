import 'package:flutter/material.dart';

class OutdoorAQIPanel extends StatelessWidget {
  final int aqi;
  final String qualityLevel;
  final double? pm25;
  final bool isLoading;

  const OutdoorAQIPanel({
    super.key,
    required this.aqi,
    required this.qualityLevel,
    this.pm25,
    this.isLoading = false,
  });

  Color get _qualityColor {
    switch (qualityLevel.toLowerCase()) {
      case 'good':
        return const Color(0xFF34D399);
      case 'moderate':
        return const Color(0xFFFBBF24);
      case 'unhealthy for sensitive':
        return const Color(0xFFF97316);
      case 'unhealthy':
        return const Color(0xFFEF4444);
      case 'very unhealthy':
        return const Color(0xFF9333EA);
      case 'hazardous':
        return const Color(0xFF7F1D1D);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 180,
        color: Colors.white,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(),
          const SizedBox(height: 12),
          Text(
            aqi.toString(),
            style: const TextStyle(
              fontSize: 54,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            qualityLevel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _qualityColor,
            ),
          ),
          const SizedBox(height: 10),
          _buildProgressBar(),
          const SizedBox(height: 8),
          Text(
            'PM2.5 · ${pm25?.toStringAsFixed(1) ?? '--'} µg/m³',
            style: const TextStyle(fontSize: 10, color: Color(0xFF8A8A8A)),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel() {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: _qualityColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'OUTDOOR',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Color(0xFF8A8A8A),
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: LinearProgressIndicator(
        value: (aqi / 500.0).clamp(0.0, 1.0),
        minHeight: 3,
        backgroundColor: const Color(0xFFEEEEEE),
        valueColor: AlwaysStoppedAnimation<Color>(_qualityColor),
      ),
    );
  }
}