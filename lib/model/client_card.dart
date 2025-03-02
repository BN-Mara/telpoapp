import 'package:intl/intl.dart';

class ClientCard {
  int? id;
  String? uid;
  double? balance;
  String? updatedAt;
  bool? isActive;
  String? subscriptionFromDate;
  String? subscriptionEndDate;
  bool? isSubscribed;
  List<String>? liness;

  ClientCard(
      {this.id,
      this.uid,
      this.balance,
      this.updatedAt,
      this.isActive,
      this.subscriptionFromDate,
      this.subscriptionEndDate,
      this.isSubscribed,
      this.liness});

  factory ClientCard.fromJson(Map<String, dynamic> json) {
    return ClientCard(
        id: json['id'],
        uid: json['uid'],
        balance: json['balance'],
        updatedAt: json['updatedAt'],
        isActive: json['isActive'],
        subscriptionFromDate: json['subscriptionFromDate'],
        subscriptionEndDate: json['subscriptionEndDate'],
        isSubscribed: json['isSubscribed'] ?? false,
        liness: List<String>.from(json['liness']) ?? []);
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

  bool isSubscriptionValid() {
    if (subscriptionFromDate == null || subscriptionEndDate == null) {
      return false;
    }

    try {
      DateTime now = DateTime.now();
      DateTime fromDate = DateFormat('yyyy-MM-dd').parse(subscriptionFromDate!);
      DateTime endDate = DateFormat('yyyy-MM-dd').parse(subscriptionEndDate!);

      return now.isAfter(fromDate) &&
          now.isBefore(endDate.add(Duration(days: 1)));
    } catch (e) {
      print('Date parsing error: $e');
      return false;
    }
  }

  static Future<List<ClientCard>> ClientCardsfromJson(
      List<dynamic> data) async {
    return data.map((element) => ClientCard.fromJson(element)).toList();
  }
}
