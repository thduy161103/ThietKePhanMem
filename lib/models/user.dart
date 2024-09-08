class User {
  final String fullName;
  final String email;
  final String phone;
  final String username;
  final String password;
  final String avatar;
  final String dateOfBirth;
  final String sex;
  final String facebook;
  final String role;
  final String? otp;
  final int? point;

  User({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
    required this.avatar,
    required this.dateOfBirth,
    required this.sex,
    required this.facebook,
    required this.role,
    this.otp,
    this.point,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['fullName'],
      email: json['email'],
      phone: json['phone'],
      username: json['username'],
      password: json['password'],
      avatar: json['avatar'],
      dateOfBirth: json['dateOfBirth'],
      sex: json['sex'],
      facebook: json['facebook'],
      role: json['role'],
      otp: json['otp'],
      point: json['point'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'username': username,
      'password': password,
      'avatar': avatar,
      'dateOfBirth': dateOfBirth,
      'sex': sex,
      'facebook': facebook,
      'role': role,
      'otp': otp,
    };
  }
}