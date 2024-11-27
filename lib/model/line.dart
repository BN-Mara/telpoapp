class Line {
  int? id;
  String? name;
  String? description;
  String? region;
  String? paymentType;
  double? ticketPrice;
  String? enterprise;

  Line({
    this.id,
    this.name,
    this.description,
    this.region,
    this.paymentType,
    this.ticketPrice,
    this.enterprise,
  });

  // Manual fromJson method
  factory Line.fromJson(Map<String, dynamic> json) {
    return Line(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      region: "${json['region']}",
      paymentType: json['paymentType'] as String?,
      ticketPrice: (json['ticketPrice'] as num?)?.toDouble(),
      enterprise: "${json['enterprise']}",
    );
  }

  // Manual toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'region': region,
      'paymentType': paymentType,
      'ticketPrice': ticketPrice,
      'enterprise': enterprise,
    };
  }
}
