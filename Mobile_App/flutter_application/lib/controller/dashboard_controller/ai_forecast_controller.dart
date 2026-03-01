import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../models/ai_forecast_model.dart';

class AIForecastController {
  static const String baseUrl = 'https://nonfecund-unvenerative-judi.ngrok-free.dev/api/ai/forecast';

  Future<AIForecastResponse> fetchAIForecast(String city) async {
    final url = '$baseUrl/$city';

    final res = await http.get(Uri.parse(url));

    if (res.statusCode != 200) {
      throw Exception('Failed to load AI forecast: ${res.statusCode}');
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;

    log('AI Forecast Response: ${res.body.toString()}');
    return AIForecastResponse.fromJson(json);
  }
}
