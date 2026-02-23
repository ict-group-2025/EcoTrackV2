import 'package:flutter_application/models/weather_model.dart';

class WeatherImageMapper {
  static String fromModel(WeatherModel m) {
    final code = m.conditionCode;
    final isDay = m.isDay;

    if (code >= 200 && code < 300) {
      return isDay
          ? 'assets/images/thunderstorm_day.png'
          : 'assets/images/thunderstorm_night.png';
    }

    if (code >= 300 && code < 600) {
      return isDay
          ? 'assets/images/rain_day.png'
          : 'assets/images/rain_night.png';
    }

    if (code >= 600 && code < 700) {
      return 'assets/images/snows.png';
    }

   if (code == 800) {
      return isDay
          ? 'assets/images/clear_sky_day.png'
          : 'assets/images/clear_sky_night.png';
    }

    if (code == 801 || code == 802) {
      return isDay
          ? 'assets/images/few_clouds_day.png'
          : 'assets/images/few_clouds_night.png';
    }

    if (code == 803 || code == 804) {
      return isDay
          ? 'assets/images/clouds.png'
          : 'assets/images/clouds.png';
    }


    return isDay
        ? 'assets/images/scattered_clouds_day.png'
        : 'assets/images/scattered_clouds_night.png';
  }
}
