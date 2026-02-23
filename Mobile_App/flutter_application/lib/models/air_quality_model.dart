class AirQualityModel {
  final Coord coord;
  final List<AirQualityItem> list;

  AirQualityModel({required this.coord, required this.list});

  factory AirQualityModel.fromJson(Map<String, dynamic> json) {
    return AirQualityModel(
      coord: Coord.fromJson(json['coord']),
      list: (json['list'] as List)
          .map((e) => AirQualityItem.fromJson(e))
          .toList(),
    );
  }
}

class Coord {
  final double lon;
  final double lat;

  Coord({required this.lon, required this.lat});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lon: (json['lon'] as num).toDouble(),
      lat: (json['lat'] as num).toDouble(),
    );
  }
}

class AirQualityItem {
  final int aqi;
  final AirComponents components;
  final int dt;

  AirQualityItem({
    required this.aqi,
    required this.components,
    required this.dt,
  });

  factory AirQualityItem.fromJson(Map<String, dynamic> json) {
    return AirQualityItem(
      aqi: json['main']['aqi'],
      components: AirComponents.fromJson(json['components']),
      dt: json['dt'],
    );
  }
}

class AirComponents {
  final double co;
  final double no;
  final double no2;
  final double o3;
  final double so2;
  final double pm25;
  final double pm10;
  final double nh3;

  AirComponents({
    required this.co,
    required this.no,
    required this.no2,
    required this.o3,
    required this.so2,
    required this.pm25,
    required this.pm10,
    required this.nh3,
  });

  factory AirComponents.fromJson(Map<String, dynamic> json) {
    return AirComponents(
      co: (json['co'] as num).toDouble(),
      no: (json['no'] as num).toDouble(),
      no2: (json['no2'] as num).toDouble(),
      o3: (json['o3'] as num).toDouble(),
      so2: (json['so2'] as num).toDouble(),
      pm25: (json['pm2_5'] as num).toDouble(),
      pm10: (json['pm10'] as num).toDouble(),
      nh3: (json['nh3'] as num).toDouble(),
    );
  }
}
extension AQICalculation on AirComponents {
  int calculatePM25AQI() {
    double c = pm25;

    List<Map<String, double>> breakpoints = [
      {'cLow': 0.0, 'cHigh': 12.0, 'iLow': 0, 'iHigh': 50},
      {'cLow': 12.1, 'cHigh': 35.4, 'iLow': 51, 'iHigh': 100},
      {'cLow': 35.5, 'cHigh': 55.4, 'iLow': 101, 'iHigh': 150},
      {'cLow': 55.5, 'cHigh': 150.4, 'iLow': 151, 'iHigh': 200},
      {'cLow': 150.5, 'cHigh': 250.4, 'iLow': 201, 'iHigh': 300},
      {'cLow': 250.5, 'cHigh': 500.4, 'iLow': 301, 'iHigh': 500},
    ];

    for (var bp in breakpoints) {
      if (c >= bp['cLow']! && c <= bp['cHigh']!) {
        return (((bp['iHigh']! - bp['iLow']!) / (bp['cHigh']! - bp['cLow']!)) *
                    (c - bp['cLow']!) +
                bp['iLow']!)
            .round();
      }
    }

    return 0;
  }
}
