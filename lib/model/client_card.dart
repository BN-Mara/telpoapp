class ClientCard {
  int? id;
  String? uid;
  double? balance;
  String? updatedAt;
  bool? isActive;
  String? subscriptionFromDate;
  String? subscriptionEndDate;
  bool? isSubscribed;
  ClientCard(
      {this.id,
      this.uid,
      this.balance,
      this.updatedAt,
      this.isActive,
      this.subscriptionFromDate,
      this.subscriptionEndDate,
      this.isSubscribed});

  factory ClientCard.fromJson(Map<String, dynamic> json) {
    return ClientCard(
        id: json['id'],
        uid: json['uid'],
        balance: json['balance'],
        updatedAt: json['updatedAt'],
        isActive: json['isActive'],
        subscriptionFromDate: json['subscriptionFromDate'],
        subscriptionEndDate: json['subscriptionEndDate'],
        isSubscribed: json['isSubscribed']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "uid": uid,
      "balance": balance,
      "updatedAt": updatedAt,
      "isActive": isActive,
      'subscriptionFromDate': subscriptionFromDate,
      'subscriptionEndDate': subscriptionEndDate,
    };
  }

  static Future<List<ClientCard>> ClientCardsfromJson(
      List<dynamic> data) async {
    return data.map((element) => ClientCard.fromJson(element)).toList();
  }
}
