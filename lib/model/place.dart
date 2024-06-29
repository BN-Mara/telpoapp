class Place {
  String? region;
  String? name;
  double? latitude;
  double? longitude;
  Place({this.name, this.latitude, this.longitude, this.region});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
        region: "${json["region"]}".replaceAll("/api/regions/", ""),
        name: json['name'],
        latitude: json['latitude'],
        longitude: json['longitude']);
  }

  static Future<List<Place>> placesfromJson(List<dynamic> data) async {
    return data.map((element) => Place.fromJson(element)).toList();
  }

  bool operator ==(o) => o is Place && o.name == name;
  int get hashCode => name.hashCode;
}
