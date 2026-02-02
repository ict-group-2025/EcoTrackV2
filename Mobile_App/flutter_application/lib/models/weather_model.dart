class WeatherModel {
  // Location
  final String city;
  final String country;

  // Temperature (INT)
  final int temp;
  final int feelsLike;
  final int highTemp;
  final int lowTemp;
  final int humidity;

  // Weather condition
  final String condition;
  final String description;
  final String icon;
  final int conditionCode;
  final bool isDay;

  // Wind & visibility
  final double windSpeed;
  final int visibility;

  // Sun
  final DateTime sunrise;
  final DateTime sunset;

  WeatherModel({
    required this.city,
    required this.country,
    required this.temp,
    required this.feelsLike,
    required this.highTemp,
    required this.lowTemp,
    required this.humidity,
    required this.condition,
    required this.description,
    required this.icon,
    required this.conditionCode,
    required this.isDay,
    required this.windSpeed,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final main = json['main'];
    final sys = json['sys'];
    final wind = json['wind'];

    int toC(dynamic k) => (k - 273.15).round();

    return WeatherModel(
      city: json['name'],
      country: sys['country'],

      temp: toC(main['temp']),
      feelsLike: toC(main['feels_like']),
      highTemp: toC(main['temp_max']),
      lowTemp: toC(main['temp_min']),
      humidity: main['humidity'],

      condition: weather['main'],
      description: weather['description'],
      icon: weather['icon'],
      conditionCode: weather['id'],
      isDay: (weather['icon'] as String).endsWith('d'),

      windSpeed: (wind['speed'] as num).toDouble(),
      visibility: json['visibility'],

      sunrise: DateTime.fromMillisecondsSinceEpoch(sys['sunrise'] * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(sys['sunset'] * 1000),
    );
  }
}
