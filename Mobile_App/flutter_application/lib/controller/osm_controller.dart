import 'dart:convert';
import 'package:flutter_application/models/geo_model.dart';
import 'package:flutter_application/models/osm_address.dart';
import 'package:http/http.dart' as http;

class OsmController {
  Future<OsmAddress?> reverseGeocode(GeoModel position) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse'
        '?lat=${position.latitude}'
        '&lon=${position.longitude}'
        '&format=json'
        '&addressdetails=1';

    final response = await http.get(
      Uri.parse(url),
      headers: {'User-Agent': 'FlutterApp/1.0 (longberray88@email.com)'},
    );

    if (response.statusCode != 200) return null;

    final json = jsonDecode(response.body);


    return OsmAddress.fromJson(json);
  }
}
