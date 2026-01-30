// ignore_for_file: public_member_api_docs, sort_constructors_first
class OsmSearch {
  final String displayName;
  final double lat;
  final double lon;
  final Map<String, dynamic> address;

  OsmSearch({
    required this.displayName,
    required this.lat,
    required this.lon,
    required this.address,
  });

  factory OsmSearch.fromJson(Map<String, dynamic> json) {
    return OsmSearch(
      displayName: json['display_name'],
      lat: double.parse(json['lat']),
      lon: double.parse(json['lon']),
      address: json['address'] ?? {},
    );
  }
}
