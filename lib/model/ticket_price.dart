class TicketPrice {
  int? id;
  double? price;
  String? description;
  TicketPrice({this.id, this.price, this.description});

  factory TicketPrice.fromJson(Map<String, dynamic> json) {
    return TicketPrice(
        id: json['id'], price: json['price'], description: json['description']);
  }
  static Future<List<TicketPrice>> ticketsfromJson(List<dynamic> data) async {
    return data.map((element) => TicketPrice.fromJson(element)).toList();
  }
}
