import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../network/otp.dart';

class OtpPage extends StatefulWidget {
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  @override
  Future<void> dispose() async {
    _otpController.dispose();

    super.dispose();
  }

  Future<void> _clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.setBool('isLoggedIn', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _otpController,
                decoration: InputDecoration(labelText: 'OTP'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the OTP';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    OtpRequest.verifyOtp(context, _otpController.text);
                  }

                },
                child: Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}