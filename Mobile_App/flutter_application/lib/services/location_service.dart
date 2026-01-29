import 'dart:developer';
import 'package:geolocator/geolocator.dart';

class LocationService {
  double? longitude;
  double? latitude;
  /// Fetch the device's current GPS position and store a simple lat,lon string.
  Future<void> fetchLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
         log('Location services disabled');
        return ;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log('Permission denied');
          return ;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        log( 'Permission denied permanently');
        return ;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        ),
      );
      longitude = pos.longitude;
      latitude = pos.latitude;
      // '${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}';
    } catch (e) {
      return log('Location error $e');
    }
  }
}
