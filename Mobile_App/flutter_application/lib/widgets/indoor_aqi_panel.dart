import 'package:flutter/material.dart';

class IndoorAQIPanel extends StatelessWidget {
  final int? aqi;
  final String qualityLevel;
  final Color panelColor;
  final String? pm25Display;
  final Animation<double>? animation;

  const IndoorAQIPanel({
    super.key,
    this.aqi,
    required this.qualityLevel,
    required this.panelColor,
    this.pm25Display,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation ?? const AlwaysStoppedAnimation(0),
      builder: (context, child) {
        return Container(
          color: panelColor,
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel(),
              const SizedBox(height: 12),
              Transform.scale(
                scale: 1.0 + (animation?.value ?? 0) * 0.1,
                child: Text(
                  aqi?.toString() ?? '--',
                  style: const TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                qualityLevel,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xDEFFFFFF),
                ),
              ),
              const SizedBox(height: 10),
              _buildProgressBar(),
              const SizedBox(height: 8),
              Text(
                'PM2.5 · ${pm25Display ?? '--'} µg/m³',
                style: const TextStyle(fontSize: 10, color: Color(0x8DFFFFFF)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabel() {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'INDOOR',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Color(0xBFFFFFFF),
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
        value: ((aqi ?? 0) / 500.0).clamp(0.0, 1.0),
        minHeight: 3,
        backgroundColor: Colors.white.withOpacity(0.25),
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }
}