class ClientCard {
  int? id;
  String? uid;
  double? balance;
  String? updatedAt;
  bool? isActive;
  ClientCard({this.id, this.uid, this.balance, this.updatedAt, this.isActive});

  factory ClientCard.fromJson(Map<String, dynamic> json) {
    return ClientCard(
        id: json['id'],
        uid: json['uid'],
        balance: json['balance'],
        updatedAt: json['updatedAt'],
        isActive: json['isActive']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "uid": uid,
      "balance": balance,
      "updatedAt": updatedAt,
      "isActive": isActive
    };
  }

  static Future<List<ClientCard>> ClientCardsfromJson(
      List<dynamic> data) async {
    return data.map((element) => ClientCard.fromJson(element)).toList();
  }
}
