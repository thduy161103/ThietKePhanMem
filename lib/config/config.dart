import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class Config {
  static String get apiBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080';  // For web
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080';  // For Android emulator
    } else if (Platform.isIOS) {
      return 'http://localhost:8080';  // For iOS simulator
    } else {
      return 'http://YOUR_LOCAL_IP:8080';  // For physical devices, replace with your machine's IP
    }
  }
}