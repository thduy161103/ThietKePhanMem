import 'package:flutter/material.dart';
import 'package:musicapp/screens/drawer.dart';
import 'package:musicapp/home.dart';
import 'package:musicapp/screens/test.dart';
import 'package:phone_email_auth/phone_email_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/homepage.dart';
import 'screens/signin.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  /// Initialize phone email function with
  /// Client Id
  PhoneEmail.initializeApp(clientId: '18867652854888250695');

  runApp( MyApp(isLoggin: isLoggedIn));
}

class MyApp extends StatefulWidget {
   MyApp({super.key, required this.isLoggin});
  bool isLoggin;
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
      home: SignUpPage(),
      //home: widget.isLoggin ? HomePage() : signInPage(),
    );
  }
}
