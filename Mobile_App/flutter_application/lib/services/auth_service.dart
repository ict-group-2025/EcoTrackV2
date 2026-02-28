import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = 'https://nonfecund-unvenerative-judi.ngrok-free.dev';
  
  static Future<AuthResponse> login(LoginRequest request) async {
    try {
      print('Login request: ${request.toJson()}');
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Parsed response: $responseData');
        
        // API returns user object directly, not wrapped in success/user structure
        if (responseData.containsKey('token') || responseData.containsKey('id')) {
          return AuthResponse(
            success: true,
            user: User.fromJson(responseData),
          );
        } else {
          // Fallback to original structure if API changes
          return AuthResponse.fromJson(responseData);
        }
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        print('Error response: $errorData');
        return AuthResponse(
          success: false,
          message: errorData['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      print('Login exception: $e');
      return AuthResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  static Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        // API returns user object directly, not wrapped in success/user structure
        if (responseData.containsKey('token') || responseData.containsKey('id')) {
          return AuthResponse(
            success: true,
            user: User.fromJson(responseData),
          );
        } else {
          // Fallback to original structure if API changes
          return AuthResponse.fromJson(responseData);
        }
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        return AuthResponse(
          success: false,
          message: errorData['message'] ?? 'Registration failed',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  static Future<AuthResponse> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return AuthResponse.fromJson(responseData);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        return AuthResponse(
          success: false,
          message: errorData['message'] ?? 'Logout failed',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }
}
