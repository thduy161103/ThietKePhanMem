import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserApi {
  static const String baseUrl = 'http://macbookair:8080/users/'; // Adjust this URL as needed

  static Future<User> fetchUserData(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    final url = Uri.parse('$baseUrl/$userId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to load user data');
    }
  }
}