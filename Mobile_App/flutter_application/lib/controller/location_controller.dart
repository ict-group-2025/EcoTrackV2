import 'package:flutter_application/models/geo_model.dart';
import 'package:geolocator/geolocator.dart';

class LocationController {
  Future<GeoModel> fetchLocation() async {
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
      )
    );
    return GeoModel(latitude: pos.latitude, longitude: pos.longitude);
  }
}
