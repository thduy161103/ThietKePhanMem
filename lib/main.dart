import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicapp/screens/homepage.dart';
import 'package:musicapp/screens/quiz/quiz_screen.dart';
//import 'package:musicapp/screens/drawer.dart';
//import 'package:musicapp/home.dart';
//import 'package:musicapp/screens/otppage.dart';

//import 'package:musicapp/screens/shakeapp.dart';
 // Import the quiz screen

//import 'package:phone_email_auth/phone_email_auth.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'screens/homepage.dart';
//import 'screens/quiz/quiz_screen.dart';
import 'screens/signin.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';
//import 'screens/signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,  // Add this line to remove the debug banner
    );
  }
}
