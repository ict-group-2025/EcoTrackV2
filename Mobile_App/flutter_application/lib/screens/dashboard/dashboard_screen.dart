import 'package:flutter/material.dart';
import 'package:flutter_application/items/location_search_sheet.dart';
import 'package:flutter_application/views/location_view_model.dart';
import 'package:flutter_application/views/weather_view_model.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../widgets/weather_card.dart';
import '../../widgets/aqi_card.dart';
import '../../widgets/weather_details_row.dart';
import '../../widgets/health_advice_card.dart';
import '../../widgets/forecast_section.dart';
import '../../widgets/pollutants_section.dart';
import '../../widgets/news_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? _lastLocationCoordinate;

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
                // WeatherCard(weather: appState.getWeatherData()),
                _buildWeather(),
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
        final String locationText = vm.isLoading
            ? 'Loading...'
            : vm.displayLocation;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.blue[400]),
                    const SizedBox(width: 4),
                    Text(
                      vm.isManualLocation
                          ? 'SELECTED LOCATION'
                          : 'CURRENT LOCATION',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        letterSpacing: 1.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
               FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    locationText,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const LocationSearchSheet(),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add, color: Colors.black54),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeather() {
    return Consumer2<LocationViewModel, WeatherViewModel>(
      builder: (context, locationVM, weatherVM, _) {
        /// Chưa có tọa độ thì không load
        if (locationVM.coordinate == null) {
          return const SizedBox();
        }

        /// Trigger load weather khi location thay đổi
        final coordStr =
            '${locationVM.coordinate!.latitude},${locationVM.coordinate!.longitude}';
        if (_lastLocationCoordinate != coordStr) {
          _lastLocationCoordinate = coordStr;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            weatherVM.loadWeather(
              locationVM.coordinate!.latitude,
              locationVM.coordinate!.longitude,
            );
          });
        }

        if (weatherVM.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (weatherVM.weather == null) {
          return const Text('No weather data');
        }

        return WeatherCard(weather: weatherVM.weather!);
      },
    );
  }
}
