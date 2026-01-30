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
}
