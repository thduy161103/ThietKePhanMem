import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  String? _userId;
  int _userPoints = 0;

  User? get user => _user;
  String? get userId => _userId;
  int get userPoints => _userPoints;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }

  void setUserPoints(int points) {
    _userPoints = points;
    notifyListeners();
  }
}