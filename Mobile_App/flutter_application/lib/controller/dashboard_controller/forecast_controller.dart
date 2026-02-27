import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../models/forecast_model.dart';

class ForecastController {
  Future<ForecastResponse> fetchForecast({
    required double lat,
    required double lon,
  }) async {
    final url =
        'https://api.openweathermap.org/data/2.5/forecast'
        '?lat=$lat&lon=$lon&appid=76805f1ca0234e4568454f73948dbfdb';

    final res = await http.get(Uri.parse(url));

    if (res.statusCode != 200) {
      throw Exception('Failed to load forecast');
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;

    log(res.body.toString());
    return ForecastResponse.fromJson(json);
  }
}
