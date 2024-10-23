class Itineraire {
  int? id;
  String? origine, destination;
  double? startLat;
  double? startLng;
  double? endLat;
  double? endLng;
  String? startingTime;
  String? endingTime;
  String? conveyor;
  String? vehicle;
  int? passengers;
  String? deviceId;
  bool? isActive;
  String? status;
  int? driverPassengers;
  double? ticketPrice;
  String? paymentType;
  String? line;

  Itineraire(
      {this.id,
      this.origine,
      this.destination,
      this.startLat,
      this.conveyor,
      this.endLat,
      this.endLng,
      this.startLng,
      this.startingTime,
      this.endingTime,
      this.vehicle,
      this.passengers,
      this.deviceId,
      this.isActive,
      this.status,
      this.driverPassengers,
      this.ticketPrice,
      this.line,
      this.paymentType});
  factory Itineraire.fromJson(Map<String, dynamic> json) {
    return Itineraire(
        id: json['id'],
        origine: json['origine'],
        destination: json['destination'],
        startLat: json['startLat'],
        conveyor: json['conveyor'],
        endLat: json['endLat'],
        endLng: json['endLng'],
        startLng: json['startLng'],
        startingTime: json['startingTime'],
        endingTime: json['endingTime'],
        vehicle: json['vehicle'],
        passengers: json['passengers'],
        deviceId: json['deviceId'],
        isActive: json['isActive'],
        status: json['status'],
        driverPassengers: json['driverPassengers'],
        ticketPrice: json['ticketPrice'],
        paymentType: json['paymentType'],
        line: json['line']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'origine': origine,
      'destination': destination,
      'startLat': startLat,
      'conveyor': conveyor,
      'endLat': endLat,
      'endLng': endLng,
      'startLng': startLng,
      'startingTime': startingTime,
      'endingTinme': endingTime,
      'vehicle': vehicle,
      'passengers': passengers,
      'deviceId': deviceId,
      'isActive': isActive,
      'status': status,
      'driverPassengers': driverPassengers,
      'ticketPrice': ticketPrice,
      'paymentType': paymentType,
      'line': line
    };
  }

  static Future<List<Itineraire>> itinerairesfromJson(
      List<dynamic> data) async {
    return data.map((element) => Itineraire.fromJson(element)).toList();
  }
}
