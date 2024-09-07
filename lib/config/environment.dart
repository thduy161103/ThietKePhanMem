import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'http://localhost:8080';
}
