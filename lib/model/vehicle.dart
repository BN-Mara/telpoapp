class Vehicle {
  int? id;
  String? line;
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
      this.line,
      this.currentLat,
      this.currentLng});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
        id: json['id'],
        name: json['name'],
        matricule: json['matricule'],
        currentLat: json['currentLat'],
        currentLng: json['currentLng'],
        line: json.containsKey("line")
            ? "${json['line']}".replaceAll("/api/lines/", "")
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
      "line": line,
      "deviceID": deviceID
    };
  }

  static Future<List<Vehicle>> vehiclesfromJson(List<dynamic> data) async {
    return data.map((element) => Vehicle.fromJson(element)).toList();
  }
}
