import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'otpscreen.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Auth'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Phone Auth',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  // hintText: 'Enter Phone NumberlabelText: 'Phone Number',
                  suffixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                print(phoneController.text);
                // Gửi mã OTP đến số điện thoại đã nhập bằng cách sử dụng phương thức verifyPhoneNumber của FirebaseAuth
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: phoneController.text.toString(),
                  verificationCompleted: (PhoneAuthCredential credential) {
                    print('verificationCompleted');
                        (PhoneAuthCredential credential) {
                      FirebaseAuth.instance.signInWithCredential(credential);
                    };
                  },
                  verificationFailed: (FirebaseAuthException e) {
                    print('verificationFailed');
                        (FirebaseAuthException ex){

                    };
                  },
                  codeSent: (String verificationId, int? resendToken) {
                    print('codeSent');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OTPScreen(
                          verificationId: verificationId,
                        ),
                      ),
                    );
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {
                    print('codeAutoRetrievalTimeout');
                  },

                );
              },
              child: const Text('Send OTP'),

            )
          ],
        ),
      ),
    );
  }
}