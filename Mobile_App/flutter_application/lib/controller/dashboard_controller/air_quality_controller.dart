import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../models/air_quality_model.dart';

class AirQualityController {
  Future<AirQualityModel> fetchAirQuality({
    required double lat,
    required double lon,
  }) async {
    final url =
        'http://api.openweathermap.org/data/2.5/air_pollution'
        '?lat=$lat&lon=$lon&appid=76805f1ca0234e4568454f73948dbfdb';

    final res = await http.get(Uri.parse(url));

    if (res.statusCode != 200) {
      throw Exception('Failed to load air quality');
    }

    final json = jsonDecode(res.body);

    log(res.body.toString());
    return AirQualityModel.fromJson(json);
  }
}
