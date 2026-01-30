import 'package:flutter/material.dart';
import 'package:flutter_application/controller/location_controller.dart';
import 'package:flutter_application/controller/osm_controller.dart';
import 'package:flutter_application/controller/osm_search_controller.dart';
import 'package:flutter_application/views/location_view_model.dart';
import 'package:flutter_application/views/search_view_model.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/app_state.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
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
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Air Quality Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      home: const HomeScreen(),
    );
  }
}
