import 'package:http/http.dart' as http;
import '../config/environment.dart';

class PointRequest {
  static final String baseUrl = '${Environment.baseUrl}';

  static Future<int> getPoint(String userId) async {
    final response = await http.get(
      Uri.parse('${baseUrl}/user/point/$userId'),
    );
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load point');
    }
  }

  static Future<bool> updatePoint(String userId, int point) async {
    final response = await http.put(
      Uri.parse('${baseUrl}/user/point/$userId'),
      body: {'point': point},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }


}