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
  bool  _isManual = false;
  String? _manualDisplayLocation;
  String? _lastDisplayLocation;




  LocationViewModel({
    required this.locationController,
    required this.osmController,
  });

bool get isManualLocation => _isManual;



Future<void> useCurrentLocation() async {
    _isManual = false;
    _manualDisplayLocation = null;

    await loadLocation();
  }

Future<void> loadLocation() async {
    if (isLoading) return;
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      final newCoordinate = await locationController.fetchLocation();
      final newAddress = await osmController.reverseGeocode(newCoordinate);
      if (newAddress == null) {
        error = 'Cannot get address';
        return;
      }

      final parts = <String>[];

      if (newAddress.district != null) {
        parts.add(_normalizeVietnameseLocation(newAddress.district!));
      }
      if (newAddress.city != null) {
        parts.add(_normalizeVietnameseLocation(newAddress.city!));
      }

      final newDisplayLocation = parts.join(', ');

      if (newDisplayLocation == _lastDisplayLocation) {
        return;
      }

      coordinate = newCoordinate;
      address = newAddress;
      _lastDisplayLocation = newDisplayLocation;
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
    if (_isManual && _manualDisplayLocation != null) {
      return _manualDisplayLocation!;
    }

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
void setManualLocation({
    required double lat,
    required double lon,
    required String displayName,
  }) {
    if (_manualDisplayLocation == displayName) return;

    _isManual = true;
    coordinate = GeoModel(latitude: lat, longitude: lon);
    _manualDisplayLocation = displayName;

    notifyListeners();
  }




}
