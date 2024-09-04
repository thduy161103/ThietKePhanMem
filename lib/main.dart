import 'package:flutter/material.dart';
import 'package:musicapp/screens/homepage.dart';
import 'screens/signin.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';
//import 'screens/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(isLoggin: true,));
}

class MyApp extends StatefulWidget {
  MyApp({super.key, required this.isLoggin});
  final bool isLoggin;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phone Email',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 4, 201, 135),
        ),
        useMaterial3: true,
      ),
      home: HomePage(), // Set the home to QuizScreen for testing
      //home: widget.isLoggin ? HomePage() : signInPage(),
    );
  }
}
