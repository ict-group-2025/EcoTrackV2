import 'package:flutter/material.dart';
import 'package:flutter_application/models/weather_model.dart';

class WeatherDetailsRow extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetailsRow({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final String timeRise =
        '${weather.sunrise.hour}:${weather.sunrise.minute.toString().padLeft(2, '0')}';
        final String timeSet =
        '${weather.sunset.hour}:${weather.sunset.minute.toString().padLeft(2, '0')}';
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // Row 1: Humidity & Wind
          Row(
            children: [
              Expanded(
                child: _buildWeatherDetail(
                  Icons.water_drop_outlined,
                  '${weather.humidity}%',
                  'HUMIDITY',
                  Colors.blue
                ),
              ),
              Expanded(
                child: _buildWeatherDetail(
                  Icons.air,
                  '${weather.windSpeed} km/h',
                  'WIND',
                  Colors.grey
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Row 2: Sunrise & Sunset
          Row(
            children: [
              Expanded(
                child: _buildWeatherDetail(
                  Icons.wb_sunny,
                timeRise , // Thêm sunrise vào WeatherModel
                  'SUNRISE',
                  Colors.orange
                ),
              ),
              Expanded(
                child: _buildWeatherDetail(
                  Icons.nights_stay,
                  timeSet, // Thêm sunset vào WeatherModel
                  'SUNSET',
                  Colors.orange
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String value, String label,Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 26),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey[600],
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
