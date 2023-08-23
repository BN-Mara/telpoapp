class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? token;
  String? role;
  String? status;
  String? refresh_token;

  

  static User empty() => User.fromJson(null, {});

  User.fromJson(String? id, Map<String, dynamic> data) {
    this.id = id;
    if (data.containsKey('id') ) {
      this.id = "${data['id']}";
    }
    if (data.containsKey('sub') ) {
      this.id = "${data['sub']}";
    }
    if (data.containsKey('name')) {
      name = data['name'];
    }
    if (data.containsKey('role')) {
      role = data['role'];
    }
    
    if (data.containsKey('status')) {
      status = data['status'];
    }
    if (data.containsKey('access_token')) {
      token = data['access_token'];
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
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "role":role,
      "access_token": token,
      "status": status,
      "refresh_token":refresh_token
    };
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, phone: $phone, status: $status, token: $token, refresh_token: $refresh_token}';
  }
}
