import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../screens/otppage.dart';
import '../config/environment.dart';
import '../screens/signin.dart';


class signUpRequest {
  //thay đổi url thành api phù hợp
  static String urlFetch = '${Environment.baseUrl}/api/auth/register';
  static String urlPost = '${Environment.baseUrl}/auth/register';

  static List<User> parseUser(String responseBody) {
    var list = json.decode(responseBody) as List<dynamic>;
    List<User> users = list.map((model) => User.fromJson(model)).toList();
    return users;
  }

  static Future<List<User>> fetchUser({int page = 1}) async {
    final response = await http.get(Uri.parse(urlFetch + '?page=$page'));
    if (response.statusCode == 200) {
      return parseUser(response.body);
    } else {
      throw Exception('Unable to fetch data from the REST API');
    }
  }

  static Future<void> signUp(BuildContext context, String fullName, String dateOfBirth, String sex, String facebook, String role, String avatar, String otp, String username, String password, String email, String phone) async {
    print('signUpRequest: signUp called');
    final response = await http.post(
      Uri.parse(urlPost),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
        'email': email,
        'phone': phone,
        'fullName': fullName,
        'dateOfBirth': dateOfBirth,
        'sex': sex,
        'facebook': facebook,
        'role': role,
        'avatar': avatar,
        'otp': otp,
      }),
    );

    if (response.statusCode == 200) {
      print('signUpRequest: signUp successful');
      // If the server returns an OK response, navigate to the OTP page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => signInPage()),
      );
    } else {
      // If the server did not return an OK response, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign up: ${response.body}')),
      );
    }
  }
}
