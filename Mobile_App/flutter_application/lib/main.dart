import 'package:flutter/material.dart';
import 'package:flutter_application/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Thêm thư viện này
import 'package:flutter_application/controller/auth_controller.dart';

// Các import hiện tại của bạn
import 'package:flutter_application/controller/dashboard_controller/air_quality_controller.dart';
import 'package:flutter_application/controller/location_controller.dart';
import 'package:flutter_application/controller/osm_controller.dart';
import 'package:flutter_application/controller/osm_search_controller.dart';
import 'package:flutter_application/controller/dashboard_controller/weather_controller.dart';
import 'package:flutter_application/controller/dashboard_controller/forecast_controller.dart';
import 'package:flutter_application/views/air_quality_view_model.dart';
import 'package:flutter_application/views/location_view_model.dart';
import 'package:flutter_application/views/search_view_model.dart';
import 'package:flutter_application/views/weather_view_model.dart';
import 'package:flutter_application/views/forecast_view_model.dart';

import 'screens/home_screen.dart';
import 'services/app_state.dart';
// import 'screens/login_screen.dart'; // Nhớ import màn hình Login của bạn vào đây

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthController()),
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(
          create: (_) => LocationViewModel(
            locationController: LocationController(),
            osmController: OsmController(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchViewModel(controller: OsmSearchController()),
        ),
        ChangeNotifierProxyProvider<LocationViewModel, WeatherViewModel>(
          create: (context) => WeatherViewModel(
            WeatherController(),
            context.read<LocationViewModel>(),
          ),
          update: (_, locationVM, weatherVM) => weatherVM!,
        ),
        ChangeNotifierProxyProvider<LocationViewModel, AirQualityViewModel>(
          create: (context) => AirQualityViewModel(
            AirQualityController(),
            context.read<LocationViewModel>(),
          ),
          update: (_, locationVM, airQualityVM) => airQualityVM!,
        ),
        ChangeNotifierProxyProvider<LocationViewModel, ForecastViewModel>(
          create: (context) => ForecastViewModel(
            ForecastController(),
            context.read<LocationViewModel>(),
          ),
          update: (_, locationVM, forecastVM) => forecastVM!,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return MaterialApp(
          title: 'Air Quality Monitor',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: const Color(0xFFF5F5F5),
            useMaterial3: true,
            fontFamily: 'SF Pro Display',
          ),
          home: authController.isAuthenticated ? const HomeScreen() : const LoginScreen(),
        );
      },
    );
  }
}
