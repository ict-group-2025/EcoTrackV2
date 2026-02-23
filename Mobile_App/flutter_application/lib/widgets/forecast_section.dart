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
            TextButton(onPressed: () {}, child: const Text('See Detail',style: TextStyle(color: Colors.blue),)),
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
    final int humidity = (forecast.humidity.clamp(0, 100));

    return Container(
      width: 80,
      margin: EdgeInsetsGeometry.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isNow ? Colors.blue.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            forecast.time,
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
          // use asset image provided by mapper
          Image.asset(forecast.icon, width: 32, height: 32),
          Text(
            '${forecast.temperature}°',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            // ignore: sort_child_properties_last
            children: [
              Icon(Icons.water_drop_outlined, color: Colors.blue,size: 12,),
              Text("${humidity.toString()}%", style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
