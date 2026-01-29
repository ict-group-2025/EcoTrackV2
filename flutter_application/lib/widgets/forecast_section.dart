
import 'package:flutter/material.dart';
import '../models/data_models.dart';

class ForecastSection extends StatelessWidget {
  final List<ForecastData> forecasts;

  const ForecastSection({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '24-Hour Forecast',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(onPressed: () {}, child: const Text('See Detail')),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecasts.length,
            itemBuilder: (context, index) {
              return _buildForecastCard(forecasts[index], index == 0);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildForecastCard(ForecastData forecast, bool isNow) {
    final indicatorColor = forecast.status == 'good'
        ? Colors.green
        : Colors.orange;

    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isNow ?  Colors.blue.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            forecast.time,
            style: TextStyle(
              fontSize: 12,
              color:  Colors.black87,
            ),
          ),
          Icon(
            _getWeatherIcon(forecast.icon),
            color:  Colors.orange,
            size: 32,
          ),
          Text(
            '${forecast.temperature}°',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color:  Colors.black,
            ),
          ),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: indicatorColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(String icon) {
    switch (icon) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'rainy':
        return Icons.water_drop;
      default:
        return Icons.wb_sunny;
    }
  }
}
