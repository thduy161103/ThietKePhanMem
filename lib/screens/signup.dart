import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/user.dart';
import '../network/api_service.dart';
import '../network/otp.dart';
//import '../network/signup.dart';
import 'widgets/input_field.dart';
import '../utils/app_styles.dart';
import 'signin.dart';
import '../network/signup.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _avatarController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  File? _avatarFile;
  final ImagePicker _picker = ImagePicker();

  bool _isOtpVerified = false;

  void _requestOTP() async {
    try {
      final response = await OtpRequest.requestOtp(_phoneController.text);
      if (response.statusCode == 200) {
        _isOtpVerified = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP sent successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send OTP: $e')),
      );
    }
  }

  // void _verifyOTP() async {
  //   try {
  //     final response = await OtpRequest.verifyOtpInSignUp(_usernameController.text.toString(), _otpController.text.toString());
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         _isOtpVerified = true;
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('OTP verified successfully')),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('OTP verification failed: ${response.body}')),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('OTP verification failed: $e')),
  //     );
  //   }
  // }

  void _signUp() async {
    if (_formKey.currentState!.validate() && _isOtpVerified) {
      User newUser = User(
        fullName: _fullNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        avatar: _avatarController.text,
        dateOfBirth: _dateOfBirthController.text,
        sex: _sexController.text,
        facebook: _facebookController.text,
        role: _roleController.text,
        otp: _otpController.text,
      );

      try {
        //final response = await _dio.post('http://desktop-a2g83h7:8080/auth/register', data: newUser.toJson());
        //final response = await _apiService.post('auth/register', newUser.toJson());
        await signUpRequest.signUp(context, newUser.fullName, newUser.dateOfBirth, newUser.sex, newUser.facebook, newUser.role, newUser.avatar, newUser.otp.toString(), newUser.username, newUser.password, newUser.email, newUser.phone);
        // if (response.statusCode == 200) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('Sign up successful')),
        //   );
        //Chuyển qua trang đăng nhập
        // Navigator.push(context, MaterialPageRoute(builder: (context) => signInPage()));
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('Failed to sign up: ${response.data}')),
        //   );
        // }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign up: $e')),
        );
      }
    }
  }

  Future<void> _pickAndUploadAvatar() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _avatarFile = File(pickedFile.path);
      });

      // Upload to Firebase Storage
      try {
        final ref = FirebaseStorage.instance.ref().child('avatars').child(pickedFile.name);
        
        final uploadTask = ref.putFile(_avatarFile!);
        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        _avatarController.text = downloadUrl;
        
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload avatar: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _roleController.text = "ROLE_CUSTOMER";
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: AppStyles.getGradientDecoration(),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                height: MediaQuery.of(context).size.height * 2 / 3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: MediaQuery.of(context).size.width / 2.5,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Text("Sign up", style: AppStyles.getHeadlineStyle()),
                                  SizedBox(height: 20.0),
                                  CustomTextFormField(
                                    icon: Icons.person_outlined,
                                    hintText: 'Username',
                                    controller: _usernameController,
                                  ),
                                  SizedBox(height: 15.0),
                                  CustomTextFormField(
                                    icon: Icons.lock_outlined,
                                    hintText: 'Password',
                                    controller: _passwordController,
                                    obscureText: true,
                                  ),
                                  SizedBox(height: 15.0),
                                  CustomTextFormField(
                                    icon: Icons.person_outlined,
                                    hintText: 'Full Name',
                                    controller: _fullNameController,
                                  ),
                                  SizedBox(height: 15.0),
                                  CustomTextFormField(
                                    icon: Icons.email_outlined,
                                    hintText: 'Email',
                                    controller: _emailController,
                                  ),
                                  SizedBox(height: 15.0),
                                  // CustomTextFormField(
                                  //   icon: Icons.phone_outlined,
                                  //   hintText: 'Phone',
                                  //   controller: _phoneController,
                                  // ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextFormField(
                                          icon: Icons.phone,
                                          hintText: 'Phone Number',
                                          controller: _phoneController,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: _requestOTP,
                                        child: Text('Get OTP'),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15.0),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextFormField(
                                          icon: Icons.lock,
                                          hintText: 'OTP Code',
                                          controller: _otpController,
                                        ),
                                      ),
                                      // SizedBox(width: 10),
                                      // ElevatedButton(
                                      //   onPressed: _verifyOTP,
                                      //   child: Text('Verify OTP'),
                                      // ),
                                    ],
                                  ),
                                  SizedBox(height: 15.0),
                                  GestureDetector(
                                    onTap: () async {
                                      final DateTime? picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          _dateOfBirthController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                                        });
                                      }
                                    },
                                    child: AbsorbPointer(
                                      child: CustomTextFormField(
                                        icon: Icons.calendar_today,
                                        hintText: 'Date of Birth',
                                        controller: _dateOfBirthController,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  Row(
                                    children: [
                                      Icon(Icons.person_outline, color: Colors.grey),
                                      SizedBox(width: 10),
                                      Text('Sex:', style: TextStyle(color: Colors.grey)),
                                      Radio<String>(
                                        value: 'Male',
                                        groupValue: _sexController.text,
                                        onChanged: (value) {
                                          setState(() {
                                            _sexController.text = value!;
                                          });
                                        },
                                      ),
                                      Text('Male'),
                                      Radio<String>(
                                        value: 'Female',
                                        groupValue: _sexController.text,
                                        onChanged: (value) {
                                          setState(() {
                                            _sexController.text = value!;
                                          });
                                        },
                                      ),
                                      Text('Female'),
                                    ],
                                  ),
                                  SizedBox(height: 15.0),
                                  CustomTextFormField(
                                    icon: Icons.facebook,
                                    hintText: 'Facebook',
                                    controller: _facebookController,
                                  ),
                                  
                                  SizedBox(height: 20.0),
                                  GestureDetector(
                                    onTap: _pickAndUploadAvatar,
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: _avatarFile != null
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(40),
                                              child: Image.file(_avatarFile!, fit: BoxFit.cover),
                                            )
                                          : Icon(Icons.add_a_photo, size: 30),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  GestureDetector(
                                    onTap: _signUp,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 12.0),
                                      width: double.infinity,
                                      decoration: AppStyles.getButtonDecoration(),
                                      child: Center(
                                        child: Text("SIGN UP", style: AppStyles.getButtonTextStyle()),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => signInPage()));
                                    },
                                    child: Text('Already have an account? Sign in'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
