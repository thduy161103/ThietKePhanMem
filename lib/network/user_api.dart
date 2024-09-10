import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:developer' as developer;
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

  static Future<String> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null || token.isEmpty) {
      throw Exception('No access token found');
    }

    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      developer.log('Decoded token: $decodedToken');

      String userId = decodedToken['id'] as String;
      developer.log('User ID: $userId');

      return userId;
    } catch (e) {
      developer.log('Error decoding token: $e');
      throw Exception('Failed to get user ID from token');
    }
  }

  static Future<String> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken') ?? '';
  }
}