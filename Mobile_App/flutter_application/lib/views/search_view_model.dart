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
    if (query.trim().length < 2) {
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
      return a.containsKey('suburb') ||
          a.containsKey('village') ||
          a.containsKey('neighbourhood') ||
          a.containsKey('city_district') ||
          a.containsKey('county') ||
          a.containsKey('city');
      //  || a.containsKey('state') ||
      // a.containsKey('region');
    }).toList();
  }

  String formatLocation(OsmSearch r) {
    final a = r.address;

    // Ưu tiên cấp thấp nhất trước
    final candidates = [
      a['suburb'], // phường / khu phố
      a['village'], // xã
      a['neighbourhood'],
      a['city_district'], // quận
      a['county'],
      a['city'],
    ];

    for (final c in candidates) {
      if (c != null && c.toString().trim().isNotEmpty) {
        return _normalizeVietnameseLocation(c.toString());
      }
    }

    // fallback
    return r.displayName.split(',').first;
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
}
