class User {
  final String username;
  final String password;
  final String email;
  final String phone;

  User({
    required this.username,
    required this.password,
    required this.email,
    required this.phone,
  });

  User.fromJson(Map<String, dynamic> json):
        username = json['username'],
        password = json['password'],
        email = json['email'],
        phone = json['phone'];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}