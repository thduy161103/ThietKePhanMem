import 'dart:convert';

import 'package:http/http.dart' as http;
import '../config/environment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PointRequest {
  static final String baseUrl = '${Environment.baseUrl}';

  static Future<int> getPoint(String userId) async {
    final response = await http.get(
      Uri.parse('${baseUrl}/user/point/$userId'),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load point');
    }
  }

  static Future<bool> updatePoint(String userId, String gameId, String eventId, int scores, int point) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/add-point'),
        body: jsonEncode(<String, dynamic>{
          "id": userId,
          "gameId": gameId,
          "eventId": eventId,
          "scores": scores,
          "point": point
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.statusCode);
      return response.statusCode == 200;
    } catch (e) {
      print("Error updating point: $e");
      return false;
    }
  }
}