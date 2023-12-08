class TicketPrice {
  int? id;
  String? region;
  num? price;
  String? description;
  TicketPrice({this.id, this.price, this.description, this.region});

  factory TicketPrice.fromJson(Map<String, dynamic> json) {
    return TicketPrice(
        id: json['id'],
        price: json['price'],
        description: json['description'],
        region: json['region']);
  }
  static Future<List<TicketPrice>> ticketsfromJson(List<dynamic> data) async {
    return data.map((element) => TicketPrice.fromJson(element)).toList();
  }
}
