import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/homepage.dart';
import '../config/environment.dart';

class OtpRequest {
  static String url = '${Environment.baseUrl}/auth/validate-otp';

  static Future<http.Response> requestOtp(String phoneNumber) async { 
    final response = await http.post(
      Uri.parse('${Environment.baseUrl}/auth/validate-phone'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone': phoneNumber,
      }),
    );
    return response;
  }
  static Future<http.Response> verifyOtpInSignUp(String otp, String username) async {
    final response = await http.post(
      Uri.parse('${Environment.baseUrl}/auth/validate-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'otp': otp,
      }),
    );
    return response;
  }
  static Future<void> verifyOtp(BuildContext context, String otp, String username) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'otp': otp,
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Decoded response: $responseData');
        
        final accessToken = responseData['accessToken'];
        
        if (accessToken != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('accessToken', accessToken);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: Access token not received. Response: ${response.body}')),
          );
        }
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to verify OTP')),
        );
      }
    } catch (e) {
      print('Error in verifyOtp: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }
}