import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../network/signup.dart';
import 'signin.dart';

class signUpPage extends StatefulWidget {
  const signUpPage({super.key});

  @override
  State<signUpPage> createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  TextStyle _getTextFieldStyle() {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.grey[600],
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFff5c30),
                        Color(0xFFe74b1a),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                  height: MediaQuery.of(context).size.height / 2,
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
                          width: MediaQuery.of(context).size.width / 2.5, // Changed from 1.5 to 2.5
                          fit: BoxFit.contain, // Changed from cover to contain
                        ),
                      ),
                      SizedBox(height: 20.0), // Reduced the height from 30.0 to 20.0
                      Expanded(
                        child: SingleChildScrollView(
                          child: Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    SizedBox(height: 30.0),
                                    Text(
                                      "Sign up",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 30.0),
                                    TextFormField(
                                      controller: _usernameController,
                                      decoration: InputDecoration(
                                        hintText: 'Username',
                                        hintStyle: _getTextFieldStyle(),
                                        prefixIcon: Icon(Icons.person_outlined),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your username';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 30.0),
                                    TextFormField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        hintText: 'Email',
                                        hintStyle: _getTextFieldStyle(),
                                        prefixIcon: Icon(Icons.email_outlined),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 30.0),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        hintText: 'Password',
                                        hintStyle: _getTextFieldStyle(),
                                        prefixIcon: Icon(Icons.password_outlined),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 30.0),
                                    TextFormField(
                                      controller: _phoneController,
                                      decoration: InputDecoration(
                                        hintText: 'Phone',
                                        hintStyle: _getTextFieldStyle(),
                                        prefixIcon: Icon(Icons.phone_outlined),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your phone number';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 50.0),
                                    GestureDetector(
                                      onTap: () {
                                        if (_formKey.currentState!.validate()) {
                                          signUpRequest.signUp(
                                            context,
                                            _usernameController.text,
                                            _passwordController.text,
                                            _emailController.text,
                                            _phoneController.text,
                                          );
                                        }
                                      },
                                      child: Material(
                                        elevation: 5.0,
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 8.0),
                                          width: 200,
                                          decoration: BoxDecoration(
                                            color: Color(0Xffff5722),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "SIGN UP",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontFamily: 'Poppins1',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => signInPage()),
                                        );
                                      },
                                      child: Text('Nếu bạn đã có tài khoản hãy đăng nhập'),
                                    ),
                                    SizedBox(height: 20.0),
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
      ),
    );
  }
}
