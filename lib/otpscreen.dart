import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'dart:developer';


class OTPScreen extends StatefulWidget {
  final String verificationId;
  const OTPScreen({super.key, required this.verificationId});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'OTP Screen',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter OTP',
                  labelText: 'OTP',
                  suffixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                try {
                  PhoneAuthCredential phoneAuthCredential = await PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: otpController.text.toString(),
                  );
                  await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential)
                  .then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MusicHome()),
                    );
                  });
                }
                catch (e) {
                  log(e.toString());
                }
                },
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
