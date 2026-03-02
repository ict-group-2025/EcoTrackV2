import 'package:flutter/material.dart';
import 'stat_card.dart';

class StatsRow extends StatelessWidget {
  final String temperature;
  final String humidity;
  final String pressure;
  final Animation<double>? tempAnimation;
  final Animation<double>? humAnimation;
  final Animation<double>? presAnimation;

  const StatsRow({
    super.key,
    required this.temperature,
    required this.humidity,
    required this.pressure,
    this.tempAnimation,
    this.humAnimation,
    this.presAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StatCard(
          icon: Icons.thermostat_outlined,
          label: 'TEMP',
          value: temperature,
          unit: '°C',
          animation: tempAnimation,
        ),
        const SizedBox(width: 12),
        StatCard(
          icon: Icons.water_drop_outlined,
          label: 'HUMIDITY',
          value: humidity,
          unit: '%',
          animation: humAnimation,
        ),
        const SizedBox(width: 12),
        StatCard(
          icon: Icons.compress_outlined,
          label: 'PRESSURE',
          value: pressure,
          unit: 'hPa',
          animation: presAnimation,
        ),
      ],
    );
  }
}
