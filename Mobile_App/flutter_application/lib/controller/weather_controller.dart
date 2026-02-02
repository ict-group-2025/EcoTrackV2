import 'dart:convert';
import 'dart:developer';
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

    log(res.body.toString());
    return WeatherModel.fromJson(json);
  }
}
