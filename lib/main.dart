import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicapp/screens/event_details_screen.dart';
import 'package:musicapp/screens/homepage.dart';
import 'package:musicapp/screens/player_screen.dart';
import 'package:musicapp/screens/quiz/quiz_screen.dart';
import 'package:uni_links/uni_links.dart';
//import 'package:musicapp/screens/drawer.dart';
//import 'package:musicapp/home.dart';
//import 'package:musicapp/screens/otppage.dart';

//import 'package:phone_email_auth/phone_email_auth.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'screens/homepage.dart';
//import 'screens/quiz/quiz_screen.dart';
import 'screens/signin.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'firebase_options.dart';
//import 'screens/signup.dart';

import 'package:provider/provider.dart';
import 'providers/user_provider.dart';

  
import 'dart:async';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  Future<void> initUniLinks() async {
    // Handle incoming links - deep linking
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        handleDeepLink(uri);
      }
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
      print('Failed to handle deep link: $err');
    });

    // Handle any initial link - deep linking
    try {
      final initialUri = await getInitialUri();
      if (initialUri != null) {
        handleDeepLink(initialUri);
      }
    } catch (e) {
      print('Failed to get initial uri: $e');
    }
  }

  void handleDeepLink(Uri uri) {
    print('Deep link received: $uri');
    print('Scheme: ${uri.scheme}');
    print('Host: ${uri.host}');
    print('Path: ${uri.path}');
    
    if (uri.scheme == 'musicapp' || (uri.host == 'localhost' && uri.port == 6969 && uri.path.startsWith('/player'))) {
      // Navigate to player screen
      Get.to(() => PlayerScreen()); // Assuming you have a PlayerScreen
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false, 
    );
  }
}
