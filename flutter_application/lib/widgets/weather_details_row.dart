
import 'package:flutter/material.dart';
import '../models/data_models.dart';

class WeatherDetailsRow extends StatelessWidget {
  final WeatherData weather;

  const WeatherDetailsRow({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildWeatherDetail(
            Icons.water_drop_outlined,
            '${weather.humidity}%',
            'HUMIDITY',
          ),
          _buildWeatherDetail(Icons.air, '${weather.windSpeed} km/h', 'WIND'),
          _buildWeatherDetail(
            Icons.wb_sunny_outlined,
            weather.uvIndex,
            'UV INDEX',
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[400], size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
