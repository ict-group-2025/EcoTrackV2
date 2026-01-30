import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_application/controller/osm_search_controller.dart';
import 'package:flutter_application/models/osm_search.dart';

class SearchViewModel extends ChangeNotifier {
  final OsmSearchController controller;

  SearchViewModel({required this.controller});

  List<OsmSearch> results = [];
  bool isLoading = false;
  String query = '';
  Timer? _debounce;


 void onQueryChanged(String value) {
    query = value;
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      results = [];
      notifyListeners();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), _search);
  }


 Future<void> _search() async {
    if (query.trim().length < 1) {
      results = [];
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final data = await controller.search(query);
      results = _filterAdministrative(data);
    } catch (e) {
      results = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  List<OsmSearch> _filterAdministrative(List<OsmSearch> list) {
    return list.where((e) {
      final a = e.address;
      return a.containsKey('city_district') ||
          a.containsKey('county') ||
          a.containsKey('suburb') ||
          a.containsKey('city');
    }).toList();
  }

 String formatLocation(OsmSearch r) {
    final a = r.address;

    final countryCode = a['country_code']?.toString().toLowerCase();
    final isVietnam = countryCode == 'vn';

    String? district = a['city_district'] ?? a['county'] ?? a['suburb'];
    String? city = a['city'] ?? a['state'];

    if (district != null && city != null) {
      if (isVietnam) {
        district = _normalizeVietnamese(district);
        city = _normalizeVietnamese(city);
        return '$district, $city';
      } else {
        return _breakLongLocation('$district, $city');
      }
    }

    // fallback cho displayName
    if (isVietnam) {
      return _normalizeVietnamese(r.displayName.split(',').take(2).join(', '));
    }

    return _breakLongLocation(r.displayName.split(',').take(3).join(', '));
  }


String _normalizeVietnamese(String value) {
    return value
        .replaceAll(
          RegExp(r'^(Phường|Xã|Thị trấn|Quận|Huyện)\s+', caseSensitive: false),
          '',
        )
        .replaceAll(RegExp(r'^(Thành phố|TP\.?)\s+', caseSensitive: false), '')
        .replaceAll(RegExp(r'^Tỉnh\s+', caseSensitive: false), '')
        .replaceAll(RegExp(r'\s*,\s*'), ', ')
        .replaceAll(RegExp(r'\s{2,}'), ' ')
        .trim();
  }
String _breakLongLocation(String value) {
    final parts = value.split(',');
    if (parts.length <= 2) return value;

    return '${parts[0].trim()},\n${parts.sublist(1).join(',').trim()}';
  }

}
