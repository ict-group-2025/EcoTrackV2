import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/data_models.dart';

enum WeatherCondition { cloudy, partlyCloudy, sunny, sunrise, rainy }

class HourlyWeather {
  final String time;
  final int? temperature;
  final int? precipitation;
  final WeatherCondition condition;
  final bool isSunrise;
  final String? label;

  const HourlyWeather({
    required this.time,
    this.temperature,
    this.precipitation,
    required this.condition,
    this.isSunrise = false,
    this.label,
  });
}

class ForecastSectionV2 extends StatelessWidget {
  final List<ForecastData>? forecasts;

  const ForecastSectionV2({super.key, this.forecasts});

  static const double colWidth = 72.0;

  /// Convert forecast status to weather condition
  WeatherCondition _getCondition(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('rain')) return WeatherCondition.rainy;
    if (lower.contains('cloud') || lower.contains('overcast')) {
      return WeatherCondition.cloudy;
    }
    if (lower.contains('clear') || lower.contains('sunny')) {
      return WeatherCondition.sunny;
    }
    return WeatherCondition.cloudy;
  }

  /// Convert ForecastData list to HourlyWeather list
  List<HourlyWeather> _buildHourlyWeatherList() {
    if (forecasts == null || forecasts!.isEmpty) {
      return <HourlyWeather>[];
    }

    String formatTime(String raw) {
      try {
        final dt = DateTime.parse(raw).toLocal();
        return DateFormat('h a').format(dt);
      } catch (_) {
        return raw;
      }
    }

    return forecasts!
        .map(
          (f) => HourlyWeather(
            time: formatTime(f.time),
            temperature: f.temperature,
            precipitation: null,
            condition: _getCondition(f.status),
            isSunrise: false,
            label: null,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final weatherList = _buildHourlyWeatherList();
    final displayData = weatherList.isNotEmpty
        ? weatherList
        : <HourlyWeather>[];

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4B6CB7), Color(0xFF6A85B6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: displayData.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No forecast data',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time row
                    Row(
                      children: displayData
                          .map(
                            (item) => SizedBox(
                              width: colWidth,
                              child: Center(
                                child: Text(
                                  item.time,
                                  style: TextStyle(
                                    color: item.isSunrise
                                        ? const Color(0xFFFFA726)
                                        : Colors.white.withOpacity(0.85),
                                    fontSize: 11.5,
                                    fontWeight: item.isSunrise
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 8),

                    // Icon row
                    Row(
                      children: displayData
                          .map(
                            (item) => SizedBox(
                              width: colWidth,
                              height: 36,
                              child: Center(child: _weatherIcon(item)),
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 4),

                    // Temperature / label row
                    Row(
                      children: displayData
                          .map(
                            (item) => SizedBox(
                              width: colWidth,
                              height: 28,
                              child: Center(
                                child: item.isSunrise
                                    ? Text(
                                        item.label ?? '',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.75),
                                          fontSize: 10.5,
                                        ),
                                      )
                                    : Text(
                                        '${item.temperature}°',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                              ),
                            ),
                          )
                          .toList(),
                    ),

                    // Trend line — same total width as rows above
                    SizedBox(
                      width: colWidth * displayData.length,
                      height: 24,
                      child: CustomPaint(
                        painter: _TrendLinePainter(
                          data: displayData,
                          colWidth: colWidth,
                        ),
                      ),
                    ),

                    // Precipitation row
                    Row(
                      children: displayData
                          .map(
                            (item) => SizedBox(
                              width: colWidth,
                              height: 20,
                              child: Center(
                                child:
                                    item.isSunrise || item.precipitation == null
                                    ? const SizedBox.shrink()
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.water_drop_rounded,
                                            color: Colors.lightBlueAccent
                                                .withOpacity(0.85),
                                            size: 11,
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            '${item.precipitation}%',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(
                                                0.75,
                                              ),
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _weatherIcon(HourlyWeather item) {
    switch (item.condition) {
      case WeatherCondition.sunny:
        return const Icon(
          Icons.wb_sunny_rounded,
          color: Color(0xFFFDD835),
          size: 28,
        );
      case WeatherCondition.partlyCloudy:
        return const _PartlyCloudyIcon();
      case WeatherCondition.rainy:
        return const _RainyIcon();
      case WeatherCondition.sunrise:
        return const _SunriseIcon();
      case WeatherCondition.cloudy:
        return const Icon(Icons.cloud_rounded, color: Colors.white70, size: 28);
    }
  }
}

class _TrendLinePainter extends CustomPainter {
  final List<HourlyWeather> data;
  final double colWidth;

  _TrendLinePainter({required this.data, required this.colWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final indexed = data
        .asMap()
        .entries
        .where((e) => !e.value.isSunrise && e.value.temperature != null)
        .toList();

    if (indexed.length < 2) return;

    final temps = indexed.map((e) => e.value.temperature!.toDouble()).toList();
    final minTemp = temps.reduce((a, b) => a < b ? a : b);
    final maxTemp = temps.reduce((a, b) => a > b ? a : b);
    final range = (maxTemp - minTemp).clamp(1.0, double.infinity);

    double xOf(int idx) => idx * colWidth + colWidth / 2;
    double yOf(double t) =>
        size.height -
        ((t - minTemp) / range) * (size.height * 0.65) -
        size.height * 0.1;

    final linePaint = Paint()
      ..color = const Color(0xFFFFA726)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    bool first = true;

    for (final entry in indexed) {
      final x = xOf(entry.key);
      final y = yOf(entry.value.temperature!.toDouble());
      if (first) {
        path.moveTo(x, y);
        first = false;
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 2.5, dotPaint);
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ── Custom Icons ──────────────────────────────────────────────────────────────

class _PartlyCloudyIcon extends StatelessWidget {
  const _PartlyCloudyIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 28,
      child: Stack(
        children: const [
          Positioned(
            right: 0,
            bottom: 0,
            child: Icon(Icons.cloud_rounded, color: Colors.white70, size: 24),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Icon(
              Icons.wb_sunny_rounded,
              color: Color(0xFFFDD835),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _SunriseIcon extends StatelessWidget {
  const _SunriseIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 28,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFA726).withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 28,
              height: 1.5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RainyIcon extends StatelessWidget {
  const _RainyIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 28,
      child: Stack(
        children: [
          const Positioned(
            top: 0,
            left: 2,
            child: Icon(Icons.cloud_rounded, color: Colors.white60, size: 20),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (_) => const Padding(
                  padding: EdgeInsets.only(right: 2),
                  child: Icon(
                    Icons.water_drop_rounded,
                    color: Colors.lightBlueAccent,
                    size: 7,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
