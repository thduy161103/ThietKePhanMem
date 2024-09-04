import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:musicapp/screens/signin.dart';
import '../models/user.dart';
import '../network/api_service.dart';
import 'widgets/input_field.dart';
import '../utils/app_styles.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'; // Add this import instead

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
  final TextEditingController _facebookController = TextEditingController();

  File? _avatarFile;
  final ImagePicker _picker = ImagePicker();

  String _selectedSex = 'Male'; // Default value
  String _selectedDate = 'Select Date of Birth';

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      User newUser = User(
        fullName: _fullNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        avatar: _avatarController.text,
        dateOfBirth: _dateOfBirthController.text,
        sex: _selectedSex, // Use _selectedSex here
        facebook: _facebookController.text,
        role: "ROLE_USER",
      );

      try {
        final response = await _apiService.post('auth/register', newUser.toJson());
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign up successful')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to sign up: ${response.data}')),
          );
        }
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
        final ref = FirebaseStorage.instance.ref().child('avatars').child('image.png');
        
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
                                  SizedBox(height: 30.0),
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      // Email regex pattern
                                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                      if (!emailRegex.hasMatch(value)) {
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 15.0),
                                  CustomTextFormField(
                                    icon: Icons.phone_outlined,
                                    hintText: 'Phone',
                                    controller: _phoneController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your phone number';
                                      }
                                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                        return 'Please enter a valid phone number';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 15.0),
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
                                    obscureText: true,  // This ensures the password is hidden
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      // You can add more password validation here if needed
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 15.0),
                                  GestureDetector(
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                      ).then((pickedDate) {
                                        if (pickedDate != null) {
                                          setState(() {
                                            _selectedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                                            _dateOfBirthController.text = _selectedDate;
                                          });
                                        }
                                      });
                                    },
                                    child: AbsorbPointer(
                                      child: CustomTextFormField(
                                        icon: Icons.calendar_today,
                                        hintText: _selectedDate,
                                        controller: _dateOfBirthController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty || value == 'Select Date of Birth') {
                                            return 'Please select your date of birth';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  DropdownButtonFormField<String>(
                                    value: _selectedSex,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.person_outline),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: Color(0xFFff5c30)),
                                      ),
                                    ),
                                    items: <String>['Male', 'Female', 'Others']
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedSex = newValue!;
                                      });
                                    },
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
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: _avatarFile != null
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(50),
                                              child: Image.file(_avatarFile!, fit: BoxFit.cover),
                                            )
                                          : Icon(Icons.add_a_photo, size: 40),
                                    ),
                                  ),
                                  SizedBox(height: 30.0),
                                  GestureDetector(
                                    onTap: _signUp,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 15.0),
                                      width: double.infinity,
                                      decoration: AppStyles.getButtonDecoration(),
                                      child: Center(
                                        child: Text("SIGN UP", style: AppStyles.getButtonTextStyle()),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
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
