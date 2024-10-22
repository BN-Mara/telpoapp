class NfcCard {
  int? id;
  String? uid;
  String? cardHolder;
  String? phoneNumber;
  double? balance;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  NfcCard({
    this.id,
    this.uid,
    this.cardHolder,
    this.balance,
    this.isActive,
    this.createdAt,
    this.phoneNumber,
    this.updatedAt,
  });
  factory NfcCard.fromJson(Map<String, dynamic> json) {
    return NfcCard(
      id: json['id'],
      uid: json['uid'],
      cardHolder: json['cardHolder'],
      balance: json['balance'],
      isActive: json['isActive'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'cardHolder': cardHolder,
      'balance': balance,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
