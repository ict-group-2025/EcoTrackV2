import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  Future<void> login(String username, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final request = LoginRequest(username: username, password: password);
      final response = await AuthService.login(request);

      print('AuthController login - response.success: ${response.success}');
      print('AuthController login - response.message: ${response.message}');
      print('AuthController login - response.user: ${response.user}');

      if (response.success && response.user != null) {
        _user = response.user;
        await _saveUserToPrefs(_user!);
        print('Login successful, user saved: $_user');
        notifyListeners();
      } else {
        _errorMessage = response.message ?? 'Login failed';
        print('Login failed: $_errorMessage');
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Login error: ${e.toString()}';
      print('Login exception: $_errorMessage');
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register(String username, String fullName, String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final request = RegisterRequest(
        username: username,
        fullName: fullName,
        email: email,
        password: password,
      );
      final response = await AuthService.register(request);

      if (response.success && response.user != null) {
        _user = response.user;
        await _saveUserToPrefs(_user!);
        notifyListeners();
      } else {
        _errorMessage = response.message ?? 'Registration failed';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Registration error: ${e.toString()}';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadUserProfile() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await AuthService.getCurrentUser();
      
      print('AuthController loadUserProfile - response.success: ${response.success}');
      print('AuthController loadUserProfile - response.message: ${response.message}');
      print('AuthController loadUserProfile - response.user: ${response.user}');

      if (response.success && response.user != null) {
        _user = response.user;
        await _saveUserToPrefs(_user!);
        print('Profile loaded successfully: $_user');
        notifyListeners();
      } else {
        _errorMessage = response.message ?? 'Failed to load profile';
        print('Profile load failed: $_errorMessage');
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Profile load error: ${e.toString()}';
      print('Profile load exception: $_errorMessage');
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);

    try {
      if (_user?.token != null) {
        await AuthService.logout(_user!.token!);
      }
    } catch (e) {
      print('Logout error: ${e.toString()}');
    }

    _user = null;
    await _clearUserFromPrefs();
    notifyListeners();
    _setLoading(false);
  }

  Future<void> checkAuthStatus() async {
    _setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');

      if (userJson != null) {
        final userData = Map<String, dynamic>.from(
          // ignore: use_build_context_synchronously
          // This is a simple approach - in production you'd want proper JSON parsing
          // For now, we'll just store basic user info
          {
            'id': prefs.getString('user_id') ?? '',
            'username': prefs.getString('username') ?? '',
            'fullName': prefs.getString('fullName') ?? '',
            'email': prefs.getString('email') ?? '',
            'token': prefs.getString('token'),
          }
        );
        
        _user = User.fromJson(userData);
      }
    } catch (e) {
      print('Auth check error: ${e.toString()}');
    } finally {
      _isLoading = false;
      // Defer notifyListeners to avoid calling during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void clearError() {
    _errorMessage = null;
    // Defer notifyListeners to avoid calling during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    // Defer notifyListeners to avoid calling during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> _saveUserToPrefs(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.id);
    await prefs.setString('username', user.username);
    await prefs.setString('fullName', user.fullName);
    await prefs.setString('email', user.email);
    if (user.token != null) {
      await prefs.setString('token', user.token!);
    }
  }

  Future<void> _clearUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('username');
    await prefs.remove('fullName');
    await prefs.remove('email');
    await prefs.remove('token');
    await prefs.remove('user');
  }
}
