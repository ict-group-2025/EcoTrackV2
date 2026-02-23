import 'package:flutter/material.dart';
import 'package:flutter_application/models/weather_model.dart';
import 'package:flutter_application/utils/weather_image_mapper.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final imagePath = WeatherImageMapper.fromModel(weather);

    return 
    
    Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${weather.temp}°',
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                weather.condition,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                _buildTempExtra(weather),
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          Image.asset(imagePath, width: 100),
        ],
      ),
    );
  }
  String _buildTempExtra(WeatherModel w) {
    if (w.highTemp.round() == w.lowTemp.round()) {
      return 'Feels like ${w.feelsLike.round()}°';
    }
    return 'High:${w.highTemp.round()}°  Low:${w.lowTemp.round()}°';
  }
}
