import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:musicapp/models/event_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event.dart';
import '../config/environment.dart';

class EventRequest {
  static final String baseUrl = '${Environment.baseUrl}/brand/api/event/';
  static final String url = '${baseUrl}allevent/';

  static Future<List<Event>> fetchEvents() async {
    print('Fetching events from: $url');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedData = jsonDecode(response.body);
        
        if (decodedData['success'] == true && decodedData['events'] is List) {
          List<dynamic> eventsData = decodedData['events'];
          print('Parsed events data: $eventsData');
          
          List<Event> events = eventsData.map((json) => Event.fromJson(json)).toList();
          print('Converted to ${events.length} Event objects');
          return events;
        } else {
          print('Unexpected data format or success is false');
          throw Exception('Unexpected data format');
        }
      } else {
        print('Failed to load events. Status code: ${response.statusCode}');
        throw Exception('Failed to load events');
      }
    } catch (e) {
      print('Error occurred while fetching events: $e');
      rethrow;
    }
  }

  static Future<EventDetail> fetchEventDetail(String eventId) async {
    final response = await http.get(Uri.parse('$baseUrl/detailevent/$eventId'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return EventDetail.fromJson(jsonData['events'][0]);
    } else {
      throw Exception('Failed to load event details');
    }
  }
}