import 'dart:convert';
import 'dart:developer';

import 'package:flutter_application/models/osm_search.dart';
import 'package:http/http.dart' as http;

class OsmSearchController {
  Future<List<OsmSearch>> search(String query) async {
    if (query.trim().length < 3) return [];

    final url =
        'https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeComponent(query)}'
        '&format=json'
        '&addressdetails=1'
        '&limit=5';

    final response = await http.get(
      Uri.parse(url),
      headers: {'User-Agent': 'FlutterApp/1.0 (longberray88@email.com)'},
    );
     if (response.statusCode != 200) {
      return [];
    }
    log('📦 [OSM SEARCH] Status: ${response.statusCode}');
    log('📦 [OSM SEARCH] Raw body: ${response.body}');

    final List data = jsonDecode(response.body);

    return data.map((e) => OsmSearch.fromJson(e)).toList();
  }

// Future<List<OsmSearch>> autocomplete(String query) async {
//     if (query.trim().isEmpty) return [];

//     final headers = {
//       'User-Agent': 'FlutterApp/1.0 (longberray88@email.com)',
//       'Accept-Language': 'vi',
//     };

//     final vnUrl =
//         'https://nominatim.openstreetmap.org/search'
//         '?q=${Uri.encodeComponent(query)}'
//         '&format=json'
//         '&addressdetails=1'
//         '&limit=10'
//         '&countrycodes=vn';

//     final globalUrl =
//         'https://nominatim.openstreetmap.org/search'
//         '?q=${Uri.encodeComponent(query)}'
//         '&format=json'
//         '&addressdetails=1'
//         '&limit=10';

//     final responses = await Future.wait([
//       http.get(Uri.parse(vnUrl), headers: headers),
//       http.get(Uri.parse(globalUrl), headers: headers),
//     ]);

//     final List vnData = jsonDecode(responses[0].body);
//     final List globalData = jsonDecode(responses[1].body);

//     final Map<String, OsmSearch> merged = {};

//     for (final item in vnData) {
//       final place = OsmSearch.fromJson(item);
//       merged['${place.lat},${place.lon}'] = place;
//     }

//     for (final item in globalData) {
//       final place = OsmSearch.fromJson(item);
//       merged.putIfAbsent('${place.lat},${place.lon}', () => place);
//     }

//     return merged.values.take(10).toList();
//   }


 
}
