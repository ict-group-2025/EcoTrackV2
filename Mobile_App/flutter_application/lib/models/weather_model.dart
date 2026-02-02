class WeatherModel {
  final int temperature;
  final int highTemp;
  final int lowTemp;
  final String condition;
  final String icon;

  final int conditionCode; 
  final bool isDay; 

  WeatherModel({
    required this.temperature,
    required this.highTemp,
    required this.lowTemp,
    required this.condition,
    required this.icon,
    required this.conditionCode,
    required this.isDay,

  });

  
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];

    return WeatherModel(
      temperature: json['main']['temp'].round(),
      highTemp: json['main']['temp_max'].round(),
      lowTemp: json['main']['temp_min'].round(),
      condition: weather['main'],
      icon: weather['icon'],
      conditionCode: weather['id'],
      isDay: (weather['icon'] as String).endsWith('d'),
    );
  }

  

}
