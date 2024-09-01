import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/user.dart';
import '../network/api_service.dart';

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

  File? _avatarFile;
  final ImagePicker _picker = ImagePicker();

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
        sex: _sexController.text,
        facebook: _facebookController.text,
        role: _roleController.text,
      );

      try {
        //final response = await _dio.post('http://desktop-a2g83h7:8080/auth/register', data: newUser.toJson());
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
        final ref = FirebaseStorage.instance.ref().child('avatars/${DateTime.now().toIso8601String()}');
        final uploadTask = ref.putFile(_avatarFile!);
        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          _avatarController.text = downloadUrl;
        });
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
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
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
              TextFormField(
                controller: _avatarController,
                decoration: InputDecoration(labelText: 'Avatar URL'),
                readOnly: true,
              ),
              TextFormField(
                controller: _dateOfBirthController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
              ),
              TextFormField(
                controller: _sexController,
                decoration: InputDecoration(labelText: 'Sex'),
              ),
              TextFormField(
                controller: _facebookController,
                decoration: InputDecoration(labelText: 'Facebook'),
              ),
              TextFormField(
                controller: _roleController,
                decoration: InputDecoration(labelText: 'Role'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUp,
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
