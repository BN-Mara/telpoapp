class User {
  String? id;
  String? fullname;
  String? email;
  String? phone;
  String? token;
  List<String>? roles;
  String? address;
  String? refresh_token;
  bool? isActive;
  double? balance;

  static User empty() => User.fromJson(null, {});

  User.fromJson(String? id, Map<String, dynamic> data) {
    this.id = id;
    if (data.containsKey('id')) {
      this.id = "${data['id']}";
    }
    if (data.containsKey('sub')) {
      this.id = "${data['sub']}";
    }
    if (data.containsKey('fullname')) {
      fullname = data['fullname'];
    }
    if (data.containsKey('roles')) {
      roles = List<String>.from(data['roles']);
    }

    if (data.containsKey('isActive')) {
      isActive = data['isActive'];
    }
    if (data.containsKey('access_token')) {
      token = data['token'];
    }
    if (data.containsKey('refresh_token')) {
      refresh_token = data['refresh_token'];
    }
    if (data.containsKey('email')) {
      email = data['email'];
    }
    if (data.containsKey('phone')) {
      phone = data['phone'];
    }
    if (data.containsKey('balance')) {
      if (data['balance'] != null) {
        balance = data['balance'].toDouble();
      }
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "fullname": fullname,
      //"email": email,
      "phone": phone,
      "roles": roles,
      "access_token": token,
      "isActive": isActive,
      "refresh_token": refresh_token,
      "balance": balance
    };
  }

  @override
  String toString() {
    return 'User{id: $id, name: $fullname, phone: $phone, isActive: $isActive, refresh_token: $refresh_token}';
  }
}
