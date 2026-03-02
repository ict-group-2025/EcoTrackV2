import 'package:flutter/material.dart';
import 'stat_card.dart';

class StatsRow extends StatelessWidget {
  final String temperature;
  final String humidity;
  final String pressure;

  const StatsRow({
    super.key,
    required this.temperature,
    required this.humidity,
    required this.pressure,
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
        ),
        const SizedBox(width: 12),
        StatCard(
          icon: Icons.water_drop_outlined,
          label: 'HUMIDITY',
          value: humidity,
          unit: '%',
        ),
        const SizedBox(width: 12),
        StatCard(
          icon: Icons.compress_outlined,
          label: 'PRESSURE',
          value: pressure,
          unit: 'hPa',
        ),
      ],
    );
  }
}
