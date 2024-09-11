import 'package:flutter/material.dart';
import 'package:musicapp/network/point.dart';
import 'package:musicapp/screens/event_details_screen.dart';
import 'package:musicapp/screens/signin.dart'; // Add this import
import 'package:musicapp/songlist.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'clickapp.dart';
import 'drawer.dart';
import '../models/event.dart';
import '../models/user.dart';
import '../network/events.dart';
import '../network/user_api.dart';
import 'shakeapp.dart';
import '../utils/app_styles.dart';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>?> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeData();
    _initFuture.then((data) {
      if (data != null) {
        _updateUserProvider(context, data);
      }
    });
  }

  Future<Map<String, dynamic>?> _initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    developer.log('Token: $token');

    if (token == null || token.isEmpty) {
      developer.log('Token is null or empty');
      return null;
    }

    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      
      developer.log('Decoded token: $decodedToken');

    
  
      String userId = decodedToken['id'] as String;
      
      developer.log('User ID: $userId');

      // Don't use Provider here, just return the data
      final user = await UserApi.fetchUserData(userId);
      developer.log('Fetched user data: $user');

      final points = user.point;

      final events = await EventRequest.fetchEvents();
      developer.log('Fetched events: $events');

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(user);

      return {
        'userId': userId,
        'user': user,
        'points': points,
        'events': events,
      };
    } catch (e, stackTrace) {
      developer.log('Error initializing data: $e');
      developer.log('Stack trace: $stackTrace');
      return null;
    }
  }

  void _onEventTap(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsScreen(eventId: event.idSuKien, eventGame: event.gameName),
      ),
    );
  }

  void _openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void _updateUserProvider(BuildContext context, Map<String, dynamic> data) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setUserId(data['userId']);
    userProvider.setUser(data['user']);
    userProvider.setUserPoints(data['points']);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.data == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => signInPage()),
              (Route<dynamic> route) => false,
            );
          });
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        // Update UserProvider outside of build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updateUserProvider(context, snapshot.data!);
        });

        return _buildHomePage(snapshot.data!);
      },
    );
  }

  Widget _buildHomePage(Map<String, dynamic> data) {
    final User currentUser = data['user'];
    final List<Event> events = data['events'];

    return Scaffold(
      body: Container(
        decoration: AppStyles.getGradientDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                          icon: Icon(Icons.menu, color: Colors.white),
                          onPressed: () => _openDrawer(context),
                        );
                      },
                    ),
                    Text(
                      'Danh sách sự kiện',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 48), // To balance the layout
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        color: Colors.white, // Add this line to set the background color to white
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                              child: Image.network(
                                event.hinhAnh,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 150,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.error, color: Colors.red),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.tenSuKien,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Số lượng voucher: ${event.soLuongVoucher}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time, size: 18, color: Colors.black87),
                                      SizedBox(width: 4),
                                      Text(
                                        'Bắt đầu: ${(event.thoiGianBatDau)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time_filled, size: 18, color: Colors.black87),
                                      SizedBox(width: 4),
                                      Text(
                                        'Kết thúc: ${(event.thoiGianKetThuc)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 16, bottom: 16),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () => _onEventTap(event),
                                  child: Text(
                                    'Xem chi tiết',
                                    style: TextStyle(color: Colors.white), // Add this line to set the text color to white
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFff5c30),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
        drawer: MyDrawer(),
    );
  }
}


