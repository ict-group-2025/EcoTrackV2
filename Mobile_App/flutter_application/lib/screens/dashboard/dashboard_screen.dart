import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/items/location_search_sheet.dart';
import 'package:flutter_application/views/air_quality_view_model.dart';
import 'package:flutter_application/views/forecast_view_model.dart';
import 'package:flutter_application/views/location_view_model.dart';
import 'package:flutter_application/views/weather_view_model.dart';
import 'package:flutter_application/views/ai_forecast_view_model.dart';
import 'package:flutter_application/widgets/box_skeleton.dart';
import 'package:flutter_application/models/data_models.dart';
import 'package:flutter_application/widgets/temperature_trend_card.dart';
import 'package:flutter_application/widgets/temperature_trend_card_skeleton.dart';
// import 'package:flutter_application/widgets/forecast_section_v2.dart';
import 'package:provider/provider.dart';
// import '../../services/app_state.dart';
import '../../widgets/weather_card.dart';
import '../../widgets/aqi_card.dart';
import '../../widgets/weather_details_row.dart';
// import '../../widgets/health_advice_card.dart';
import '../../widgets/forecast_section.dart';
import '../../widgets/pollutants_section.dart';
// import '../../widgets/news_section.dart';

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
    // final appState = Provider.of<AppState>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerHeader(),
                const SizedBox(height: 24),
                // WeatherCard(weather: appState.getWeatherData()),
                _buildWeather(),
                Consumer<LocationViewModel>(
                  builder: (context, locationVM, _) {
                    // Hide AI forecast when using manual location selection
                    if (locationVM.isManualLocation) {
                      return const SizedBox.shrink();
                    }
                    return _buildAIForecastViewModel();
                  },
                ),
                const SizedBox(height: 16),
                _buildAQICard(),
                const SizedBox(height: 16),
                _buildWeatherDetail(),
                const SizedBox(height: 16),
                // HealthAdviceCard(aqi: appState.getAQIData()),
                const SizedBox(height: 24),
                _buildForecastSection(),
                // _buildForecastSectionV2(),
                const SizedBox(height: 24),
                _buildPollutantsSection(),
                const SizedBox(height: 24),
                // NewsSection(articles: appState.getNewsArticles()),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _shimmerHeader() {
    return SizedBox(
      height: 51,
      child: Consumer<LocationViewModel>(
        builder: (_, vm, __) {
          if (vm.isLoading) {
            return const BoxSkeleton(height: double.infinity);
          }

          return _buildHeader();
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<LocationViewModel>(
      builder: (context, vm, _) {
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
                AutoSizeText(
                  vm.displayLocation,
                  minFontSize: 24,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
    return Consumer<WeatherViewModel>(
      builder: (_, vm, __) {
        return SizedBox(
          height: 191,
          child: vm.isLoading || vm.weather == null
              ? const BoxSkeleton(height: double.infinity)
              : WeatherCard(weather: vm.weather!),
        );
      },
    );
  }

  Widget _buildWeatherDetail() {
    return Consumer<WeatherViewModel>(
      builder: (_, vm, __) {
        return SizedBox(
          height: 148,
          child: vm.isLoading || vm.weather == null
              ? BoxSkeleton(height: double.infinity)
              : WeatherDetailsRow(weather: vm.weather!),
        );
      },
    );
  }

  Widget _buildAQICard() {
    return Consumer<AirQualityViewModel>(
      builder: (_, vm, __) {
        if (vm.isLoading || vm.currentItem == null) {
          return const BoxSkeleton(height: 180);
        }

        final aqi = vm.currentAQI ?? 0;
        final quality = vm.getQualityLevel();
        final description = vm.getQualityDescription();

        final aqiData = AQIData(
          aqi: aqi,
          quality: quality,
          description: description,
        );

        return SizedBox(height: 180, child: AQICard(aqi: aqiData));
      },
    );
  }

  Widget _buildForecastSection() {
    return Consumer<ForecastViewModel>(
      builder: (_, vm, __) {
        if (vm.isLoading) {
          return const BoxSkeleton(height: 160);
        }

        if (vm.error != null) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(child: Text('Error: ${vm.error}')),
          );
        }

        if (vm.forecasts.isEmpty) {
          return const BoxSkeleton(height: 160);
        }

        return ForecastSection(forecasts: vm.forecasts);
      },
    );
  }

  Widget _buildAIForecastViewModel() {
    return Consumer<AIForecastViewModel>(
      builder: (_, vm, __) {
        if (vm.isLoading) {
          return const TemperatureTrendCardSkeleton();
        }
        return Column(
          children: [
            const SizedBox(height: 16),
            TemperatureTrendCard(
              data: vm.temperaturePoints,
              isLoading: vm.isLoading,
              error: vm.error,
            ),
          ],
        );
      },
    );
  }

  // Widget _buildForecastSectionV2() {
  //   return Consumer<ForecastViewModel>(
  //     builder: (_, vm, __) {
  //       if (vm.isLoading || vm.forecasts.isEmpty) {
  //         return const BoxSkeleton(height: 180);
  //       }

  //       if (vm.error != null) {
  //         return Container(
  //           padding: const EdgeInsets.all(12),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(24),
  //           ),
  //           child: Center(child: Text('Error: ${vm.error}')),
  //         );
  //       }

  //       return ForecastSectionV2(forecasts: vm.forecasts);
  //     },
  //   );
  // }

  Widget _buildPollutantsSection() {
    return Consumer<AirQualityViewModel>(
      builder: (_, vm, __) {
        if (vm.isLoading || vm.currentItem == null) {
          return const BoxSkeleton(height: 180);
        }

        final quality = vm.getQualityLevel();

        final pollutants = <PollutantData>[
          PollutantData(
            symbol: 'PM2.5',
            name: 'PM2.5',
            value: vm.currentItem!.components.pm25,
            unit: 'µg/m³',
            status: quality,
          ),
          PollutantData(
            symbol: 'PM10',
            name: 'PM10',
            value: vm.currentItem!.components.pm10,
            unit: 'µg/m³',
            status: quality,
          ),
          PollutantData(
            symbol: 'O3',
            name: 'Ozone',
            value: vm.currentItem!.components.o3,
            unit: 'µg/m³',
            status: quality,
          ),
          PollutantData(
            symbol: 'NO2',
            name: 'Nitrogen dioxide',
            value: vm.currentItem!.components.no2,
            unit: 'µg/m³',
            status: quality,
          ),
        ];

        return PollutantsSection(pollutants: pollutants);
      },
    );
  }
}
