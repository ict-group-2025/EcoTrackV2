import 'package:flutter/material.dart';
import 'package:flutter_application/views/location_view_model.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../widgets/weather_card.dart';
import '../widgets/aqi_card.dart';
import '../widgets/weather_details_row.dart';
import '../widgets/health_advice_card.dart';
import '../widgets/forecast_section.dart';
import '../widgets/pollutants_section.dart';
import '../widgets/news_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Request location once after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationViewModel>().loadLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                WeatherCard(weather: appState.getWeatherData()),
                const SizedBox(height: 16),
                AQICard(aqi: appState.getAQIData()),
                const SizedBox(height: 16),
                WeatherDetailsRow(weather: appState.getWeatherData()),
                const SizedBox(height: 16),
                HealthAdviceCard(aqi: appState.getAQIData()),
                const SizedBox(height: 24),
                ForecastSection(forecasts: appState.getForecastData()),
                const SizedBox(height: 24),
                PollutantsSection(pollutants: appState.getPollutants()),
                const SizedBox(height: 24),
                NewsSection(articles: appState.getNewsArticles()),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<LocationViewModel>(
      builder: (context, vm, _) {
        final locationText = vm.isLoading ? "Loading..." : vm.displayLocation;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'CURRENT LOCATION',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            letterSpacing: 1.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    locationText,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.nightlight_round, color: Colors.black54),
            ),
          ],
        );
      },
    );
  }
}
