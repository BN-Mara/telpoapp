class Stop {
  int? id;
  double? lat;
  double? lon;
  String? line;

  Stop({this.id, this.lat, this.lon, this.line});

  // Factory method to create a Stop instance from a JSON object
  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      id: json['id'] as int?,
      lat: json['lat'] as double?,
      lon: json['lon'] as double?,
      line: "${json['line']}",
    );
  }

  // Method to convert a Stop instance into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lat': lat,
      'lon': lon,
      'line': line,
    };
  }

  static Future<List<Stop>> stopsfromJson(List<dynamic> data) async {
    return data.map((element) => Stop.fromJson(element)).toList();
  }
}
