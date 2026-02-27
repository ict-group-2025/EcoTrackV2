import 'package:flutter_application/models/data_models.dart';
import 'package:flutter_application/utils/weather_image_mapper.dart';

class ForecastResponse {
  final int cod;
  final int message;
  final int cnt;
  final List<ForecastItem> list;
  final City city;

  ForecastResponse({
    required this.cod,
    required this.message,
    required this.cnt,
    required this.list,
    required this.city,
  });

  factory ForecastResponse.fromJson(Map<String, dynamic> json) {
    return ForecastResponse(
      cod: int.tryParse(json['cod']?.toString() ?? '') ?? 0,
      message: (json['message'] as num?)?.toInt() ?? 0,
      cnt: (json['cnt'] as num?)?.toInt() ?? 0,
      list:
          (json['list'] as List<dynamic>?)
              ?.map((e) => ForecastItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      city: City.fromJson(json['city'] as Map<String, dynamic>),
    );
  }
}

class ForecastItem {
  final int dt;
  final ForecastMain main;
  final List<WeatherShort> weather;
  final Clouds clouds;
  final Wind wind;
  final int visibility;
  final double pop;
  final SysPod sys;
  final String dtTxt;

  ForecastItem({
    required this.dt,
    required this.main,
    required this.weather,
    required this.clouds,
    required this.wind,
    required this.visibility,
    required this.pop,
    required this.sys,
    required this.dtTxt,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      dt: (json['dt'] as num).toInt(),
      main: ForecastMain.fromJson(json['main'] as Map<String, dynamic>),
      weather: (json['weather'] as List)
          .map((e) => WeatherShort.fromJson(e as Map<String, dynamic>))
          .toList(),
      clouds: Clouds.fromJson(json['clouds'] as Map<String, dynamic>),
      wind: Wind.fromJson(json['wind'] as Map<String, dynamic>),
      visibility: (json['visibility'] as num?)?.toInt() ?? 0,
      pop: (json['pop'] as num?)?.toDouble() ?? 0.0,
      sys: SysPod.fromJson(json['sys'] as Map<String, dynamic>),
      dtTxt: json['dt_txt'] as String? ?? '',
    );
  }

  /// Convert to UI-friendly ForecastData
  ForecastData toForecastData() {
    int toC(dynamic k) => (k - 273.15).round();

    // convert dtTxt string into local hour with AM/PM
    String formattedTime() {
      try {
        // parse original UTC string, add 7 hours offset
        var dt = DateTime.parse(dtTxt).toUtc().add(const Duration(hours: 7));
        // convert to local representation if desired
        dt = dt.toLocal();
        int hour = dt.hour;
        final suffix = hour >= 12 ? 'PM' : 'AM';
        int displayHour = hour % 12 == 0 ? 12 : hour % 12;
        return '$displayHour $suffix';
      } catch (_) {
        return dtTxt; // fallback
      }
    }

    final weather0 = weather.isNotEmpty ? weather[0] : null;
    final status = weather0 != null ? weather0.main : '';
    // Determine day/night from icon code (endsWith 'd' or 'n') if available
    final isDay = weather0 != null ? (weather0.icon.endsWith('d')) : true;
    final code = weather0 != null ? weather0.id : 800;
    final icon = WeatherImageMapper.fromCode(code, isDay);

    return ForecastData(
      time: formattedTime(),
      icon: icon,
      temperature: toC(main.temp),
      status: status,
      humidity: main.humidity,
    );
  }
}

class ForecastMain {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;

  ForecastMain({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
  });

  factory ForecastMain.fromJson(Map<String, dynamic> json) {
    return ForecastMain(
      temp: (json['temp'] as num).toDouble(),
      feelsLike: (json['feels_like'] as num).toDouble(),
      tempMin: (json['temp_min'] as num).toDouble(),
      tempMax: (json['temp_max'] as num).toDouble(),
      pressure: (json['pressure'] as num).toInt(),
      humidity: (json['humidity'] as num).toInt(),
    );
  }
}

class WeatherShort {
  final int id;
  final String main;
  final String description;
  final String icon;

  WeatherShort({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherShort.fromJson(Map<String, dynamic> json) {
    return WeatherShort(
      id: (json['id'] as num?)?.toInt() ?? 0,
      main: json['main'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }
}

class Clouds {
  final int all;
  Clouds({required this.all});
  factory Clouds.fromJson(Map<String, dynamic> json) =>
      Clouds(all: (json['all'] as num).toInt());
}

class Wind {
  final double speed;
  final int deg;
  final double? gust;
  Wind({required this.speed, required this.deg, this.gust});
  factory Wind.fromJson(Map<String, dynamic> json) => Wind(
    speed: (json['speed'] as num).toDouble(),
    deg: (json['deg'] as num?)?.toInt() ?? 0,
    gust: (json['gust'] as num?)?.toDouble(),
  );
}

class SysPod {
  final String pod;
  SysPod({required this.pod});
  factory SysPod.fromJson(Map<String, dynamic> json) =>
      SysPod(pod: json['pod'] as String? ?? '');
}

class City {
  final int id;
  final String name;
  final Coord coord;
  final String country;
  final int population;
  final int timezone;
  final int sunrise;
  final int sunset;

  City({
    required this.id,
    required this.name,
    required this.coord,
    required this.country,
    required this.population,
    required this.timezone,
    required this.sunrise,
    required this.sunset,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      coord: Coord.fromJson(json['coord'] as Map<String, dynamic>),
      country: json['country'] as String? ?? '',
      population: (json['population'] as num?)?.toInt() ?? 0,
      timezone: (json['timezone'] as num?)?.toInt() ?? 0,
      sunrise: (json['sunrise'] as num?)?.toInt() ?? 0,
      sunset: (json['sunset'] as num?)?.toInt() ?? 0,
    );
  }
}

class Coord {
  final double lat;
  final double lon;
  Coord({required this.lat, required this.lon});
  factory Coord.fromJson(Map<String, dynamic> json) => Coord(
    lat: (json['lat'] as num).toDouble(),
    lon: (json['lon'] as num).toDouble(),
  );
}
