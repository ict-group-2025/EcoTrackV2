import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherController {


  Future<WeatherModel> fetchWeather({
    required double lat,
    required double lon,
  }) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather'
        '?lat=$lat&lon=$lon&appid=76805f1ca0234e4568454f73948dbfdb';

    final res = await http.get(Uri.parse(url));

    if (res.statusCode != 200) {
      throw Exception('Failed to load weather');
    }

    final json = jsonDecode(res.body);

    final weather = json['weather'][0];
    final main = json['main'];

    return WeatherModel(
      temperature: (main['temp'] - 273.15).round(),
      highTemp: (main['temp_max'] - 273.15).round(),
      lowTemp: (main['temp_min'] - 273.15).round(),
      condition: weather['main'],
      icon: weather['icon'],
      conditionCode: weather['id'],
      isDay: weather['icon'].endsWith('d'),
    );
  }
}
