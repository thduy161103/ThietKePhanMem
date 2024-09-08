import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import '../utils/app_styles.dart';
import '../models/user.dart'; // Import the user model
import 'all_vouchers_page.dart';
import 'homepage.dart';
import 'my_voucher_page.dart';

class MyDrawer extends StatelessWidget {
  final User user;

  MyDrawer({required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 200,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                  // Removed the borderRadius
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFFff5c30),
                      child: Text(
                        user.username.isNotEmpty ? user.username[0].toUpperCase() : '',
                        style: TextStyle(fontSize: 40.0, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      user.username,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.email,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.black),
              title: Text('Home', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.card_giftcard, color: Colors.black),
              title: Text('My Vouchers', style: TextStyle(color: Colors.black)),
              onTap: () {
                // Navigate to profile page
                Navigator.pop(context); // Close the drawer
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyVoucherPage()),
                );
              },
            ), 
            ListTile(
              leading: Icon(Icons.list, color: Colors.black),
              title: Text('All Vouchers', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.pop(context); // Đóng drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllVouchersPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.black),
              title: Text('Logout', style: TextStyle(color: Colors.black)),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}