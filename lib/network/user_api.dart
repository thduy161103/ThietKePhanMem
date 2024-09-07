import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../config/environment.dart';

class UserApi {
  static String baseUrl = '${Environment.baseUrl}/users'; // Adjust this URL as needed

  static Future<User> fetchUserData(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';
    print('token: $token');
    final url = Uri.parse('$baseUrl/$userId');
    print('url: $url');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print('data: $data');
      return User.fromJson(data);
    } else {
      print('response: $response');
      throw Exception('Failed to load user data');
    }
  }
}