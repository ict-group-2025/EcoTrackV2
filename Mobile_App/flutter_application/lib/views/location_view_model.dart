import 'package:flutter/material.dart';
import 'package:flutter_application/controller/location_controller.dart';
import 'package:flutter_application/controller/osm_controller.dart';
import 'package:flutter_application/models/geo_model.dart';
import 'package:flutter_application/models/osm_address.dart';

class LocationViewModel extends ChangeNotifier {
  final LocationController locationController;
  final OsmController osmController;

  GeoModel? coordinate;
  OsmAddress? address;
  bool isLoading = false;
  String? error;

  LocationViewModel({
    required this.locationController,
    required this.osmController,
  });

  Future<void> loadLocation() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      coordinate = await locationController.fetchLocation();
      address = await osmController.reverseGeocode(coordinate!);

      if (address == null) {
        error = 'Không lấy được địa chỉ';
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

String _normalizeVietnameseLocation(String value) {
    return value
        .replaceAll(RegExp(r'^Phường\s+', caseSensitive: false), '')
        .replaceAll(RegExp(r'^Xã\s+', caseSensitive: false), '')
        .replaceAll(RegExp(r'^Thị trấn\s+', caseSensitive: false), '')
        .replaceAll(RegExp(r'^Quận\s+', caseSensitive: false), '')
        .replaceAll(RegExp(r'^Huyện\s+', caseSensitive: false), '')
        .replaceAll(RegExp(r'^Thành phố\s+', caseSensitive: false), '')
        .trim();
  }

  String get displayLocation {
    if (address == null) return 'Unknown location';

    final parts = <String>[];

    if (address!.district != null) {
      parts.add(_normalizeVietnameseLocation(address!.district!));
    }
    if (address!.city != null) {
      parts.add(_normalizeVietnameseLocation(address!.city!));
    }

    return parts.join(', ');
  }


}
