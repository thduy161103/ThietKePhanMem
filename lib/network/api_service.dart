import 'package:dio/dio.dart';
import '../config/environment.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = '${Environment.baseUrl}/';
    _dio.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  Future<Response> post(String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } on DioError catch (e) {
      throw Exception('Failed to post data: ${e.response?.data}');
    }
  }

  // Add other methods (get, put, delete) as needed
}// TODO Implement this library.