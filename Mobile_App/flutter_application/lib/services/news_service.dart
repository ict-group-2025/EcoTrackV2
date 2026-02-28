import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsService {
  static const String baseUrl = 'https://nonfecund-unvenerative-judi.ngrok-free.dev';

  static Future<NewsResponse> getNews({
    String category = 'health',
    int page = 0,
    int size = 10,
  }) async {
    try {
      print('Fetching news - category: $category, page: $page, size: $size');
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/news?category=$category&page=$page&size=$size'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('News response status: ${response.statusCode}');
      print('News response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('News parsed response: $responseData');
        return NewsResponse.fromJson(responseData);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        print('News error response: $errorData');
        throw Exception(errorData['message'] ?? 'Failed to load news');
      }
    } catch (e) {
      print('News service exception: $e');
      throw Exception('Network error: ${e.toString()}');
    }
  }

  static Future<List<NewsArticle>> getNewsByCategory(String category, {int page = 0, int size = 10}) async {
    try {
      final response = await getNews(category: category, page: page, size: size);
      return response.content;
    } catch (e) {
      print('Error getting news by category: $e');
      return [];
    }
  }
}
