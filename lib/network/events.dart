import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';

class EventRequest {
  static const String url = 'https://yourapi.com/events';

  static Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }
}