class Vehicle {
  int? id;
  String? region;
  String? deviceID;
  double? currentLat;
  double? currentLng;
  String? matricule;
  String? name;
  Vehicle(
      {this.id,
      this.name,
      this.matricule,
      this.deviceID,
      this.region,
      this.currentLat,
      this.currentLng});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
        id: json['id'],
        name: json['name'],
        matricule: json['matricule'],
        currentLat: json['currentLat'],
        currentLng: json['currentLng'],
        region: json.containsKey("region")
            ? "${json['region']}".replaceAll("/api/regions/", "")
            : "",
        deviceID: json['deviceID']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "matricule": matricule,
      "currentLat": currentLat,
      "currentLng": currentLng,
      "region": region,
      "deviceID": deviceID
    };
  }

  static Future<List<Vehicle>> vehiclesfromJson(List<dynamic> data) async {
    return data.map((element) => Vehicle.fromJson(element)).toList();
  }
}
