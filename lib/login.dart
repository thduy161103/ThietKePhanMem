import 'package:flutter/material.dart';
import 'package:phone_email_auth/phone_email_auth.dart';

class CenterButtonScreen extends StatefulWidget {
  const CenterButtonScreen({required Key key}) : super(key: key);

  @override
  _CenterButtonScreenState createState() => _CenterButtonScreenState();
}

class _CenterButtonScreenState extends State<CenterButtonScreen> {
  String useraccessToken = '';
  String jwtUserToken = '';
  bool hasUserLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Center Button Screen'),
      ),
      body: Center(
        child: Align(
          alignment: Alignment.center,
          child: PhoneLoginButton(
            borderRadius: 10,
            buttonColor: Colors.teal,
            label: 'Login with Phone',
            onSuccess: (String accessToken, String jwtToken) {
              if (accessToken.isNotEmpty) {
                setState(() {
                  useraccessToken = accessToken;
                  jwtUserToken = jwtToken;
                  hasUserLogin = true;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}