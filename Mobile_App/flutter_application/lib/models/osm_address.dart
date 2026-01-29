class OsmAddress {
  final String? city;
  final String? district;

  OsmAddress({this.city, this.district});

  factory OsmAddress.fromJson(Map<String, dynamic> json) {
    final address = json['address'] ?? {};
    return OsmAddress(
      city: address['city'] ?? address['town'] ?? address['state'],
      district:
          address['suburb'] ?? address['county'] ?? address['city_district'],
    );
  }
}
